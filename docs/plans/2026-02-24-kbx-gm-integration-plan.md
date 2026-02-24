# kbx + gm Integration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace all `~~` placeholders, TASKS.md, `memory/` directory, and productivity plugin references with direct `kbx` and `gm` CLI calls throughout the Chief of Staff plugin.

**Architecture:** Each command, agent, and skill file is rewritten to use `kbx` (knowledge base) and `gm` (calendar/tasks) as primary data sources, with Claude.ai MCPs (Slack, Linear, Granola, Notion) as fallbacks. The design doc at `docs/plans/2026-02-24-kbx-gm-integration-design.md` is the authoritative reference for all changes.

**Tech Stack:** Markdown files only (Claude Code plugin), `kbx` CLI, `gm` CLI, Claude.ai MCP integrations

---

### Task 1: Rewrite CONNECTORS.md as Tool Reference

**Files:**
- Modify: `CONNECTORS.md`

**Context:** Replace the current placeholder-based connector docs with a direct tool reference covering kbx, gm, and Claude.ai MCPs. Use the "Tool Reference" section from the design doc (lines 18-46) as the source.

**Step 1: Rewrite CONNECTORS.md**

Replace the entire file with:

```markdown
# Tools

This plugin uses local CLI tools as primary data sources, with Claude.ai integrations as fallbacks.

## Primary Tools

### kbx — Knowledge Base

Local knowledge base with hybrid search across meetings, people, projects, notes.
The `kbx usage` output should be in context from session startup hooks. If not, run `kbx usage` to load the command reference.

Key capabilities: search (keyword + semantic), people/project profiles, notes with tags, agent context orientation.

### gm — Calendar & Tasks

Calendar events (Google/Fastmail) + cross-source tasks (Morgen, Linear, Notion).
The `gm usage` output should be in context from session startup hooks. If not, run `gm usage` to load the command reference.

Key capabilities: events, tasks (cross-source), availability, scheduling, task lifecycle via tags (Right-Now, Active, Waiting-On, Someday) and lists (Leadership, People, Ops, Admin, Home, Routines).

## Claude.ai Integrations (Fallback)

When CLI tools are unavailable, use these Claude.ai integrations:
- **Granola** — meeting transcripts, if kbx search returns nothing
- **Notion** — knowledge base, if kbx search returns nothing
- **Linear** — issue updates/creation (gm only reads Linear tasks)

## Always via MCP

These tools are always accessed via Claude.ai MCP (no CLI equivalent):
- **Slack** — real-time team communication and channel scanning
- **Linear** — for write operations (create/update issues)

## Graceful Degradation

All commands degrade gracefully when tools are unavailable. Missing sources are noted in output, and the plugin works with whatever subset is available.
```

**Step 2: Commit**

```bash
git add CONNECTORS.md
git commit -m "refactor(connectors): rewrite as kbx/gm tool reference"
```

---

### Task 2: Update README.md

**Files:**
- Modify: `README.md`

**Context:** Remove productivity plugin dependency, TASKS.md references, `memory/` directory structure, and `~~` placeholder table. Replace with kbx/gm as prerequisites and update the Connected Tools section.

**Step 1: Rewrite README.md**

Replace the entire file with:

