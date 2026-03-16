# Chief of Staff Plugin — LLM Context

## Core Coupling

CoS is always coupled to **kbx** (knowledge base). It is never coupled directly to gm, Linear, Slack, or any other tool. All external tools are accessed through configurable backends or generic source categories.

## Functionality Tiers

| Tier | Requirements | What works |
|------|-------------|------------|
| **Tier 0** | kbx + tasks.md | Briefings, prep, debrief, todos, decisions, reviews — all core commands. Zero external dependencies beyond kbx. |
| **Tier 1** | kbx + gm (Morgen) | Tier 0 + calendar-aware briefings, time analysis, task scheduling, cross-source task views |
| **Tier 2** | kbx + gm + MCPs | Tier 1 + Commitment Inbox (chat/email/tracker scanning), real-time signals, cross-source search |

## Task Backend Abstraction

The task backend is fully abstracted via `skills/task-backend/SKILL.md`. Key concepts:

- **Generic interface**: create, list, update, close — works with any backend
- **Status values**: right-now, active, waiting-on, someday, done
- **Area selection**: Keyword heuristic maps tasks to areas (People, Leadership, Ops, Admin, Home, Routines, Inbox)
- **CoS Configuration note**: Created by `/setup`, tagged `config`, pinned in kbx. Contains a `## Connected Sources` inventory (which categories are available) and backend-specific syntax. All commands read this note to dispatch task operations and skip sections for missing sources.
- **Backend options**: tasks.md (default, zero deps), gm (Morgen CLI), project tracker MCP
- **Template**: `templates/TASKS.md` — used when a new user chooses the tasks.md backend

## Commitment Routing

Every extracted commitment is routed by accountability:

| Accountability | Destination |
|---------------|-------------|
| User personally accountable | Task (status: active or right-now) |
| User following up on someone | Task (status: waiting-on) |
| Delegated to direct report (1:1) | Person entity Open Items |
| Engineering/product work (not user's) | Project entity Open Items |
| General follow-up, no clear owner | Most relevant entity Open Items |

## Commitment Inbox (Tier 2 only)

The `/briefing` command includes a Commitment Inbox section when chat, email, or project tracker MCPs are connected. It scans for commitments made to/by the user in the last 24 hours and surfaces untracked items for triage.

## Generic Source Categories

Commands never reference specific tool names (Slack, Linear, Gmail). Instead they use generic categories:

| Category | Examples |
|----------|----------|
| project tracker | Linear, Jira, Asana, GitHub Issues |
| messaging | Beeper (WhatsApp, Signal, Telegram, iMessage aggregator) |
| chat | Slack, Teams, Discord |
| email | Gmail, Outlook |
| knowledge base | Notion, Confluence |
| calendar | Google Calendar, Fastmail |

The CoS Configuration note declares which sources are connected. Commands skip sections for unavailable sources.

## `/setup` Flow

1. Detect kbx (required) — stop if missing
2. Probe backends silently (gm, MCPs)
3. Ask about company tooling
4. Present task backend choice (tasks.md as first-class option)
5. Warn if no calendar detected
6. Create CoS Configuration pinned note with backend-specific syntax
7. Learn the executive (role, people, priorities, CIRs, rhythm)
8. Probe kbx richness and decode shorthand
9. Import existing tasks (optional)
10. Create task areas
11. Write pinned notes (CIRs, initiatives, meetings, rhythm, people)
12. Confirm and orient

## Skills Architecture

All skills live in `skills/*/SKILL.md` with YAML frontmatter (`always_on: true`). The plugin framework auto-loads always-on skills into agent context — no explicit Skill tool invocations needed in commands.

**9 always-on skills:**
- `chief-of-staff-identity` — voice, principles, CTO context
- `task-backend` — generic task interface, area heuristics, backend dispatch
- `search-strategy` — intent-based kbx query routing (entity lookups vs tag filters vs search)
- `information-management` — CIRs, filtering, dedup-before-writing protocol
- `meeting-intelligence` — transcript source priority, multi-source handling, extraction principles
- `decision-support` — decision frameworks, logging format, coaching patterns
- `operating-rhythm` — cadence health, rhythm disruptions
- `strategic-oversight` — initiative tracking, SuperGoal, trajectory analysis
- `coaching-bridge` — cross-plugin coaching insight sharing with inner-game

**Dedup Before Writing:** The information-management skill defines a READ→COMPARE→SKIP/MERGE/CREATE protocol. Commands reference it when writing entity facts, Open Items, or decisions. Prevents duplicate accumulation across debriefs and reviews.

**Unattended prompts:** `scripts/prompts/debrief-unattended.md` and `prep-unattended.md` — used by the automated meeting intel pipeline (`scripts/auto-meeting-intel.sh` in compass).

## Project Linking

Tasks link to kbx projects via:
1. **Explicit**: `project: <ProjectName>` in task description (one project per task)
2. **Fallback**: Case-insensitive title match against project name, aliases, `task_keywords` (min_keyword_len=4)
