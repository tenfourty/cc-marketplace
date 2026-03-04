---
description: First-run voice calibration — deep scan, sample collection, Q&A, voice analysis. 5-10 minutes.
user_invocable: true
---

# Draft Setup

Rich onboarding to calibrate the draft to your authentic voice. Scans your messaging history, collects samples, asks questions, then saves a voice profile and style examples to kbx for future sessions.

## Voice

Conversational and collaborative. You're learning about the user's voice, not lecturing them. One question at a time.

## Process

### 1. Pre-Check

Check for an existing profile:

```
Check if memory/draft/voice-profile.md exists (Read tool)
```

| Condition | Action |
|-----------|--------|
| Profile exists | Show current profile summary, offer: update, start fresh, or cancel |
| No profile | Proceed with setup |

### 2. Welcome

> Let's calibrate your voice. This takes about 5-10 minutes — I'll scan your recent messages, ask some questions, and build a voice profile.
>
> At the end, I'll save everything so future drafting sessions sound like you.

### 3. Phase 1 — Deep Scan (background)

Spawn a background worker to scan the user's messaging history:

**Slack scan** (if Slack MCP available):
- `slack_search_public` for recent messages from the user across channels
- Aim for 20-30 representative messages across different contexts (announcements, threads, praise, decisions)
- Categorise each message by apparent style

**Gmail scan** (if Gmail MCP available):
- `gmail_search_messages` for recent sent emails
- Focus on substantive messages (skip auto-replies, one-liners)
- Collect 5-10 representative emails

While the scan runs, proceed to Phase 2.

### 4. Phase 2 — User Samples

Present scan findings when available:

> I found [N] messages across [M] contexts. Here are the ones that seem most distinctive:
>
> [Show 3-5 most characteristic messages with detected style labels]

Then ask:

> Do you have 2-3 additional messages that feel most "you"? Paste them here or share Slack links.
>
> These are the messages where someone who knows you would say "that's definitely [Name]."

Accept:
- **Pasted text:** Use directly
- **Slack links:** Read via `slack_read_thread` or `slack_read_channel` MCP
- **"Skip":** Proceed with scan data only

### 5. Phase 3 — Q&A (one question at a time)

Ask these in sequence. Use `AskUserQuestion` with multiple-choice where possible. Skip questions that are already clearly answered by the scan data.

**Q1: Role and audience**
> What's your role, and who do you primarily communicate with? (This helps me calibrate formality and authority level.)

**Q2: Tone (3 words)**
> How would you describe your communication style in 3 words?

**Q3: Language**
> Which English spelling convention do you use?
> - British English (colour, organise, behaviour)
> - American English (color, organize, behavior)
> - Other / mixed

**Q4: Greetings**
> How do you typically open group messages? (e.g., "Hi folks", "Hey team", "Good morning everyone")

**Q5: Sign-offs**
> How do you close messages? (e.g., just your name, "Thanks!", "Have a great weekend!", no sign-off)

**Q6: Anti-patterns**
> Any words or phrases you hate or want to avoid? Corporate jargon, particular expressions, anything that makes you cringe when you see it in a message?

**Q7: Emoji**
> How do you use emoji?
> - Sparingly and naturally (1-2 per message max)
> - Frequently (multiple per message, emoji reactions)
> - Rarely / never

**Q8: Formatting**
> Do you prefer bullets, prose, or mixed? Do you use bold for emphasis?

**Q9: Overused phrases**
> Any patterns you tend to overuse that we should vary? (Most people have 2-3.)

**Q10: Sensitive topics**
> Any topics that need special care? (Sensitive projects, specific people, political subjects within the org.)

### 6. Phase 4 — Analysis

Synthesise all data (scan + samples + Q&A) into a voice fingerprint:

1. **Analyse patterns** across all collected messages:
   - Sentence length and rhythm
   - Greeting/sign-off patterns
   - Emoji frequency and types
   - Formatting preferences (bullets vs prose, bolding)
   - Vocabulary patterns (favourite words, phrases)
   - Communication philosophy (BLUF? storytelling? question-led?)

2. **Detect communication styles** from the corpus:
   - Map messages to the 8 default categories (Strategic Announcement, Action-Oriented, etc.)
   - Flag categories with no examples ("You don't seem to use Knowledge Share style often")
   - Identify any styles not covered by the defaults ("You have a distinct 'weekly reflection' style")

3. **Present the profile:**

> Here's what I've learned about your voice:
>
> **Identity:** [role, tone description]
> **Language:** [spelling, greetings, sign-offs]
> **Writing cadence:** [sentence rhythm, paragraph style]
> **Formatting:** [emoji, bold, bullets preferences]
> **Anti-patterns:** [words to avoid]
> **Sensitive topics:** [areas needing care]
>
> **Detected styles** (with example counts):
> - Strategic Announcement: [N] examples
> - Action-Oriented: [N] examples
> - [etc.]
> - [Custom style if detected]: [N] examples
>
> Does this capture your voice? Anything to adjust?

### 7. Phase 5 — Review & Save

Accept adjustments, then save:

1. **Voice profile** — write to `memory/draft/voice-profile.md`:
   - Use the format defined in `skills/voice-identity/SKILL.md`
   - Include all sections: Identity, Language, Anti-Patterns, Writing Cadence, Formatting, Sensitive Topics

2. **Style files** — write to `memory/draft/styles/<style-name>.md` for each detected style:
   - YAML frontmatter: title, type (draft-style), style slug, tags
   - Voice Notes section: style-specific observations
   - Examples section: the user's real messages for this style with annotations

3. **Confirm:**

> Voice profile saved with [N] style files.
>
> You can update anytime by running `/draft:setup` again.
>
> Ready to draft something? Run `/draft:boot` or just tell me what you need.

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| Slack MCP unavailable | Skip deep scan. Ask user to paste 5-10 sample messages instead. |
| Gmail MCP unavailable | Skip email scan. Slack + pasted samples are enough. |
| Both MCPs unavailable | Full manual mode — rely on pasted samples + Q&A only. |
| User skips questions | Work with whatever they provide — any data is better than none. |
| kbx/file write fails | Present the profile as formatted text for the user to save manually. |
