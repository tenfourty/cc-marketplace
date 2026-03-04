# draft — Voice-Accurate Message Drafting

Drafts Slack messages and emails in your authentic voice. Customisable communication styles, PCM-aware audience adaptation, and optional Slack MCP delivery.

## How It Works

Draft uses a two-layer architecture:

1. **Generic framework** (ships with the plugin) — 8 communication style templates, a message excellence framework, PCM audience adaptation rules, and a voice identity skill that defines the system.
2. **Your voice profile** (stored locally in kbx) — your real examples, preferences, anti-patterns, and writing cadence. Created by `/draft:setup` and loaded on every session.

The plugin works without setup (using sensible defaults), but calibrating your voice makes the output significantly better.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/claude-code) v1.0+
- [kbx](https://github.com/tenfourty/kbx) — knowledge base (people context, PCM profiles, voice profile storage)

## Installation

From this marketplace:
```
claude plugins marketplace add github:tenfourty/cc-marketplace
claude plugins install draft
```

Or from a local directory:
```
claude plugins add <path-to-this-directory>
```

## Getting Started

1. **Run setup** (5-10 min, one time): `/draft:setup` — scans your Slack/Gmail, collects samples, asks questions, saves your voice profile
2. **Boot up**: `/draft:boot` — loads your voice and presents a ready state
3. **Draft**: `/draft:draft` — describe what you want to say, and the agent writes it in your voice

## Commands

| Command | Description | Duration |
|---------|-------------|----------|
| `/draft:boot` | Enter draft mode — load voice context, ready for drafting | 30 sec |
| `/draft:draft` | Draft a message — style detection, PCM adaptation, review, delivery | 2-5 min |
| `/draft:restyle` | Rewrite an existing message in your voice | 1-3 min |
| `/draft:setup` | Voice calibration — deep scan, sample collection, Q&A, analysis | 5-10 min |

## Communication Styles

8 built-in styles (customisable during setup):

1. **Strategic Announcement** — long-form structured org-wide comms
2. **Action-Oriented Conversation** — quick decisions, unblocking, thread replies
3. **Knowledge Share** — articles, summaries, "so what for us"
4. **Motivator & Supporter** — praise, wins, shout-outs
5. **Crisis & Difficult News** — incidents, bad news, post-mortems
6. **Building Alignment** — RFCs, feedback requests, consensus building
7. **Onboarding & Welcoming** — new hire welcomes
8. **Cultural Reinforcement** — values, well-being, vulnerability

Setup can also detect custom styles from your messaging patterns.

## Voice Profile Storage

Your voice data is stored locally in kbx (never in the plugin):

```
memory/draft/
  voice-profile.md           # Your identity, language, anti-patterns, cadence
  styles/
    strategic-announcement.md # Your real examples for each style
    action-oriented.md
    ...
```

## Architecture

Single persistent agent with background workers for research. Voice profile via kbx, delivery via Slack MCP.

**Skills (always-on context):**
- Voice Identity — generic framework, profile format, style index, draft workflow
- Audience Adaptation — PCM rules per base type, channel conventions, tone calibration

**Resource Library (8 style guides + 1 framework, read on demand):**
- Strategic Announcement, Action-Oriented Conversation, Knowledge Share, Motivator & Supporter
- Crisis & Difficult News, Building Alignment, Onboarding & Welcoming, Cultural Reinforcement
- Message Excellence Framework (used by message-coach for draft review)

## Connected Tools

See [CONNECTORS.md](CONNECTORS.md) for full tool documentation.

- **kbx** — knowledge base (people, PCM profiles, voice profile, meeting context)
- **Slack MCP** — message delivery, thread reading, voice scan
- **Gmail MCP** — email delivery, sent mail scanning for voice calibration

## Licence

MIT
