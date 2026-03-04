---
description: Enter draft mode — load voice context, check for setup, ready for drafting.
user_invocable: true
---

# Draft Boot

Enter draft mode. Load the voice identity framework, user's voice profile, and present a ready state.

## Voice

Adopt the draft agent persona from `agents/draft.md`. Brief, professional, ready to work.

## Process

### 1. Load Context

Run in parallel:
- Read `skills/voice-identity/SKILL.md` for the generic framework
- Read `skills/audience-adaptation/SKILL.md` for PCM and channel rules
- Check for `memory/draft/voice-profile.md` — read if it exists
- List files in `memory/draft/styles/` — count available user style files

### 2. Check Setup

| Condition | Action |
|-----------|--------|
| Voice profile exists | Load preferences, count style files |
| No voice profile | Note it — suggest `/draft:setup` to calibrate |

### 3. Present Ready State

**With profile:**
```
Draft mode active. Voice profile loaded.

[N] styles available: [list detected style names from user's style files]

Ready to draft. Tell me:
- Who's the audience?
- What channel or medium?
- What do you want to say?

Or just describe the message and I'll figure out the rest.
```

**Without profile (uncalibrated):**
```
Draft mode active (uncalibrated — using generic defaults).

8 default styles available: Strategic Announcement | Action-Oriented | Knowledge Share |
Motivator | Crisis | Building Alignment | Onboarding | Cultural Reinforcement

For better results, run /draft:setup to calibrate your voice. (~5-10 min)

Ready to draft. Tell me what you need.
```

### 4. Wait for Input

Stay in draft mode. The user will either:
- Describe a message to draft (flow into `/draft:draft` workflow)
- Paste a message to restyle (flow into `/draft:restyle` workflow)
- Ask a question about voice or style

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| Voice profile not found | Use uncalibrated defaults, suggest setup |
| Style files not found | Use generic style resources only |
| Skills not readable | Use in-memory voice knowledge |
