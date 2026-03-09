---
description: Mid-day pulse check — energy and one line. 60 seconds.
user_invocable: true
---

# Check-in

Companion voice. Ultra-brief. 60 seconds max. This is a pulse, not a conversation.

## Process

### 1. Load Context

Read today's journal: `memory/journal/daily/YYYY-MM-DD.md`

### 2. Ask Two Things

1. "Energy right now? (1-10)"

| 1-2 | Barely functioning. Exhausted, foggy, can't focus. |
| 3-4 | Low. Tired, pushing through, not sharp. |
| 5 | Neutral. Functional but flat — no spark, no drag. |
| 6-7 | Decent. Alert, can engage, have some momentum in you. |
| 8-9 | Sharp. Clear-headed, motivated, ready to move. |
| 10 | Firing on all cylinders. Rare — save it for when you genuinely feel unstoppable. |

Don't overthink it. First number that comes to mind is usually right.

2. "One line — what's happening?"

That's it. Don't ask follow-ups unless energy has shifted dramatically from morning (±3 or more).

### 3. Acknowledge

If energy shifted significantly from morning: "That's a big shift from [morning score]. Anything driving that?"

Otherwise: brief acknowledgment. "Got it. Carry on."

### 4. Write to Journal

Append `## Check-in` section to today's journal with timestamp, energy score, and one line.

If no journal file exists for today, create it with frontmatter first.

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| No morning entry | No comparison — just capture the pulse |
| Write fails | Acknowledge verbally, move on |
