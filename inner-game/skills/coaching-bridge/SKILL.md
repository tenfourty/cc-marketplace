# Coaching Bridge — Cross-Plugin Insight Sharing

This skill defines how the inner-game life coach shares and consumes coaching observations with the Chief of Staff plugin. Both plugins use kbx as their shared memory layer.

## Why This Exists

The inner-game coach sees whole-life patterns: health scores, relationship quality, stress spirals, identity alignment, energy arcs. The CoS advisor sees work patterns: hero mode, decision avoidance, meeting overload, energy through a professional lens. Neither can build on the other's observations without a shared persistence format.

## Shared Location

**Directory:** `memory/coaching/insights/`

Both plugins write to and read from this directory. Files are auto-indexed by kbx and discoverable via search and tags.

## File Format

```markdown
---
title: "[Brief insight title]"
date: YYYY-MM-DD
tags: [coaching-insight, <source-tag>, <signal-type>]
source_plugin: inner-game | chief-of-staff
source_agent: coach | advisor
signal_type: pattern | state | connection | observation
---

[2-5 sentences. Specific, dated, actionable. Reference actual journal entries, scores, sessions, or behaviours.]
```

### Tags

Every insight gets `coaching-insight` plus:

| Tag | Meaning |
|-----|---------|
| `ig-insight` | Written by inner-game |
| `cos-insight` | Written by chief-of-staff |
| `pattern` | Recurring behaviour observed across multiple data points |
| `state` | Current emotional/energy/stress state signal |
| `connection` | Cross-domain link the other plugin should know about |
| `observation` | One-off notable observation (not yet a pattern) |

### Signal Types

| Type | What to Write | Example |
|------|---------------|---------|
| **pattern** | Behaviour seen across multiple journal entries or sessions | "Gratitude entries have mentioned work accomplishments exclusively for 3 weeks — Fun & Adventure and Relationships completely absent" |
| **state** | Current emotional/energy state that affects work coaching | "Persister stress sequence active — increasingly critical, withdrawing. Energy scores: 4, 3, 3 over the last 3 days." |
| **connection** | A link between life domains and work performance | "Health score dropped from 6 to 3 over 4 weeks. Sleep deprivation correlates with the period of 3 concurrent initiative overcommitment." |
| **observation** | Notable one-off signal worth sharing | "Evening journal revealed deep frustration about 'not being heard' in leadership meetings — first time this theme has surfaced" |

## When to Write (Inner-Game Side)

Write a coaching insight when:

1. **After `/ig:session`** (Step 7): If the session surfaces a pattern or state that has work performance implications. Not every session produces a cross-plugin insight — only write when something is genuinely useful for the work advisor.

2. **After `/ig:review`** (Step 5): If the weekly/monthly review reveals energy trends, alignment gaps, or domain scores that connect to work patterns.

3. **After `/ig:wheel`**: If Wheel of Life scores reveal significant changes (2+ point drops) or persistent lows that affect work domains (Career, Health, Inner Life).

4. **After `/ig:evening`**: Only if a clear state signal emerges from repeated patterns across 3+ days (e.g., declining energy, recurring frustration theme). Do NOT write an insight after every evening entry.

**Do NOT write:**
- Every journal reflection (that's noise)
- Routine Wheel scores without significant change
- Speculative connections without evidence from multiple data points
- Anything that's purely personal with no cross-domain coaching dimension

## How to Write

Write directly to `memory/coaching/insights/YYYY-MM-DD-<slug>.md` with proper frontmatter using the Write tool. kbx will auto-index it on next search.

Keep insights to 2-5 sentences. Be specific — reference dates, scores, journal entries, sessions.

## When to Read (Inner-Game Side)

Read CoS insights during:

1. **`/ig:boot` context loading** (Step 1): Search for recent CoS insights alongside other coaching context.
   ```bash
   kbx search "coaching-insight" --tag cos-insight --fast --json --limit 5
   ```

2. **`/ig:session` context loading** (Step 1): Check for work-pattern signals that inform the coaching conversation.

3. **`/ig:review` data gathering** (Step 2): Include CoS insights in the period's analysis.

4. **`/ig:morning`**: Only if a recent (last 48h) state or pattern signal exists — weave it into the morning orientation.

## What to Do With CoS Insights

When the inner-game coach reads a CoS insight:

- **Pattern signals** (e.g., "Hero mode — third week taking on reports' blockers"): Connect to identity work. Is this aligned with their Document declarations? What need does hero mode serve? (Six Human Needs: significance, contribution?)
- **State signals** (e.g., "Conflict avoidance with CEO escalating"): Explore the emotional dimension. What's underneath the avoidance? Fear? Anger? Use the appropriate coaching framework (ACT Hexaflex for avoidance, Mochary fear/anger check).
- **Connection signals** (e.g., "3 concurrent initiatives overcommitment"): Connect to Wheel of Life domains. How is this affecting Health, Relationships, Fun?

**Never reference CoS insights as "your work advisor noticed..."** — integrate them naturally. The user experiences one continuous relationship with you, not a system of interconnected agents.

## Insight Lifecycle

- Insights are append-only — never overwrite or delete
- Patterns that persist for 4+ weeks should be flagged as "persistent" in a follow-up insight
- State signals naturally expire — a new state signal supersedes the old one
- Reviews (both `/ig:review` and CoS `/review`) are natural points to check if previous insights are still current
