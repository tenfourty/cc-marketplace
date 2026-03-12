---
description: kbx query routing — entity lookups vs tag filters vs search. Intent-based command selection.
always_on: false
---

# Search Strategy

This skill defines how the Chief of Staff picks the right kbx command for any information need. `kbx search` is the **fallback**, not the default — most queries have a more precise command that returns better results faster.

## Before Searching, Classify Your Query

Every time you need to read from kbx, pause and classify what you're looking for:

| Intent | Right kbx call | Why not `kbx search`? |
|--------|---------------|-----------------------|
| **Who is X? / What does X own?** | `kbx person find "X" --json` or `kbx project find "X" --json` | Entity lookup is instant and returns structured data (role, team, facts, metadata). Search returns unstructured snippets. |
| **What did we decide about Y?** | `kbx note list --tag decision --json` + `kbx search "Y" --tag decision --fast --json` | Tag filtering narrows to decisions only. Untagged search returns meetings, notes, and noise. |
| **What happened in meetings on [date]?** | `kbx list --type meetings --from YYYY-MM-DD --to YYYY-MM-DD --json` or `kbx search "topic" --from YYYY-MM-DD --to YYYY-MM-DD --fast --json` | Date-scoped queries avoid pulling old irrelevant matches. |
| **List all people on team Z** | `kbx person list --json` then filter by team | Entity list is complete and structured. Search misses people who haven't been mentioned with their team name. |
| **What's the status of project X?** | `kbx project find "X" --json` then `kbx view <entity-path> --plain` | Project entity has structured status, lead, facts, Open Items. Search returns fragments. |
| **Read a specific document** | `kbx view <path> --plain` | Direct read — no search needed. |
| **Person's recent activity** | `kbx person timeline "Name" --from YYYY-MM-DD --json` | Timeline is chronological and complete. Search is relevance-ranked and may miss low-scoring mentions. |
| **Conceptual / exploratory** ("what's been said about AI adoption?") | `kbx search "AI adoption" --json --limit 10` | This is the correct use case for search — broad, conceptual, no single entity or tag to target. |
| **Aggregation** ("how many incidents this month?") | Structured entity/note query first, search as fallback | `kbx note list --tag incident --from YYYY-MM-DD --json` or `kbx list --type meetings --from YYYY-MM-DD` gives countable results. |

## Routing Rules

1. **Entity questions → entity commands.** If the query is about a person, project, or team, start with `kbx person find`, `kbx project find`, or `kbx person list`. These return structured, complete profiles.

2. **Tagged content → tag filters.** Decisions, CIRs, initiatives, and other typed content have tags. Use `kbx note list --tag <tag>` or `kbx search --tag <tag>` to scope results.

3. **Time-scoped questions → date filters.** "This week's meetings", "recent decisions" — always add `--from` and `--to` to avoid stale results drowning out current ones.

4. **Known documents → direct read.** If you know the path (from context, previous search, or entity breadcrumbs), use `kbx view <path> --plain`. Don't search for something you can read directly.

5. **Broad/conceptual → `kbx search`.** Only reach for full search when the query is genuinely exploratory or spans multiple entity types, time ranges, and tags.

## Good vs Bad Routing

| Need | Bad | Good |
|------|-----|------|
| Check Henri's role | `kbx search "Henri role"` | `kbx person find "Henri" --json` |
| Find last week's decisions | `kbx search "decision"` | `kbx note list --tag decision --from 2026-03-03 --json` |
| Read a meeting transcript | `kbx search "meeting title"` then read | `kbx view memory/meetings/2026/03/12/uid_Title.granola.transcript.md --plain` (if path known) |
| Who reports to Pierre? | `kbx search "reports to Pierre"` | `kbx person list --json` then filter by reporting line |
| "What themes are emerging across meetings?" | `kbx person find "themes"` | `kbx search "themes" --from YYYY-MM-DD --json --limit 15` |
| Check project Open Items | `kbx search "open items CoreLogic"` | `kbx project find "CoreLogic" --json` → `kbx view <path> --plain` |

## FTS vs Hybrid Search

When you do need `kbx search`:

- **`--fast`** (FTS only): Use for keyword-specific queries where you know the exact terms — "CoreLogic migration", "incident P0", "Coralogix". Instant results.
- **Without `--fast`** (hybrid): Use for conceptual queries where synonyms or paraphrases matter — "team morale concerns", "infrastructure cost worries". ~2s but catches semantic matches.

## Compound Queries

Some questions need multiple commands chained:

1. "What's the latest on Pavel's infrastructure work?"
   - `kbx person find "Pavel" --json` → get role, team, facts
   - `kbx person timeline "Pavel" --from YYYY-MM-DD --json` → recent mentions
   - `kbx project find "Compute Infrastructure" --json` → project status
   - Only fall back to `kbx search` if the above don't answer the question

2. "Summarise this week's meetings"
   - `kbx list --type meetings --from YYYY-MM-DD --json` → list all meetings
   - `kbx view <path> --plain` for each → read content
   - No search needed at all
