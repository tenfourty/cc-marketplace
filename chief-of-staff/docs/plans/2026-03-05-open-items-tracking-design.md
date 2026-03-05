# Open Items Tracking on Entity Files

**Date:** 2026-03-05
**Status:** Approved

## Problem

When the debrief command extracts action items from meetings, ALL items (user's own, others' commitments, delegated follow-ups) are created as tasks in the user's task manager. This causes clutter — especially for Waiting-On items on projects where the user is on the steering committee but items are already tracked in the project's own system (Linear, Notion, etc.).

With automated debriefs generating items for every meeting, this volume is unsustainable.

## Solution

A two-tier tracking system:

1. **Task manager (Morgen):** Only items where the user is directly accountable — their own commitments and items they'll personally be asked about.
2. **Entity Open Items:** Delegated commitments, steering-level follow-ups, and discussion topics tracked on kbx person/project entity markdown files. Surfaced in brief-deck.

## Item Format

Each open item is a markdown list entry in an `## Open Items` section on person or project entity files:

```markdown
## Open Items
- [2026-03-04] NHI incident PRD finalisation (from: Architecture Meeting)
- [2026-03-01] External search for EM replacement (from: 1:1)
- ~~[2026-02-28] Budget review for Q2 cloud costs~~ [resolved 2026-03-03]
```

**Format rules:**
- New items prepended (most recent first)
- Resolved items get strikethrough + `[resolved YYYY-MM-DD]` — kept for 30 days then pruned
- Each item: `[date] description (from: Meeting Title)`
- Items on **person entities** = things that person owes or topics to discuss with them
- Items on **project entities** = project-level commitments/blockers tracked at steering level

## Decision Rule: Task Manager vs. Open Items

The debrief's task creation step applies this filter:

| Who's accountable? | Where it goes |
|---|---|
| **User personally** — committed to do something | Task manager (Active or Right-Now) |
| **User needs to follow up** — will be asked about it | Task manager (Waiting-On) |
| **Someone else on a steered project** — tracked in project system | Open Items on the **project** entity |
| **Someone in a 1:1 relationship** — topic for next conversation | Open Items on the **person** entity |
| **General follow-up, no clear owner** | Open Items on the most relevant entity |

## Recurring Meeting Topics

For recurring 1:1s, the person's Open Items section doubles as a "topics for next meeting" list. The prep command already reads person files — it naturally picks up open items when preparing.

For recurring group meetings, items go on the most relevant project entity. The recurring meetings doc can reference which entity to check.

## Cleanup

1. **Debrief-driven:** When a debrief detects completion (someone reports done in a meeting), mark the item resolved with strikethrough + date.
2. **Periodic:** Weekly review (`/review`) flags items older than 14 days — still open? Resolved? Stale?
3. **Pruning:** Resolved items older than 30 days are removed during weekly review.

## Brief-deck Integration

Person and project detail pages render the `## Open Items` section in a dedicated card. Resolved items shown dimmed or collapsed. No kbx changes needed — Open Items is a standard markdown section, indexed naturally.

## Changes Required

| Component | Change | Owner |
|---|---|---|
| `commands/debrief.md` | Update Step 6 with decision rule table; write to entity files for non-user items | cos-dev |
| `commands/prep.md` | Explicitly mention Open Items in Step 3 (already reads person files) | cos-dev |
| `commands/review.md` | Add stale open-items scan to weekly review | cos-dev |
| `prompts/debrief-unattended.md` | Same decision rule for automated debriefs | scripts |
| brief-deck person/project pages | Render `## Open Items` section | bd-dev |
| kbx | No changes — markdown section indexed naturally | none |

## Automation Behaviour

Automated debriefs (`source: cos-agent-unattended`) follow the same decision rule but with a conservative bias:
- **Never create task manager tasks** in unattended mode (risk of noise)
- **Always write Open Items** to entity files (low-risk, informational)
- Interactive debrief option (d) "extract tasks and update systems" can promote Open Items to task manager tasks after human review