```markdown
# Chief of Staff Plugin

An AI Chief of Staff for technology executives, built as a Claude Cowork plugin. Provides strategic briefings, meeting intelligence, decision support, and proactive oversight using `kbx` (knowledge base) and `gm` (calendar/tasks) as primary data sources.

CTO-flavoured by default, adaptable to any executive role.

## Prerequisites

This plugin requires two local CLI tools:

- **kbx** — Knowledge base with hybrid search across meetings, people, projects, notes
- **gm** — Calendar events and cross-source task management (Morgen, Linear, Notion)

Both should be configured with session startup hooks so their usage and context are available automatically.

## Installation

```
claude plugins add <path-to-this-directory>
```

Then run `/cos:setup` to personalise the Chief of Staff for your role, team, and priorities.

## Commands

| Command | Description |
|---------|-------------|
| `/cos:setup` | First-run personalisation — learns your role, team, priorities, CIRs |
| `/cos:briefing` | Morning briefing — calendar, priorities, overdue items, key signals |
| `/cos:prep <meeting>` | Meeting preparation — attendee context, open items, history |
| `/cos:debrief` | Post-meeting — extract actions, decisions, follow-ups from transcript |
| `/cos:review` | Weekly strategic review — patterns, blind spots, coach questions |
| `/cos:status <topic>` | Cross-source status check on any topic, project, or person |
| `/cos:decision [log\|recall]` | Log a new decision or recall past decisions |

## Architecture

### Two Voices
- **Staff voice** (daily operations): Efficient, structured, action-oriented
- **Coach voice** (strategic work): Probing, pattern-aware, challenges assumptions

### Skills (Always-On Context)
| Skill | Purpose |
|-------|---------|
| `chief-of-staff-identity` | Core persona, voice switching, CTO context |
| `information-management` | CIR framework, information filtering, cross-source correlation |
| `meeting-intelligence` | Transcript processing, meeting prep/debrief patterns |
| `decision-support` | Decision framework, logging, recall, pattern detection |
| `strategic-oversight` | Initiative tracking, trajectory analysis, trusted advisor mode |
| `operating-rhythm` | Cadence management, routine definitions, rhythm health |

### Agents (Parallel Workers)
| Agent | Purpose |
|-------|---------|
| `weekly-review` | Gathers week's data across all sources for strategic synthesis |
| `meeting-prep` | Parallel attendee research and context gathering |
| `cross-source-search` | Searches all sources for a topic/person/project |
| `action-tracker` | Extracts commitments from transcripts, audits action items |

### Memory System

kbx IS the memory system. Core reference documents are stored as pinned kbx notes:

| Concept | Tag | Pinned |
|---------|-----|--------|
| Critical Information Requirements | `cir` | Yes |
| Active initiatives | `initiative` | Yes |
| Operating rhythm / cadence | `cadence` | Yes |
| Recurring meetings | `meetings` | Yes |
| Decisions | `decision` | No |
| People context | kbx person entities | — |
| Projects | kbx project entities | — |

Pinned docs appear in `kbx context` output, loaded at session start.

### Task System

gm IS the task system. Task lifecycle uses tags (Right-Now, Active, Waiting-On, Someday) and lists (Leadership, People, Ops, Admin, Home, Routines).

## Connected Tools

| Tool | Type | Purpose |
|------|------|---------|
| kbx | CLI (primary) | Knowledge base, search, people, projects, notes |
| gm | CLI (primary) | Calendar, tasks, scheduling |
| Slack | Claude.ai MCP | Real-time team communication |
| Linear | Claude.ai MCP | Issue creation/updates (write operations) |
| Granola | Claude.ai MCP (fallback) | Meeting transcripts if kbx returns nothing |
| Notion | Claude.ai MCP (fallback) | Knowledge base if kbx returns nothing |

Optional: Figma, HubSpot, n8n. See [CONNECTORS.md](CONNECTORS.md) for details.

## Design Influences

- [McChrystal Group Chief of Staff Playbook](https://www.mcchrystalgroup.com/) — CIR framework, decision-making framework, operating rhythm, trust model
- [goagentflow/ai-chief-of-staff](https://github.com/goagentflow/ai-chief-of-staff) — Files-as-memory philosophy, Quick Status tables, permission tiers
- [mboverell/ai-chief-of-staff](https://github.com/mboverell/ai-chief-of-staff) — Coach voice design, weekly review as killer feature, trajectory analysis
- [bbinto/bb-chiefofstaff](https://github.com/bbinto/bb-chiefofstaff) — Specialised agent pattern, MCP integration approach

## Licence

Apache-2.0
```

**Step 2: Commit**

```bash
git add README.md
git commit -m "refactor(readme): update for kbx/gm integration, remove productivity plugin dep"
```

---

### Task 3: Update `/cos:briefing` Command

**Files:**
- Modify: `commands/briefing.md`

