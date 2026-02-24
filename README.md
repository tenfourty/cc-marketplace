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
