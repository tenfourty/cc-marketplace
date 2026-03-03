# Design: kbx + gm Integration

**Date:** 2026-02-24
**Status:** Approved

## Overview

Integrate `kbx` (knowledge base CLI) and `gm` (calendar/task CLI) as the primary data sources for the Chief of Staff plugin, replacing the `~~` placeholder system and TASKS.md dependency. Claude.ai MCPs become fallbacks, not primary sources.

## Core Principles

1. **kbx IS the memory system.** No separate `memory/` directory. CIRs, initiatives, recurring meetings, operating rhythm, decisions, and people context all live in kbx as indexed, searchable, pinned notes.
2. **gm IS the task system.** No TASKS.md. All task creation, tracking, and lifecycle management happens via Morgen tasks through `gm`.
3. **CLI-first, MCP-fallback.** Commands reference `kbx` and `gm` directly. MCPs are mentioned only as graceful degradation when CLIs are unavailable.
4. **No `~~` placeholders.** The indirection layer is removed. Commands say "use `kbx` to search" not "use `~~meeting transcripts`".
5. **Avoid redundant calls.** If `kbx context`, `gm today`, or `gm --help`/`kbx --help` output is already in context (from startup hooks), use it. Only run commands if the data isn't already present.

## Tool Reference

### kbx — Knowledge Base

Local knowledge base with hybrid search across meetings, people, projects, notes.
The `kbx --help` output should be in context from session startup hooks. If not, run `kbx --help` to load the command reference.

Key capabilities: search (keyword + semantic), people/project profiles, notes with tags, agent context orientation.

### gm — Calendar & Tasks

Calendar events (Google/Fastmail) + cross-source tasks (Morgen, Linear, Notion).
The `gm --help` output should be in context from session startup hooks. If not, run `gm --help` to load the command reference.

Key capabilities: events, tasks (cross-source), availability, scheduling, task lifecycle via tags (Right-Now, Active, Waiting-On, Someday) and lists (Leadership, People, Ops, Admin, Home, Routines).

### Fallback (Claude.ai MCPs)

When CLI tools are unavailable, use these Claude.ai integrations:
- **Slack** — real-time team communication (no CLI equivalent)
- **Granola** — meeting transcripts, if kbx search returns nothing
- **Notion** — knowledge base, if kbx search returns nothing
- **Linear** — issue updates/creation (gm only reads Linear tasks)

### Always MCP

- **Slack** — always via MCP, no CLI alternative for real-time chat search
- **Linear** — for write operations (create/update issues)

## Memory Architecture

kbx replaces the plugin's `memory/` directory entirely. Core reference documents are stored as pinned kbx notes:

| Concept | kbx note | Tags | Pinned |
|---------|----------|------|--------|
| Critical Information Requirements | `notes/...-cirs.md` | `cir` | Yes |
| Active initiatives | `notes/...-initiatives.md` | `initiative` | Yes |
| Operating rhythm / cadence | `notes/...-cadence.md` | `cadence` | Yes |
| Recurring meetings | `notes/...-recurring-meetings.md` | `meetings` | Yes |
| Decisions | Individual notes per decision | `decision` | No |
| People context | kbx person entities | — | — |
| Projects | kbx project entities | — | — |

Pinned docs appear in `kbx context` output, which is loaded at session start. This gives the plugin immediate access to CIRs, initiatives, and rhythm without extra commands.

### Reading memory

- **Orientation:** `kbx context` (pinned docs, entities, projects, teams)
- **Specific doc:** `kbx view <path> --plain` for clean markdown content of a pinned note
- **Search:** `kbx search "query" --fast --json` for keyword, `kbx search "query" --json` for semantic
- **People:** `kbx person find "Name" --json` for profile, `kbx person timeline "Name"` for history
- **Projects:** `kbx project find "Name" --json`
- **Decisions:** `kbx note list --tag decision --json` to browse, `kbx search` to find specific ones
- **Notes by tag:** `kbx note list --tag TAG --json`

### Writing memory