**Context:** Replace TASKS.md, `~~calendar`, `~~chat`, `~~project tracker`, and `memory/` references with kbx/gm CLI calls. Use the `/cos:briefing` design (lines 107-119 of the design doc).

**Step 1: Rewrite commands/briefing.md**

Keep the YAML front matter and voice section. Replace the process section with kbx/gm calls:

- Section 1 "Load Context": Replace `Read CLAUDE.md`, `Read memory/priorities/cirs.md`, etc. with: "Use `kbx context` output if already in context, otherwise run it. Provides pinned docs (CIRs, initiatives, recurring meetings, operating rhythm). For full content of a specific pinned doc, use `kbx view <path>`."
- Section 2 "Gather Intelligence":
  - Calendar: Replace `~~calendar` with `gm today` (use output if already in context, otherwise `gm today --json --response-format concise --no-frames`)
  - Tasks: Replace TASKS.md with `gm tasks list --tag Right-Now --json`, `gm tasks list --overdue --json`, `gm tasks list --tag Waiting-On --json`
  - Chat: Replace `~~chat` with "Slack MCP" (direct reference)
  - Project Tracker: Replace `~~project tracker` with `gm tasks list --source linear --json`
- Section 3 "Synthesise": Update cross-reference note to "Topics that appear in multiple channels (Slack + Linear + kbx transcripts = something important)"
- Section 4: Keep as-is (output format is unchanged)
- Section 5: Keep as-is
- Graceful Degradation: Replace with kbx/gm-specific fallbacks from design doc

**Step 2: Commit**

```bash
git add commands/briefing.md
git commit -m "refactor(briefing): use kbx/gm as primary data sources"
```

---

### Task 4: Update `/cos:prep` Command + Meeting-Prep Agent

**Files:**
- Modify: `commands/prep.md`
- Modify: `agents/meeting-prep.md`

**Context:** Replace `~~calendar`, `~~chat`, `~~meeting transcripts`, `~~project tracker`, TASKS.md, and `memory/` references. Use the `/cos:prep` design (lines 121-134) and meeting-prep agent design (lines 213-215).

**Step 1: Rewrite commands/prep.md**

- Section 1 "Identify the Meeting": Replace `~~calendar` with `gm today` (use output if in context, otherwise run it)
- Section 2 "Load Context": Replace `memory/meetings/recurring.md`, `memory/people/`, `memory/priorities/initiatives.md`, `memory/decisions/` with kbx calls: `kbx context` (if in context), `kbx person find "Name" --json` for each attendee, `kbx project find "Name"` for projects
- Section 3 "Gather Recent Intelligence": Replace `~~chat` with "Slack MCP", replace `~~meeting transcripts` with `kbx search "meeting title" --fast --json --limit 3` + `kbx view <path>`, replace `~~project tracker` with `gm tasks list --source linear --json`
- Section "From tasks": Replace TASKS.md with `gm tasks list --json --response-format concise` filtered for attendees/topic
- "For Recurring Meetings" section: Replace `memory/meetings/recurring.md` with kbx (pinned meetings note appears in `kbx context`)
- Graceful Degradation: Update per design doc

**Step 2: Rewrite agents/meeting-prep.md**

- "Attendee Profiles": Replace `memory/people/` and CLAUDE.md with `kbx person find "Name" --json`
- "Recent Interactions": Replace `~~chat` with "Slack MCP", replace `~~meeting transcripts` with `kbx person timeline "Name" --from YYYY-MM-DD --json` and `kbx search`
- "Open Items": Replace TASKS.md with `gm tasks list --json --response-format concise`, replace `memory/decisions/` with `kbx note list --tag decision --json`
- "Topic Research": Replace `~~chat` with Slack MCP, `~~project tracker` with `gm tasks list --source linear --json`, `~~knowledge base` with kbx search, `memory/priorities/initiatives.md` with kbx (from pinned docs)
- "Previous Occurrence": Replace `~~meeting transcripts` with `kbx search "meeting title" --fast --json` + `kbx view`

**Step 3: Commit**

