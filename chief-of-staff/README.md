# Chief of Staff Plugin

An AI Chief of Staff for technology executives, built as a Claude Cowork plugin. Provides strategic briefings, meeting intelligence, decision support, and proactive oversight using `kbx` (knowledge base) and `gm` (calendar/tasks) as primary data sources.

CTO-flavoured by default, adaptable to any executive role.

## Prerequisites

This plugin requires two local CLI tools:

- **[kbx](https://github.com/tenfourty/kbx)** — Knowledge base with hybrid search across meetings, people, projects, notes
- **[gm (guten-morgen)](https://github.com/tenfourty/guten-morgen)** — Calendar events and cross-source task management (Morgen, Linear, Notion)

Both must be installed and configured before using this plugin. They should be set up with session startup hooks so their usage and context are available automatically — see the respective repos for installation instructions.

## Installation

From this marketplace:
```
claude plugins marketplace add github:tenfourty/cc-marketplace
claude plugins install chief-of-staff
```

Or from a local directory:
```
claude plugins add <path-to-this-directory>
```

Then run `/cos:setup` to personalise the Chief of Staff for your role, team, and priorities.

## Commands

### Daily Operations
| Command | Description |
|---------|-------------|
| `/cos:setup` | First-run personalisation — learns your role, team, priorities, CIRs |
| `/cos:briefing` | Morning briefing — calendar, priorities, overdue items, key signals. Day-aware: Sat/Sun/Mon includes week-ahead with calendar streamlining |
| `/cos:prep <meeting>` | Meeting preparation — attendee context, open items, suggested topics, "where we left off" |
| `/cos:debrief` | Post-meeting — extract actions, decisions, follow-ups. Follow-on: tldr, follow-up email, schedule follow-up, risk analysis |
| `/cos:status <topic>` | Cross-source status check on any topic, project, or person |
| `/cos:todos` | Scan recent meetings for your action items and commitments others owe you |

### Weekly Cadence
| Command | Description |
|---------|-------------|
| `/cos:review` | Weekly strategic review — patterns, blind spots, coach questions. Post-review: status update, team recap, coaching |
| `/cos:coach` | Mochary Method coaching session — energy audit, accountability, conscious leadership. Standalone or after review |

### Decision & Strategy
| Command | Description |
|---------|-------------|
| `/cos:decision [log\|recall\|help]` | Log a decision, recall past decisions, or get active decision coaching with frameworks |
| `/cos:blindspots [target]` | Adversarial risk analysis — on a meeting, topic, or the past week |
| `/cos:supergoal` | Interactive workshop to define a single high-stakes focusing goal |

### Knowledge & Culture
| Command | Description |
|---------|-------------|
| `/cos:codify [topic]` | Distil universal principles and best practices from meetings on any topic |
| `/cos:culture` | Surface the tacit, unspoken culture from recent meetings — an honest field guide |

## Architecture

### Two Voices
- **Staff voice** (daily operations): Efficient, structured, action-oriented — used for briefings, prep, debrief, status, todos, codify
- **Coach voice** (strategic work): Probing, pattern-aware, challenges assumptions — used for review, coaching, blindspots, culture, supergoal, decision help

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
| SuperGoal | `supergoal` | Yes (if active) |
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
| Gmail | Claude.ai MCP | Email scanning for commitments, action items, external comms |
| Linear | Claude.ai MCP | Issue creation/updates (write operations) |
| Google Calendar | Claude.ai MCP (fallback) | Calendar events if gm is unavailable |
| Granola | Claude.ai MCP (fallback) | Meeting transcripts if kbx returns nothing |
| Notion | Claude.ai MCP (fallback) | Knowledge base if kbx returns nothing |

Optional: Figma, HubSpot, n8n. See [CONNECTORS.md](CONNECTORS.md) for details.

## Design Influences

- [McChrystal Group Chief of Staff Playbook](https://www.mcchrystalgroup.com/) — CIR framework, decision-making framework, operating rhythm, trust model
- [goagentflow/ai-chief-of-staff](https://github.com/goagentflow/ai-chief-of-staff) — Files-as-memory philosophy, Quick Status tables, permission tiers
- [mboverell/ai-chief-of-staff](https://github.com/mboverell/ai-chief-of-staff) — Coach voice design, weekly review as killer feature, trajectory analysis
- [bbinto/bb-chiefofstaff](https://github.com/bbinto/bb-chiefofstaff) — Specialised agent pattern, MCP integration approach

## Licence

MIT
