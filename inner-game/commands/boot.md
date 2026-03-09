---
description: Enter coaching mode — load context, assess state, suggest next activity.
user_invocable: true
---

# Boot

Enter coaching mode. Load context, detect where the user is, suggest what's next.

## Process

### 1. Load Context (parallel)

Read all of these simultaneously:

- The Document: `memory/coaching/the-document.md`
- Today's journal: `memory/journal/daily/YYYY-MM-DD.md`
- Yesterday's journal: `memory/journal/daily/YYYY-MM-DD.md` (yesterday's date)
- Focus area: `kbx search "focus-area" --tag focus-area --limit 1 --json`
- Calendar: `gm today --hide-declined --json --response-format concise`
- Latest Wheel: most recent file in `memory/coaching/wheel-of-life/`
- Recent sessions: most recent 2-3 files in `memory/coaching/sessions/`
- CoS coaching insights: `kbx search "coaching-insight" --tag cos-insight --fast --json --limit 5` — work-pattern signals from the Chief of Staff advisor. See the coaching-bridge skill for interpretation.

### 2. Detect Startup Mode

| Condition | Mode | Action |
|-----------|------|--------|
| No setup note found in kbx | First ever | Auto-run `/inner-game:setup` |
| Before noon, no morning entry today | Cold morning | Suggest `/inner-game:morning` |
| After 6pm, no evening entry today | Cold evening | Suggest `/inner-game:evening` |
| Today's journal has entries | Warm start | Summarize + offer next |
| Last journal entry > 3 days ago | Return | "Life happens. Welcome back." |
| Saturday or Sunday | Weekend | Lighter energy, no schedule pressure |

### 3. Present Orientation

Compact summary adapted to the mode:

- **Document focus:** Which declaration is alive this week
- **Yesterday:** Alignment score + key evening note (if available)
- **Today:** Schedule overview (meetings, blocks, open time)
- **Focus area:** Current focus + brief status
- **Suggested next:** Based on time of day and what's missing

### 4. Ready

Coaching mode is active. All `/inner-game:` commands available. Wait for the user's direction.

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| No Document | Note it — suggest `/inner-game:document` when ready |
| No journals | Note it — this is fine for new users |
| No focus area | Note it — suggest `/inner-game:focus` or `/inner-game:wheel` |
| gm unavailable | Skip calendar, proceed with coaching context |
| kbx unavailable | Read files directly via Glob/Read tools |
