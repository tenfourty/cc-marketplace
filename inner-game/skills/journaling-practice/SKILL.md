# Journaling Practice

Daily journaling methodology, format specs, and pattern detection. All journal files are Obsidian-compatible.

## File Locations

| Type | Path | Format | Frequency |
|------|------|--------|-----------|
| Daily | `memory/journal/daily/YYYY-MM-DD.md` | Sections appended through the day | Daily |
| Weekly | `memory/journal/weekly/YYYY-Www.md` | Review summary | Weekly |
| Monthly | `memory/journal/monthly/YYYY-MM.md` | Trend analysis | Monthly |

## Daily Journal Template

```markdown
---
title: "Journal — 3 March 2026"
date: 2026-03-03
tags: [journal, daily]
---

## Morning
*06:45*

### Intentions
- [user-written intentions]

### Energy
7/10

### Document Alignment
8/10 — [which declaration feels alive]

### One Line
[One sentence about the day ahead]

---

## Check-in
*12:30*

Energy: 6/10
One line: [mid-day note]

---

## Evening
*21:15*

### Three Good Things
1. [gratitude item]
2. [gratitude item]
3. [gratitude item]

### What I Learned
[reflection]

### Tomorrow's Intention
[one line]
```

Create the file on first entry of the day. Append subsequent sections with `---` separator.

## Obsidian Vault Compatibility

Vault root = `memory/`. Required settings:
- Daily Notes: folder = `journal/daily/`, format = `YYYY-MM-DD`
- Periodic Notes: weekly = `journal/weekly/` (`gggg-[W]ww`), monthly = `journal/monthly/` (`YYYY-MM`)
- Wikilinks enabled, YAML frontmatter on all files, `##` section headings

## Metrics

### Energy (1-10)
Tracked morning, check-in, and evening. The trend matters more than any single score.

| 1-2 | Barely functioning. Exhausted, foggy, can't focus. |
| 3-4 | Low. Tired, pushing through, not sharp. |
| 5 | Neutral. Functional but flat — no spark, no drag. |
| 6-7 | Decent. Alert, can engage, have some momentum. |
| 8-9 | Sharp. Clear-headed, motivated, ready to move. |
| 10 | Firing on all cylinders. Rare — save it for when you genuinely feel unstoppable. |

**Escalation:** Energy ≤ 3 for 3+ consecutive days → surface concern (see coaching-identity safety boundaries).

### Document Alignment (1-10)
Morning only. How closely yesterday's actions aligned with Document declarations.

| 1-2 | Completely off-track. Acted against your own declarations. |
| 3-4 | Struggling. Knew what you stood for but couldn't live it today. |
| 5 | Mixed. Some moments aligned, some not — a wash. |
| 6-7 | Good. Mostly showed up as the person you declared yourself to be. |
| 8-9 | Strong. Felt connected to your Document through most of the day. |
| 10 | Fully embodied. Rare — every action felt like a declaration in motion. |

**Pattern:** Persistent ≤ 5 for 2+ weeks → suggest Document revision or focus area change.

## Pattern Detection

Over time, use accumulated journal data to surface:
- **Energy patterns** — by day of week, time of day, after specific activities
- **Gratitude themes** — recurring sources of joy, blind spots in appreciation
- **Intention follow-through** — morning intentions vs evening reflections
- **Alignment trends** — Document alignment trajectory over weeks
- **Seasonal patterns** — energy/mood shifts with seasons, workload cycles

When surfacing patterns, reference specific journal entries. "On Tuesday you wrote..." is more powerful than "you tend to..."

## Writing Guidance

- Don't edit the user's words. Prompt, don't prescribe.
- Short entries are fine. One line is better than no line.
- Consistency matters more than depth.
- After gaps: "Life happens. Welcome back." — never guilt.
- Read `resources/journaling/*.md` for technique-specific prompts and methods.
