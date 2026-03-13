---
description: Cross-plugin coaching insight sharing with inner-game. Format, tags, interpretation.
always_on: true
---

# Coaching Bridge — Cross-Plugin Insight Sharing

This skill defines how the Chief of Staff shares and consumes coaching observations with the inner-game life coach plugin. Both plugins use kbx as their shared memory layer.

## Why This Exists

The CoS advisor sees work patterns: hero mode, decision avoidance, meeting overload, energy through a professional lens. The inner-game coach sees whole-life patterns: health scores, relationship quality, stress spirals, identity alignment. Neither can build on the other's observations without a shared persistence format.

## Shared Location

**Directory:** `memory/coaching/insights/`

Both plugins write to and read from this directory. Files are auto-indexed by kbx and discoverable via search and tags.

## File Format

```markdown
---
title: "[Brief insight title]"
date: YYYY-MM-DD
tags: [coaching-insight, <source-tag>, <signal-type>]
source_plugin: chief-of-staff | inner-game
source_agent: advisor | coach
signal_type: pattern | state | connection | observation
supersedes: "YYYY-MM-DD-<slug>"  # optional — only for state signals replacing a previous one
---

[2-5 sentences. Specific, dated, actionable. Reference actual meetings, scores, or behaviours.]
```

### Tags

Every insight gets `coaching-insight` plus:

| Tag | Meaning |
|-----|---------|
| `cos-insight` | Written by chief-of-staff |
| `ig-insight` | Written by inner-game |
| `pattern` | Recurring behaviour observed across multiple data points |
| `state` | Current emotional/energy/stress state signal |
| `connection` | Cross-domain link the other plugin should know about |
| `observation` | One-off notable observation (not yet a pattern) |

### Signal Types

| Type | What to Write | Example |
|------|---------------|---------|
| **pattern** | Behaviour seen 2+ times across meetings/weeks | "Hero mode pattern: third week in a row taking on direct reports' blockers instead of coaching them through it" |
| **state** | Current state that affects the other plugin's coaching | "Persister stress sequence active — increasingly critical in meetings, withdrawing from 1:1s. Triggered by Series C pressure." |
| **connection** | A link between work and life domains | "Overcommitment on 3 concurrent initiatives correlates with Health score dropping from 6 to 3 over the same period" |
| **observation** | Notable one-off signal worth tracking | "Avoided salary conversation with Eric for the second time — deferral may indicate conflict avoidance beyond just scheduling" |

## When to Write (CoS Side)

Write a coaching insight when:

1. **After `/coach`**: If the Mochary analysis surfaces a pattern or state signal that has whole-life implications. Not every coaching session produces an insight — only write when something is genuinely useful for the life coach.

2. **After `/review`**: If the weekly review reveals energy patterns, avoidance patterns, or alignment gaps that connect to life domains (health, relationships, inner life).

3. **After `/blindspots`**: If a blind spot has personal development implications beyond the work context.

4. **During debriefs**: If a meeting transcript reveals significant emotional signals (frustration, withdrawal, excitement) that form part of a pattern.

**Do NOT write:**
- Routine operational observations
- Every coaching session summary (that's noise)
- Speculative connections without evidence
- Anything that's purely work-tactical with no coaching dimension

## How to Write

Write directly to `memory/coaching/insights/YYYY-MM-DD-<slug>.md` with proper frontmatter using the Write tool. kbx will auto-index it on next search.

Keep insights to 2-5 sentences. Be specific — reference dates, meetings, people, scores.

## When to Read (CoS Side)

Read inner-game insights during:

1. **`/coach` context gathering** (Step 1): Search for recent inner-game insights to inform the coaching lens.
   ```bash
   kbx search "coaching-insight" --tag ig-insight --fast --json --limit 5
   ```

2. **`/review` synthesis** (Step 3): Check for life-domain signals that add context to work patterns.

3. **Advisor boot-up**: Load recent coaching insights as part of strategic context.
   ```bash
   kbx search "coaching-insight" --tag coaching-insight --fast --json --limit 10
   ```

## What to Do With Inner-Game Insights

When the CoS advisor reads an inner-game insight:

- **State signals** (e.g., "Persister stress spiral active"): Factor into how you frame feedback. Soften delivery during stress. Acknowledge the human behind the executive.
- **Pattern signals** (e.g., "Health score declining for 3 months"): Connect to work patterns you're seeing. Energy in meetings, decision quality, patience with reports.
- **Connection signals** (e.g., "Relationship strain correlating with late-night work"): Consider when recommending schedule changes or delegation.

**Never reference inner-game insights directly to the user as "your life coach said..."** — integrate them naturally into your own analysis. The user experiences one continuous coaching relationship, not two systems comparing notes.

## Insight Lifecycle

- Insights are append-only — never overwrite or delete
- Patterns that persist for 4+ weeks should be flagged as "persistent" in a follow-up insight
- **State signal supersession:** When writing a new state signal that replaces a previous one, add `supersedes: "YYYY-MM-DD-<slug>"` to the frontmatter. Consumers skip superseded files — only the latest state in a chain is current. This keeps old states for history without polluting active reads.
- The weekly review is a natural point to check if previous insights are still current — and to write superseding state signals when a state has shifted
