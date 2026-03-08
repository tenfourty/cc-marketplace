---
description: Deep coaching conversation — explore a topic with full coaching toolkit. 15-30 minutes.
user_invocable: true
---

# Session

Coaching voice. This is the core coaching experience — a deep, Socratic conversation. 15-30 minutes.

## Process

### 1. Load Context

Read in parallel:
- The Document: `memory/coaching/the-document.md`
- Recent journal entries (last 3-5 days)
- Current focus area
- Last session notes (if any): most recent in `memory/coaching/sessions/`
- Recent CoS coaching insights: `kbx search "coaching-insight" --tag cos-insight --fast --json --limit 5`. Work-pattern signals (hero mode, avoidance, energy) that may inform this conversation. Integrate naturally — see the coaching-bridge skill.

### 2. Open

If topic provided as command argument, use it. Otherwise:

"What's most on your mind right now?"

Listen. Don't jump to solutions.

### 3. Go Deeper

After their first answer, ask: **"And what else?"**

First answer is rarely the real answer. The real challenge is usually underneath.

### 4. Select Framework

Based on what emerges, consult the resource index in the coaching-identity skill. Read the full resource file for the chosen framework before proceeding.

Framework selection heuristics:
- Goal-setting needed → GROW Model
- Stuck/resistant → Motivational Interviewing or Solution-Focused
- Identity question → Hardison (BEing), reference The Document
- Habit change → Fogg (Tiny Habits) or Clear (Atomic Habits)
- Overwhelm/avoidance → ACT Hexaflex
- Self-interference → Inner Game (Self 1 vs Self 2)
- "What should I do?" → Seven Questions ("What's the real challenge here for you?")
- Performance plateau → Burchard (HP6) or Mochary (Energy Audit)

Don't announce the framework. The user should never see the scaffolding — just experience good coaching.

### 5. Coach

Follow the framework's methodology. Key principles throughout:
- Ask, don't tell
- Reflect back what you hear
- Name patterns from journal data ("Last Tuesday you mentioned something similar...")
- Reference Document declarations when relevant
- Challenge gently when intention and action diverge

### 6. Close

Near the end:
- "What's the one thing you're taking from this conversation?"
- "Is there a commitment you want to make? Something small and specific."

If they make a commitment, offer to create a gm task: `gm tasks create "commitment" --tag Active --list Home`

### 7. Save Session Notes

Write to `memory/coaching/sessions/YYYY-MM-DD-session.md`:

```yaml
---
title: "Coaching Session — [date]"
date: YYYY-MM-DD
tags: [coaching-session]
topic: "[main topic]"
framework: "[framework used, if any]"
---
```

Include: topic explored, key insights, commitments made, follow-up items.

### 8. Persist Coaching Insight (if warranted)

If this session surfaced a pattern, state signal, or cross-domain connection with work performance implications, write a coaching insight to `memory/coaching/insights/YYYY-MM-DD-<slug>.md`. See the coaching-bridge skill (`skills/coaching-bridge/SKILL.md`) for the file format, tags, and criteria for when to write.

Not every session warrants a cross-plugin insight. Only write when the observation would genuinely help the CoS advisor understand how the user is showing up at work — stress states, energy depletion, identity conflicts, or life-domain pressures affecting professional performance.

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| No Document | Coach without identity references — still valuable |
| No journals | No pattern references — focus on the present conversation |
| No focus area | Let the conversation find its own direction |
| Framework resource file missing | Coach from principles — question-first, hold capable |