```bash
git add commands/prep.md agents/meeting-prep.md
git commit -m "refactor(prep): use kbx/gm for meeting prep command and agent"
```

---

### Task 5: Update `/cos:debrief` Command + Action-Tracker Agent

**Files:**
- Modify: `commands/debrief.md`
- Modify: `agents/action-tracker.md`

**Context:** Replace `~~meeting transcripts`, TASKS.md, `memory/decisions/`, `memory/people/`, `~~project tracker` references. Use the `/cos:debrief` design (lines 135-147) and action-tracker agent design (lines 224-227).

**Step 1: Rewrite commands/debrief.md**

- Section 1 "Find the Transcript": Replace `~~meeting transcripts` with `kbx search "meeting title" --fast --json --limit 5` + `kbx view <path>`. Fallback to Granola MCP, then manual input.
- Section 2 "Extract Structured Data": Keep extraction logic unchanged. Replace `memory/priorities/cirs.md` with "CIRs from `kbx context`"
- Section 3 "Cross-Reference": Replace TASKS.md with `gm tasks list`, `memory/decisions/` with `kbx note list --tag decision --json`, `memory/priorities/initiatives.md` with kbx (pinned docs), `memory/people/` with `kbx person find`
- Section 5 "Update Files": Replace TASKS.md updates with `gm tasks create` calls, `memory/decisions/` with `kbx memory add --tags decision`, `memory/people/` with `kbx memory add --entity "Name"`, CLAUDE.md hot cache with note that kbx pinned notes serve this purpose
- Section 6 "Offer Next Steps": Replace `~~project tracker` with "Linear MCP"
- Graceful Degradation: Update per design doc

**Step 2: Rewrite agents/action-tracker.md**

- Mode 1 "Extract from Transcript": Replace TASKS.md cross-reference with `gm tasks list --json --response-format concise`
- Mode 2 "Audit Current Items": Replace TASKS.md with `gm tasks list` variants, `~~project tracker` with `gm tasks list --source linear`, `~~chat` with Slack MCP, `~~meeting transcripts` with `kbx search`
- Output formats: Replace TASKS.md references with gm task references

**Step 3: Commit**

```bash
git add commands/debrief.md agents/action-tracker.md
git commit -m "refactor(debrief): use kbx/gm for debrief command and action-tracker agent"
```

---

### Task 6: Update `/cos:review` Command + Weekly-Review Agent

**Files:**
- Modify: `commands/review.md`
- Modify: `agents/weekly-review.md`

**Context:** Replace `~~calendar`, TASKS.md, `~~chat`, `~~meeting transcripts`, `~~project tracker`, and `memory/` references. Use the `/cos:review` design (lines 149-162) and weekly-review agent design (lines 204-209).

**Step 1: Rewrite commands/review.md**

- Section 1 "Load Full Context": Replace CLAUDE.md/memory reads with `kbx context` (if in context). `kbx note list --tag decision --json` for this month's decisions.
- Section 2 "Dispatch the Weekly Review Agent":
  - Calendar: Replace `~~calendar` with `gm this-week --json --response-format concise --no-frames`
  - Tasks: Replace TASKS.md with `gm tasks list` variants (completed this week, open, overdue, Waiting-On)
  - Chat: Replace `~~chat` with Slack MCP
  - Meeting Transcripts: Replace `~~meeting transcripts` with `kbx search` with date ranges
  - Project Tracker: Replace `~~project tracker` with `gm tasks list --source linear --json` + `kbx project find "Name"`
- Section 6 "Update Memory": Replace memory/ updates with kbx calls (`kbx memory add` for notes, pinned doc updates)
- Graceful Degradation: Update per design doc

**Step 2: Rewrite agents/weekly-review.md**

- Calendar Analysis: Replace `~~calendar` with `gm this-week --json --response-format concise --no-frames`
- Task Movement: Replace TASKS.md with `gm tasks list` variants
- Communication Themes: Replace `~~chat` with Slack MCP
- Meeting Transcript Analysis: Replace `~~meeting transcripts` with `kbx search` with date ranges + `kbx view`
- Project Tracker Status: Replace `~~project tracker` with `gm tasks list --source linear --json` + `kbx project find`

