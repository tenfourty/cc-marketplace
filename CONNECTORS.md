# Connectors

This plugin uses tool-agnostic references in its skills and commands so the same workflows work regardless of which specific tools are connected.

## Claude.ai Integrations

This plugin relies on **Claude.ai integrations** (platform-managed MCP servers) rather than bundling its own. Connect these through your Claude.ai account settings before using the plugin.

### Required Integrations

| Claude.ai Integration | Placeholder | Purpose |
|----------------------|-------------|---------|
| **Calendar** | `~~calendar` | Schedule awareness, meeting prep, operating rhythm |
| **Slack** | `~~chat` | Team communication, thread monitoring, channel scanning |
| **Linear** | `~~project tracker` | Issue tracking, sprint status, engineering velocity |
| **Notion** | `~~knowledge base` | Documentation, wikis, team pages, meeting notes |
| **Granola** | `~~meeting transcripts` | Meeting transcripts, action extraction, decision capture |

### Optional Integrations

| Claude.ai Integration | Purpose |
|----------------------|---------|
| **Figma** | Design context for technical discussions |
| **HubSpot** | Customer/stakeholder relationship context |
| **n8n** | Workflow automation triggers |

## How Placeholders Work

When a skill or command references `~~chat`, Claude uses whichever matching tool is available (Slack via Claude.ai, etc.). This decouples the workflow logic from the specific integration.

## Graceful Degradation

All commands degrade gracefully when integrations are unavailable. Missing sources are noted in output, and the plugin works with whatever subset is connected. Even with just the local file system (TASKS.md, memory/), core functionality is available.
