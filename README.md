# Chief of Staff Plugin

An AI Chief of Staff for technology executives, built as a Claude Cowork plugin. Layers on top of the [Anthropic productivity plugin](https://github.com/anthropics/knowledge-work-plugins/tree/main/productivity) to provide strategic briefings, meeting intelligence, decision support, and proactive oversight.

CTO-flavoured by default, adaptable to any executive role.

## Prerequisites

This plugin layers on top of the [Anthropic productivity plugin](https://github.com/anthropics/knowledge-work-plugins/tree/main/productivity), which provides the task management (`TASKS.md`) and memory system (`memory/`) that the Chief of Staff builds upon.

If you haven't already, install it:
```
claude plugins add knowledge-work-plugins/productivity
```

## Installation

```
claude plugins add <path-to-this-directory>
```

Then run `/cos:setup` to personalise the Chief of Staff for your role, team, and priorities. It will check whether the productivity plugin's files exist and guide you through creating them if needed.

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

### Memory Structure
Extends the productivity plugin's memory system with:
```
memory/
├── decisions/        # Monthly decision logs
├── priorities/       # CIRs and active initiatives
├── meetings/         # Recurring meeting context
└── rhythms/          # Operating rhythm definitions
```

## Connected Tools (Claude.ai Integrations)

This plugin uses Claude.ai platform integrations rather than bundling its own MCP servers. Connect these through your Claude.ai account settings:

| Integration | Placeholder | Purpose |
|-------------|-------------|---------|
| Calendar | `~~calendar` | Schedule awareness, meeting prep |
| Slack | `~~chat` | Team communication intelligence |
| Linear | `~~project tracker` | Issue tracking, engineering velocity |
| Notion | `~~knowledge base` | Documentation, wikis, team pages |
| Granola | `~~meeting transcripts` | Meeting transcripts and notes |

Optional: Figma, HubSpot, n8n. See [CONNECTORS.md](CONNECTORS.md) for details.

## Design Influences

- [McChrystal Group Chief of Staff Playbook](https://www.mcchrystalgroup.com/) — CIR framework, decision-making framework, operating rhythm, trust model
- [Anthropic Productivity Plugin](https://github.com/anthropics/knowledge-work-plugins/tree/main/productivity) — Task management, memory architecture, connector patterns
- [goagentflow/ai-chief-of-staff](https://github.com/goagentflow/ai-chief-of-staff) — Files-as-memory philosophy, Quick Status tables, permission tiers
- [mboverell/ai-chief-of-staff](https://github.com/mboverell/ai-chief-of-staff) — Coach voice design, weekly review as killer feature, trajectory analysis
- [bbinto/bb-chiefofstaff](https://github.com/bbinto/bb-chiefofstaff) — Specialised agent pattern, MCP integration approach

## Licence

Apache-2.0