**Step 3: Commit**

```bash
git add commands/review.md agents/weekly-review.md
git commit -m "refactor(review): use kbx/gm for weekly review command and agent"
```

---

### Task 7: Update `/cos:status` Command + Cross-Source Search Agent

**Files:**
- Modify: `commands/status.md`
- Modify: `agents/cross-source-search.md`

**Context:** Replace TASKS.md, `memory/`, `~~chat`, `~~meeting transcripts`, `~~project tracker`, `~~knowledge base` references. Use the `/cos:status` design (lines 164-176) and cross-source-search agent design (lines 217-221).

**Step 1: Rewrite commands/status.md**

- Section 1 "Understand the Query": Replace `memory/priorities/initiatives.md`, `memory/people/`, TASKS.md with kbx equivalents (kbx context for initiatives, `kbx person find` for people, `gm tasks list` for tasks)
- Section 2 "Dispatch Cross-Source Search Agent":
  - Internal Memory: Replace all memory/ reads with kbx calls (`kbx search`, `kbx person find`, `kbx project find`, `kbx note list --tag decision`)
  - Chat: Replace `~~chat` with Slack MCP
  - Meeting Transcripts: Replace `~~meeting transcripts` with `kbx search`
  - Project Tracker: Replace `~~project tracker` with `gm tasks list --source linear --json` + Linear MCP for deeper detail
  - Knowledge Base: Replace `~~knowledge base` with kbx (fall back to Notion MCP)
- Graceful Degradation: Update per design doc

**Step 2: Rewrite agents/cross-source-search.md**

- Internal Memory: Replace all memory/ and TASKS.md with kbx calls
- Chat: Replace `~~chat` with Slack MCP
- Meeting Transcripts: Replace `~~meeting transcripts` with `kbx search`
- Project Tracker: Replace `~~project tracker` with `gm tasks list --source linear` + Linear MCP
- Knowledge Base: Replace `~~knowledge base` with kbx search (fall back to Notion MCP)

**Step 3: Commit**

```bash
git add commands/status.md agents/cross-source-search.md
git commit -m "refactor(status): use kbx/gm for status command and cross-source-search agent"
```

---

### Task 8: Update `/cos:decision` Command

**Files:**
- Modify: `commands/decision.md`

**Context:** Replace `memory/decisions/`, TASKS.md, `~~meeting transcripts`, `~~chat`, `~~knowledge base`, CLAUDE.md hot cache references. Use the `/cos:decision` design (lines 178-191).

**Step 1: Rewrite commands/decision.md**

- "Write to Decision Log" section: Replace `memory/decisions/YYYY-MM.md` with `kbx memory add "Decision Title" --body "structured markdown" --tags decision`. If person-related, also `--entity "Name"`.
- Also section: Replace TASKS.md with `gm tasks create`, `memory/priorities/initiatives.md` with `kbx memory add --tags initiative`, CLAUDE.md hot cache with kbx pinned notes
- "Recalling Decisions" search section: Replace `memory/decisions/` with `kbx note list --tag decision --json` + `kbx search`, `~~meeting transcripts` with `kbx search "topic decision"`, `~~chat` with Slack MCP, `~~knowledge base` with Notion MCP fallback
- Coach Voice Analysis: Replace TASKS.md reference with `gm tasks list`

**Step 2: Commit**

```bash
git add commands/decision.md
git commit -m "refactor(decision): use kbx/gm for decision management command"
```

---

### Task 9: Update `/cos:setup` Command

**Files:**
- Modify: `commands/setup.md`

**Context:** Replace productivity plugin dependency, TASKS.md, `memory/` directory creation, and file writes with kbx/gm equivalents. Use the `/cos:setup` design (lines 193-200).

**Step 1: Rewrite commands/setup.md**