- **New notes:** `kbx memory add "title" --body "..." --tags t1,t2`
- **New pinned notes:** `kbx memory add "title" --body "..." --tags t1 --pin`
- **Person-linked notes:** `kbx memory add "title" --body "..." --entity "Name"`
- **Decisions:** `kbx memory add "Decision Title" --body "structured markdown" --tags decision`

### Editing existing notes

- **Replace body:** `kbx note edit <path> --body "new content"`
- **Append to body:** `kbx note edit <path> --append "additional content"`
- **Update tags:** `kbx note edit <path> --tags t1,t2`
- **Pin/unpin:** `kbx note edit <path> --pin` or `--unpin`

## Task Architecture

gm replaces TASKS.md entirely. The task lifecycle:

- **Tags** model status/lifecycle: Right-Now, Active, Waiting-On, Someday
- **Lists** model areas of focus: Leadership, People, Ops, Admin, Home, Routines
- **Sources** include Morgen (native), Linear, and Notion (via integrations)

### Reading tasks

- **Today's view:** `gm today --json --response-format concise --no-frames`
- **Open tasks:** `gm tasks list --status open --json --response-format concise`
- **Overdue:** `gm tasks list --overdue --json`
- **By lifecycle:** `gm tasks list --tag Active --json`, `--tag Waiting-On`, etc.
- **By area:** `gm tasks list --list Leadership --json`, `--list Ops`, etc.
- **By source:** `gm tasks list --source linear --json`, `--group-by-source`
- **Week view:** `gm this-week --json --response-format concise --no-frames`

### Writing tasks

- **Create:** `gm tasks create --title "..." --tag TAG --list LIST --due ISO`
- **Complete:** `gm tasks close ID`
- **Update lifecycle:** `gm tasks update ID --tag TAG`
- **Schedule:** `gm tasks schedule ID --start ISO`

## Command Designs

### `/cos:briefing` — Daily Briefing

**Gather Intelligence:**
1. **Load context** — Use `kbx context` output if already in context, otherwise run it. Provides pinned docs (CIRs, initiatives, recurring meetings, operating rhythm).
2. **Calendar** — Use `gm today` output if already in context, otherwise run `gm today --json --response-format concise --no-frames`. Flag meetings needing prep.
3. **Tasks** — `gm tasks list --tag Right-Now --json` for today's focus. `gm tasks list --overdue --json` for overdue items. `gm tasks list --tag Waiting-On --json` for items pending from others.
4. **Chat** — Slack MCP to scan key channels and DMs for signals matching CIR criteria.
5. **Project tracker** — `gm tasks list --source linear --json` for Linear task status.

**Graceful degradation:**
- No gm: fall back to `~~calendar` MCP if available, note tasks unavailable
- No kbx: note context is limited, skip CIR-based filtering
- No Slack: skip chat signals, note it

### `/cos:prep <meeting>` — Meeting Preparation

**Process:**
1. **Identify the meeting** — Use `gm today` output if in context, otherwise run it. Match the user's description to a specific event.
2. **Load context** — Use `kbx context` if in context. `kbx person find "Name" --json` for each attendee. `kbx project find "Name"` if meeting relates to a known project.
3. **Recent interactions** — `kbx person timeline "Name" --from YYYY-MM-DD --json` for each attendee (last 7 days). Slack MCP for recent messages from/to attendees.
4. **Previous occurrence** — If recurring, `kbx search "meeting title" --fast --json --limit 3` to find last transcript. `kbx view <path>` to read it.
5. **Open items** — `gm tasks list --json --response-format concise` filtered for tasks related to attendees or topic. `kbx note list --tag decision --json` for recent decisions involving attendees.
6. **Project status** — `gm tasks list --source linear --json` for related Linear items.

**Graceful degradation:**
- No gm: fall back to `~~calendar` MCP to identify the meeting
- No kbx: fall back to Granola MCP for previous occurrence, note limited people context

### `/cos:debrief` — Post-Meeting Debrief

