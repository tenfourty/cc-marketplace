# Tools

This plugin uses local CLI tools as primary data sources, with Claude.ai integrations as fallbacks.

## Primary Tools

### kbx — Knowledge Base

Local knowledge base with hybrid search across meetings, people, projects, notes.
The `kbx usage` output should be in context from session startup hooks. If not, run `kbx usage` to load the command reference.

Key capabilities: search (keyword + semantic), people/project profiles, notes with tags, agent context orientation. Use `--plain` flag with `kbx view` for clean markdown output. Use `kbx note edit` to update existing notes (body, tags, pin status).

### gm — Calendar & Tasks

Calendar events (Google/Fastmail) + cross-source tasks (Morgen, Linear, Notion).
The `gm usage` output should be in context from session startup hooks. If not, run `gm usage` to load the command reference.

Key capabilities: events, tasks (cross-source), availability, scheduling, task lifecycle via tags (Right-Now, Active, Waiting-On, Someday) and lists (Leadership, People, Ops, Admin, Home, Routines).

## Claude.ai Integrations (Fallback)

When CLI tools are unavailable, use these Claude.ai integrations:
- **Granola** — meeting transcripts, if kbx search returns nothing
- **Notion** — knowledge base, if kbx search returns nothing
- **Google Calendar** — calendar events, if gm is unavailable
- **Linear** — issue updates/creation (gm only reads Linear tasks)

## Always via MCP

These tools are always accessed via Claude.ai MCP (no CLI equivalent):
- **Slack** — real-time team communication and channel scanning
- **Gmail** — email scanning for commitments, action items, and people context
- **Linear** — for write operations (create/update issues)

## Graceful Degradation

All commands degrade gracefully when tools are unavailable. Missing sources are noted in output, and the plugin works with whatever subset is available.