- Remove "Prerequisites" about productivity plugin and TASKS.md/memory/ checks
- Step 1 "Check What Exists": Replace with checking kbx and gm availability (`kbx usage`, `gm usage`). Check for existing pinned notes (`kbx context`). Check for existing task lists (`gm lists list --json`).
- Step 2 "Learn the Executive": Keep interactive conversation unchanged
- Step 3 "Write Memory Files": Replace all `memory/` file writes with kbx calls:
  - CIRs: `kbx memory add "Critical Information Requirements" --body "..." --tags cir --pin`
  - Initiatives: `kbx memory add "Active Strategic Initiatives" --body "..." --tags initiative --pin`
  - Recurring meetings: `kbx memory add "Recurring Meetings" --body "..." --tags meetings --pin`
  - Cadence: `kbx memory add "Operating Rhythm" --body "..." --tags cadence --pin`
  - People profiles: `kbx memory add "context" --entity "Name"` for each key person
  - Decisions: Not needed at setup time
- Remove CLAUDE.md hot cache update (kbx pinned notes serve this purpose)
- Verify/create task lists: `gm lists list --json`, suggest `gm lists create` for missing lists
- Step 4-5: Keep confirmation and next action suggestions

**Step 2: Commit**

```bash
git add commands/setup.md
git commit -m "refactor(setup): use kbx/gm for first-run personalisation"
```

---

### Task 10: Update Skills

**Files:**
- Modify: `skills/operating-rhythm/SKILL.md`
- Modify: `skills/meeting-intelligence/SKILL.md`
- Modify: `skills/information-management/SKILL.md`
- Modify: `skills/decision-support/SKILL.md`
- Modify: `skills/strategic-oversight/SKILL.md`
- Modify: `skills/chief-of-staff-identity/SKILL.md`

**Context:** Update all skill files to reference kbx/gm instead of TASKS.md, memory/, and `~~` placeholders. Use the "Skill Updates" table from the design doc (lines 229-238). Note: chief-of-staff-identity needs its "Relationship to the Productivity Plugin" and "Memory Philosophy" sections updated even though the design doc says "No changes needed" — the productivity plugin dependency and TASKS.md/memory/ references are stale.

**Step 1: Update skills/operating-rhythm/SKILL.md**

- Replace `memory/rhythms/cadence.md` with "kbx pinned cadence note (from `kbx context`)"
- Replace `memory/meetings/recurring.md` with "kbx pinned meetings note"
- Morning Briefing Routine "What it checks": Replace `TASKS.md for overdue/due-today items` with `gm tasks list --overdue`, `~~chat` with "Slack MCP", `~~project tracker` with `gm tasks list --source linear`
- Weekly Review Routine: Update similarly
- Post-Meeting Routine: Replace "Existing tasks and decisions for cross-reference" with `gm tasks list` + `kbx note list --tag decision`
- "Integration with Productivity Plugin" section: Replace entirely with a "Tool Integration" section showing how kbx and gm complement the CoS plugin
- Remove any remaining `~~email` references
- Health indicators: Replace `CLAUDE.md updated this week` with `kbx pinned notes current`

**Step 2: Update skills/meeting-intelligence/SKILL.md**

- "Transcript Sources": Replace `~~meeting transcripts` with `kbx search` + `kbx view`. Note fallback to Granola MCP.
- "Working with Transcripts": Replace TASKS.md references with `gm tasks list` / `gm tasks create`, `memory/decisions/` with `kbx memory add --tags decision`
- "Meeting Preparation": Replace `memory/meetings/recurring.md` with kbx pinned meetings note, `memory/people/` with `kbx person find`, `~~chat` with Slack MCP
- "Pre-Meeting Intelligence Template": Replace TASKS.md with `gm tasks list`, `memory/` with kbx
- "Post-Meeting Processing": Replace TASKS.md with `gm tasks create`, `memory/decisions/` with `kbx memory add --tags decision`, `memory/people/` with `kbx memory add --entity`, CLAUDE.md with kbx pinned notes
- "Recurring Meeting Context Format": Replace `memory/meetings/recurring.md` with kbx pinned meetings note

**Step 3: Update skills/information-management/SKILL.md**