**Process:**
1. **Find the transcript** — `kbx search "meeting title" --fast --json --limit 5` to find the most recent transcript. `kbx view <path>` to read it. If not found, fall back to Granola MCP, then ask user for manual input.
2. **Extract structured data** — Action items, decisions, follow-ups, key info, commitments from others (unchanged extraction logic).
3. **Cross-reference** — `gm tasks list --json --response-format concise` to check if items are already tracked. `kbx note list --tag decision --json` for related past decisions. `kbx person find "Name"` for attendee context.
4. **Update tasks** — Executive's action items: `gm tasks create --title "..." --tag Active --list LIST --due ISO`. Others' commitments: `gm tasks create --title "..." --tag Waiting-On --list LIST`.
5. **Log decisions** — `kbx memory add "Decision Title" --body "..." --tags decision` for each decision made.
6. **Update people** — `kbx memory add "context" --entity "Name"` for new context about attendees.

**Graceful degradation:**
- No kbx: fall back to Granola MCP for transcript, skip decision logging
- No gm: present action items for user to create manually, note task creation unavailable

### `/cos:review` — Weekly Strategic Review

**Process:**
1. **Load full context** — Use `kbx context` if in context. `kbx note list --tag decision --json` for this month's decisions.
2. **Calendar analysis** — `gm this-week --json --response-format concise --no-frames` for the week's events + tasks. Calculate meeting hours, focus time, meeting-to-focus ratio.
3. **Task movement** — `gm tasks list --status completed --updated-after YYYY-MM-DD --json` for tasks completed this week. `gm tasks list --status open --json --response-format concise` for current open items. `gm tasks list --overdue --json` for stale items. `gm tasks list --tag Waiting-On --json` for pending-from-others.
4. **Communication themes** — Slack MCP to scan key channels for themes, activity patterns, tension signals.
5. **Meeting transcript analysis** — `kbx search "decision" --from YYYY-MM-DD --fast --json` for this week's decisions across meetings. `kbx search "action item" --from YYYY-MM-DD --fast --json` for commitments. Cross-meeting themes via broader `kbx search` queries.
6. **Project tracker** — `gm tasks list --source linear --json --response-format concise` for Linear status. `kbx project find "Name" --json` for each active initiative.

**Graceful degradation:**
- No gm: fall back to `~~calendar` MCP for schedule, note tasks unavailable
- No kbx: fall back to Granola MCP for transcripts, note limited search
- No Slack: skip communication themes, note it

### `/cos:status <topic>` — Cross-Source Status Check

**Process:**
1. **Search kbx** — `kbx search "topic" --json --limit 10` for semantic search. `kbx person find "Name"` if it's a person. `kbx project find "Name"` if it's a project.
2. **Search tasks** — `gm tasks list --json --response-format concise` filtered for related items.
3. **Search chat** — Slack MCP for recent discussions on the topic.
4. **Search Linear** — `gm tasks list --source linear --json` for related issues. Linear MCP if deeper issue detail needed.
5. **Search Notion** — kbx covers synced Notion content. Fall back to Notion MCP if kbx returns nothing relevant.

**Graceful degradation:**
- No kbx: fall back to Granola + Notion MCPs for search
- No gm: skip task search
- No Slack: skip chat search, note it

### `/cos:decision [log|recall]` — Decision Management

**Log mode:**
1. Gather decision details — same interactive framework.
2. Write to kbx: `kbx memory add "Decision Title" --body "structured markdown" --tags decision`. If person-related, also `--entity "Name"`.
3. Create follow-up tasks: `gm tasks create --title "..." --tag Active --list LIST --due ISO`.
4. Update initiatives: `kbx memory add "Initiative update" --entity "Project Name" --tags initiative` if applicable.

**Recall mode:**
1. `kbx search "topic" --fast --json` for keyword match, `kbx search "topic" --json` for semantic.
2. `kbx note list --tag decision --json` for all decision notes.
3. `kbx search "topic decision" --from YYYY-MM-DD --json` for decisions in meetings.
4. Slack MCP for decision-related threads. Notion MCP if kbx returns nothing.
5. Coach voice analysis — same pattern detection.

