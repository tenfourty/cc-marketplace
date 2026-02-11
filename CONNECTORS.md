# Connectors

This plugin uses tool-agnostic references in its skills and commands so the same workflows work regardless of which specific tools are connected.

## Connector Categories

| Category | Placeholder | Expected Tools | Purpose |
|----------|-------------|----------------|---------|
| Chat | `~~chat` | Slack | Team communication, thread monitoring, channel scanning |
| Project tracker | `~~project tracker` | Linear | Issue tracking, sprint status, engineering velocity |
| Knowledge base | `~~knowledge base` | Notion | Documentation, wikis, team pages, meeting notes |
| Meeting transcripts | `~~meeting transcripts` | Granola, Notion Meetings | Real-time and historical meeting transcripts |
| Calendar | `~~calendar` | Google Calendar | Schedule, meeting prep, operating rhythm |
| Email | `~~email` | Google Workspace, Fastmail | Communication scanning, action extraction |

## How Placeholders Work

When a skill or command references `~~chat`, Claude should use whichever chat tool is available (Slack MCP, etc.). This decouples the workflow logic from the specific integration.

## Required vs Optional

**Required for core functionality:**
- `~~chat` (Slack) -- team communication intelligence
- `~~project tracker` (Linear) -- initiative and task tracking
- `~~knowledge base` (Notion) -- organisational memory and documentation

**Required for meeting workflows:**
- `~~meeting transcripts` (Granola, Notion Meetings) -- transcript analysis, action extraction

**Required for daily briefings:**
- `~~calendar` (Google Calendar) -- schedule awareness
- `~~email` (Google Workspace/Fastmail) -- communication scanning

**Optional enhancements:**
- Additional project trackers (Jira, Asana) for cross-org visibility
- Additional knowledge bases (Confluence) for broader search

## Adding New Connectors

To add a new MCP connection, edit `.mcp.json` at the plugin root. The format is:

```json
{
  "mcpServers": {
    "service-name": {
      "type": "http",
      "url": "https://mcp.service.com/mcp"
    }
  }
}
```

Skills and commands using `~~category` placeholders will automatically pick up new tools in that category.