- CIR evaluation: Replace "Slack, email, transcripts, Linear" scanning with "kbx + gm + Slack MCP"
- Cross-source correlation table: Remove email column, update to use kbx/gm/Slack references
- Context Window Management: Replace CLAUDE.md / memory/ two-tier with kbx-based memory (pinned = hot, searchable = warm). Note that CLAUDE.md still exists for the project but kbx is the primary store.
- Promotion/Demotion: Adapt to kbx pinned notes (pin = promote, unpin = demote)

**Step 4: Update skills/decision-support/SKILL.md**

- "Decision Log Format": Replace `memory/decisions/YYYY-MM.md` with `kbx memory add --tags decision`
- "Also" section: Replace TASKS.md with `gm tasks create`, `memory/priorities/initiatives.md` with `kbx memory add --tags initiative`
- "Decision Recall": Replace `memory/decisions/` search with `kbx search` + `kbx note list --tag decision`, `~~meeting transcripts` with `kbx search`, `~~chat` with Slack MCP, `~~knowledge base` with Notion MCP fallback
- Decision Audit: Replace TASKS.md with `gm tasks list`

**Step 5: Update skills/strategic-oversight/SKILL.md**

- "Initiative Tracking": Replace `memory/priorities/initiatives.md` with kbx pinned initiatives note (from `kbx context`)
- "Health Signals" table: Replace `~~chat` with Slack MCP, `~~project tracker` with `gm tasks list --source linear`, "Transcripts/Slack" with `kbx search` + Slack MCP, "Memory" with kbx
- "Pattern Detection": Replace email references with kbx/Slack, `~~project tracker` with `gm tasks list`
- "Strategic Alignment Check": Replace `/setup` references to use kbx equivalents

**Step 6: Update skills/chief-of-staff-identity/SKILL.md**

- "Relationship to the Productivity Plugin" section (lines 83-92): Replace entirely with "Relationship to kbx and gm" section explaining that kbx IS the memory system and gm IS the task system. No productivity plugin dependency.
- "Memory Philosophy" section (lines 94-101): Update two-tier description — kbx pinned notes are the hot cache, kbx search is deep storage. Remove TASKS.md and memory/ references.
- Line 108 "Slack + email + transcripts + Linear": Remove email

**Step 7: Commit**

```bash
git add skills/operating-rhythm/SKILL.md skills/meeting-intelligence/SKILL.md skills/information-management/SKILL.md skills/decision-support/SKILL.md skills/strategic-oversight/SKILL.md skills/chief-of-staff-identity/SKILL.md
git commit -m "refactor(skills): update all skills for kbx/gm integration"
```

---

### Task 11: Bump Version and Final Commit

**Files:**
- Modify: `.claude-plugin/plugin.json`

**Context:** Bump version from 0.2.0 to 0.3.0 to reflect the kbx/gm integration.

**Step 1: Update version**

In `.claude-plugin/plugin.json`, change `"version": "0.2.0"` to `"version": "0.3.0"`. Also update the description to remove the "Layers on top of the productivity plugin" phrasing. New description: "AI Chief of Staff for technology executives. Uses kbx (knowledge base) and gm (calendar/tasks) as primary data sources to provide strategic briefings, meeting intelligence, decision support, and proactive oversight. CTO-flavoured but adaptable to any executive role."

**Step 2: Commit**

```bash
git add .claude-plugin/plugin.json
git commit -m "chore: bump version to 0.3.0 for kbx/gm integration"
```

---

## Verification Checklist

After all tasks are complete, verify:

1. **No `~~` placeholders remain:** `grep -r '~~' commands/ agents/ skills/ CONNECTORS.md README.md` should return nothing
2. **No TASKS.md references remain:** `grep -r 'TASKS.md' commands/ agents/ skills/ CONNECTORS.md README.md` should return nothing
3. **No `memory/` directory references remain:** `grep -r 'memory/' commands/ agents/ skills/ CONNECTORS.md README.md` should return nothing (except possibly in design docs)
4. **No productivity plugin references remain:** `grep -r 'productivity' commands/ agents/ skills/ CONNECTORS.md README.md` should return nothing
5. **All files reference kbx/gm appropriately**