### `/cos:setup` — First-Run Personalisation

Creates/updates pinned kbx notes:
- CIRs: `kbx memory add "Critical Information Requirements" --tags cir --pin`
- Initiatives: `kbx memory add "Active Strategic Initiatives" --tags initiative --pin`
- Operating rhythm: `kbx memory add "Operating Rhythm" --tags cadence --pin`
- Recurring meetings: `kbx memory add "Recurring Meetings" --tags meetings --pin`
- Verify task lists: `gm lists list --json` — suggest creating missing lists via `gm lists create`.

## Agent Designs

### weekly-review agent
- `gm this-week` for calendar data
- `gm tasks list` variants for task movement analysis
- `kbx search` with date ranges for transcript analysis
- Slack MCP for communication themes
- `kbx project find` for initiative status

### meeting-prep agent
- `kbx person find` + `kbx person timeline` for attendee research
- `kbx search` for previous meeting transcripts
- `gm tasks list` for open items related to attendees
- Slack MCP for recent messages

### cross-source-search agent
- `kbx search` as primary search engine
- `gm tasks list` for task matches
- Slack MCP for real-time chat
- Linear/Notion MCP for gaps kbx doesn't cover

### action-tracker agent
- `kbx search` / `kbx view` for transcript reading
- `gm tasks list` for cross-reference against existing tasks
- `gm tasks create` for new items
- Slack MCP for commitment language search

## Skill Updates

| Skill | Changes |
|-------|---------|
| **operating-rhythm** | Morning briefing checks `gm today` + `kbx context` + Slack. Weekly review checks `gm this-week` + `kbx search`. Post-meeting uses `kbx search` + `gm tasks create`. Remove all `~~email` references. |
| **meeting-intelligence** | Transcript source is `kbx search` + `kbx view`. Prep uses `kbx person find`. One-off meeting research uses `kbx` + Slack. |
| **information-management** | CIR evaluation scans kbx + gm + Slack. Cross-source correlation table updated (no email). |
| **decision-support** | Decision log writes via `kbx memory add --tags decision`. Recall via `kbx search` + `kbx note list --tag decision`. |
| **strategic-oversight** | Initiative health signals use `kbx project find` + `gm tasks list --source linear` + Slack. Pattern detection uses `kbx search` across date ranges. |
| **chief-of-staff-identity** | No changes needed. |

## What's Removed

- **TASKS.md** — replaced by `gm tasks`
- **`memory/` directory** — replaced by kbx notes, entities, and pinned docs
- **`~~` placeholder system** — replaced by direct CLI references
- **`~~email`** — no equivalent (Gmail not available in Claude Code)
- **`.mcp.json` bundled servers** — plugin relies on Claude.ai integrations + CLIs
- **Productivity plugin dependency** — kbx and gm replace both TASKS.md and memory/

## What's Kept

- **Slack MCP** — always, no CLI alternative
- **Linear MCP** — for write operations
- **Granola/Notion MCP** — fallback when kbx returns nothing
- **All command output formats** — briefing structure, prep brief, debrief template, review format
- **Two voices** — staff (daily ops) and coach (strategic review)
- **McChrystal framework** — CIRs, decision framework, operating rhythm, trusted advisor

## Implementation Plan

Command-by-command, in this order:
1. CONNECTORS.md → rewrite as tool reference
2. README.md → update dependencies and connected tools
3. `/cos:briefing` → update command + no agent changes needed
4. `/cos:prep` → update command + meeting-prep agent
5. `/cos:debrief` → update command + action-tracker agent
6. `/cos:review` → update command + weekly-review agent
7. `/cos:status` → update command + cross-source-search agent
8. `/cos:decision` → update command
9. `/cos:setup` → update command
10. Skills (operating-rhythm, meeting-intelligence, information-management, decision-support, strategic-oversight)
11. Bump version
