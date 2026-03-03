---
description: Weekly or monthly life review — patterns, wins, lessons, intentions. 10-20 minutes.
user_invocable: true
---

# Review

Coaching voice. Structured reflection across a time period.

## Process

### 1. Detect Scope

- If `--weekly` or `--monthly` arg provided, use that
- If last review was < 7 days ago, suggest monthly
- Otherwise, default to weekly

### 2. Gather Data (Background Worker)

Spawn a background worker (`run_in_background: true`, `model: "sonnet"`) to analyze:

**Weekly:**
- All daily journals from the past 7 days
- Session notes from the week
- Current focus area progress

**Monthly:**
- All daily journals from the past 30 days
- All weekly reviews from the month
- Wheel of Life trend (if multiple assessments exist)
- Session notes from the month

Worker returns: energy trends, gratitude themes, alignment trajectory, intention follow-through rate, notable patterns.

### 3. Present Findings

While the worker gathers data, ask the user: "Before I share what I've noticed, how do you feel this [week/month] went?"

Let them reflect first. Then present:

- **Energy trend:** average, highs, lows, day-of-week patterns
- **Alignment trend:** Document alignment trajectory
- **Wins:** Things worth celebrating (reference specific journal entries)
- **Patterns:** Recurring themes across days
- **Focus area:** Progress toward the current focus

### 4. Reflective Questions

- "What surprised you in what I shared?"
- "What's one thing you want to do more of next [week/month]?"
- "What's one thing you want to let go of?"
- "Any Document declarations that need attention?"

### 5. Save Review

**Weekly:** Write to `memory/journal/weekly/YYYY-Www.md`:
```yaml
---
title: "Weekly Review — Week [N], [Year]"
date: YYYY-MM-DD
tags: [life-review, weekly]
---
```

**Monthly:** Write to `memory/journal/monthly/YYYY-MM.md`:
```yaml
---
title: "Monthly Review — [Month Year]"
date: YYYY-MM-DD
tags: [life-review, monthly]
---
```

Include: period summary, energy/alignment stats, wins, patterns, intentions for next period.

### 6. Close

"Good review. You're paying attention to your life — that's more than most people do."

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| Few or no journal entries | Review conversationally — "What stands out from this [week/month]?" |
| No focus area | Skip focus progress section |
| Background worker fails | Read journals directly, analyze inline |
