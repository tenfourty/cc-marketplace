---
description: "Audience Adaptation"
always_on: true
---

# Audience Adaptation

How to tailor messages for different audiences, channels, and individuals. The voice stays the same — the calibration changes.

## PCM-Aware Drafting

kbx stores Process Communication Model profiles for many people. When drafting for a specific person, look up their profile and adapt.

### PCM Lookup Process

1. `kbx person find "Name" --json` — check `pcm_base` and `pcm_phase` in metadata
2. If not found: `kbx search "Name PCM" --fast --limit 3`
3. If still not found: draft without PCM adaptation, note it to the user

### Adapting for Each Base Type

**Thinker:** Lead with data and structure. Logical flow matters. Present options with clear reasoning. The voice naturally does this — lean into it.

**Persister:** Acknowledge their commitment and values first. Frame requests as values-aligned ("This matters because..."). Respect their opinion — ask for it explicitly.

**Harmoniser:** Add personal warmth before business. "How's your week going?" A sentence of connection before the ask. They need to feel seen as a person, not just a role.

**Imaginer:** Be directive and explicit. Clear asks, clear deadlines, clear format. Don't leave room for interpretation. Short sentences. One thing at a time.

**Rebel:** Keep energy up. Lighter tone, use humour where appropriate. Short messages. Frame things as fun or interesting challenges, not obligations.

**Promoter:** Get to the point fast. Frame as opportunity or challenge. They respect directness and action. Skip the preamble entirely.

### When NOT to Adapt

- Group messages (10+ people): use the default voice, don't tailor to one person
- Public channels: default voice always
- Only adapt for DMs and small-group messages where you know the recipients

## Channel Conventions

### Slack

- **Thread-first:** lead with the point in the main message, details in thread
- **Emoji reactions:** use sparingly, match the channel culture
- **@mentions:** tag people when action is needed, not for FYI
- **Channel tone varies:**
  - `#general` — lighter, more personal, cultural
  - `#engineering` — technical, structured, BLUF
  - `#incidents` — structured, factual, calm authority
  - Team channels — conversational, collaborative
- **Length:** aim for under 300 words in the main message. Expand in thread if needed.

### Email

- **Subject line:** specific, actionable ("Decision needed: auth migration approach")
- **Greeting:** "Hi [Name]," or "Hi folks,"
- **Sign-off:** just the name, no formality
- **Quote sparingly:** summarise context instead of long quote chains
- **Bullet lists** for action items
- **Keep it shorter than you think:** if it's over 500 words, consider whether Slack + a doc link would be better

## Audience Size Calibration

| Audience | Tone | Structure | Length |
|----------|------|-----------|--------|
| 1:1 DM | Most casual, most direct | Minimal | Short |
| Small group (2-8) | Conversational, collaborative | Light structure | Medium |
| Team channel (10-30) | Structured but warm | Headings, bullets | Medium-long |
| Org-wide (30+) | Most structured, BLUF | Clear sections, bolded headings | Long OK |
| External | Slightly more formal but still authentic | Professional structure | Varies |

## Email vs Slack Decision

Suggest email over Slack when:
- The recipient is external
- The message needs a paper trail (decisions, commitments)
- It's a long-form document that would be awkward in Slack
- The topic is sensitive and shouldn't be in a searchable channel

Suggest Slack over email when:
- Speed matters
- You want quick feedback or reactions
- The team is already discussing it in a channel
- It's informal or culture-building

## Multiple Recipients

When drafting for a group with known PCM profiles:
1. Default to the channel's natural tone
2. If one person is the primary action-owner, subtly weight towards their base
3. For sensitive messages (performance, difficult news), always adapt to the recipient's base
4. Note any PCM adaptations to the user so they can review
