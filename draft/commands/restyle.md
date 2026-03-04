---
description: Take an existing message and rewrite it in your authentic voice. Paste text or provide a Slack message link.
user_invocable: true
---

# Restyle Message

Takes an existing message (pasted text or Slack link) and rewrites it in the user's authentic voice while preserving the core content and intent.

## Voice

Follow the user's voice profile loaded from `memory/draft/voice-profile.md`. If no profile exists, use the uncalibrated defaults from `skills/voice-identity/SKILL.md`. Transform the input while keeping the substance.

## Process

### 1. Get the Input

Accept one of:
- **Pasted text:** Use directly
- **Slack message link:** Read via `slack_read_thread` or `slack_read_channel` MCP to extract the message content

If the user provides neither, ask: "Paste the message you want me to restyle, or share a Slack link."

### 2. Load Voice Profile

Read `memory/draft/voice-profile.md` if it exists. This is the primary reference for how the output should sound.

### 3. Analyse the Original

Identify:
- **Intent:** What is this message trying to accomplish?
- **Audience:** Who is it for?
- **Current tone:** Formal? Casual? Corporate? Technical?
- **Key content:** Facts, decisions, asks that must be preserved
- **Problems:** Jargon, passive voice, unclear structure, wrong tone, too long

### 4. Select Target Style

Auto-detect the best style based on the content and intent (using rules from `skills/voice-identity/SKILL.md`).

If the user specified a target style, use it. Otherwise, present your detection: "This looks like a [Style Name] — I'll restyle it that way. Want a different style?"

### 5. Read Style Resources

Load both layers:
1. Generic `resources/styles/<style>.md` for structure template
2. User's `memory/draft/styles/<style>.md` (if it exists) for real examples

### 6. Rewrite

Transform the message:
1. Preserve ALL factual content, decisions, and action items
2. Apply the user's voice identity (from profile: language, tone, cadence, formatting)
3. Follow the style-specific structure template
4. Fix anti-patterns (jargon, passive voice, hedge piling — check user's anti-patterns list)
5. Adjust length for the channel/audience

### 7. Present Before/After

Show both versions with brief annotations:

```
**Original:**
[original message]

**Restyled** (Style: [name]):
[new message]

**Changes:**
- [What changed and why — 2-3 bullet points]
```

### 8. Iterate and Deliver

Same as `/draft:draft` steps 9-10:
- Accept feedback and adjust
- Offer to send via Slack MCP, as draft, or copy-paste

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| Voice profile not found | Use uncalibrated defaults. Suggest `/draft:setup`. |
| Slack MCP unavailable | Cannot read Slack links — ask for pasted text instead |
| Style ambiguous | Ask user to choose target style |
