---
description: Draft a Slack message or email in your authentic voice. Full lifecycle — gather context, select style, draft, review, iterate, deliver.
user_invocable: true
---

# Draft Message

The core drafting workflow. Takes a request and produces a polished message ready to send, written in the user's authentic voice.

## Voice

Follow the user's voice profile loaded from `memory/draft/voice-profile.md`. If no profile exists, use the uncalibrated defaults from `skills/voice-identity/SKILL.md`. Write AS the user, not FOR the user. The output should be indistinguishable from something they wrote themselves.

## Process

### 1. Gather Inputs

Parse the user's request. If key information is missing, ask — but don't over-interrogate. Infer what you can.

**Required (ask if missing):**
- **Topic/content:** What the message is about
- **Audience:** Who will read it (person, group, channel)

**Optional (infer or ask only if relevant):**
- **Channel/medium:** Slack channel, DM, email (default: Slack)
- **Style preference:** If the user names a style, use it
- **Constraints:** Tone, length, things to include/avoid, deadline

If the user provides a free-form description like "tell the engineering team about the new deploy process", that's enough — infer audience, style, and draft.

### 2. Spawn Background Workers

Launch in parallel (only if useful — skip for simple short messages):

- **pcm-lookup** (if specific named recipients): Spawn with `run_in_background: true`, model haiku. Pass recipient names. Returns PCM base/phase.
- **context-gatherer** (if topic benefits from context): Spawn with `run_in_background: true`, model haiku. Pass topic keywords. Returns relevant kbx/Slack context.

Don't wait to start drafting — use results when they arrive to refine.

### 3. Select Style

Use the auto-detection rules from `skills/voice-identity/SKILL.md`:

| Signal | Style |
|--------|-------|
| Audience > 20, announcement topic | Strategic Announcement |
| "@person do X", decision-making | Action-Oriented |
| Sharing article/link/learning | Knowledge Share |
| Celebrating, thanking | Motivator & Supporter |
| Incident, bad news, delay | Crisis & Difficult News |
| RFC, proposal, "what do you think" | Building Alignment |
| New hire, welcome | Onboarding & Welcoming |
| Values, culture, well-being | Cultural Reinforcement |

Also check if the user has custom styles in `memory/draft/styles/` that might be a better fit.

If ambiguous between two styles, ask: "This feels like it could be [X] or [Y] — which fits better?"

If the user specified a style, use it regardless of auto-detection.

### 4. Read Style Resources

Load both layers for the selected style:

1. **Generic template:** Read `resources/styles/<style>.md` for structure, key characteristics, and common mistakes
2. **User's examples:** Read `memory/draft/styles/<style>.md` (if it exists) for the user's real examples and voice notes

Merge: use the generic template as structure, the user's examples as voice reference.

### 5. Draft the Message

Write the message following:
1. The user's voice profile (from `memory/draft/voice-profile.md`)
2. The style-specific structure template
3. The user's real examples as tone/cadence reference
4. PCM adaptations if background worker returned a profile
5. Any user-specified constraints

**Writing checklist:**
- [ ] Main point in the first sentence or two (BLUF if user's profile indicates it)
- [ ] Language consistent with user's spelling convention
- [ ] No anti-pattern language (check user's anti-patterns list)
- [ ] Appropriate length for the channel and audience size
- [ ] Specific rather than generic (names, dates, concrete details)
- [ ] Clear next step or call to action
- [ ] Emoji usage matches user's preference

### 6. Message Coach Review

**Skip this step for short messages** (under ~50 words) — thread replies, motivator one-liners, quick acknowledgements. The coach adds value on substantive drafts, not on "Thanks for the quick fix! :muscle:".

For longer or higher-stakes drafts, spawn the **message-coach** worker (`agents/message-coach.md`, model: sonnet, `run_in_background: true`). Pass it:
- The drafted message
- Target audience and channel
- The communication style used

The coach reviews against the message excellence framework (`resources/frameworks/message-excellence.md`) and returns:
- A verdict (Strong / Needs work / Major revision)
- Top 2-3 improvements ranked by impact with specific rewrites
- What's already working

**Incorporate the most impactful feedback** while keeping the user's voice intact. Don't accept every suggestion blindly — the voice profile takes precedence over generic communication advice.

### 7. Self-Review Pass

After incorporating coach feedback, final check:
- Does this pass the "would someone who knows me believe I wrote this?" test?
- Is the language consistent with the user's profile? (spelling, greetings, sign-offs)
- Are any of the user's anti-pattern words present? Remove them.
- Is the length appropriate for the channel?
- If PCM data is available, is the tone calibrated?

### 8. Present the Draft

Show the message in a clean, copy-pasteable format:

```
**Style:** [detected style]
**Audience:** [who]
**Channel:** [where]

---

[The drafted message]

---
```

If PCM adaptations were made, note them briefly below the message.

### 9. Iterate

Ask: "Want to adjust anything? I can change tone, length, emphasis, or switch to a different style."

Accept feedback and redraft. If the user suggests something that contradicts their voice profile, note it — but ultimately defer to them.

### 10. Deliver

When the user approves, offer delivery options:

1. **Send via Slack** — use `slack_send_message` MCP tool (ask for channel confirmation first)
2. **Send as Slack draft** — use `slack_send_message_draft` MCP tool
3. **Copy-paste** — present as a clean code block (default if Slack MCP unavailable)
4. **Email draft** — use `gmail_create_draft` MCP tool (if email medium)

Always confirm the channel/recipient before sending.

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| Voice profile not found | Use uncalibrated defaults from voice-identity skill. Note it. |
| User style file not found | Use generic style resource only. |
| kbx unavailable | Skip PCM lookup and context gathering. Draft with loaded profile. |
| Slack MCP unavailable | Present as copy-paste text only |
| Gmail MCP unavailable | Present email as formatted text |
| PCM profile not found | Draft without audience adaptation, note it |
| Style ambiguous | Ask the user to choose |
| User provides minimal input | Infer what you can, ask for the rest |
