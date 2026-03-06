# Tools

This plugin uses kbx as its required backbone and abstracts all other tools behind configurable backends. See the **task-backend** skill and the **CoS Configuration** pinned note for the active backend setup.

## Required

### kbx — Knowledge Base

Local knowledge base with hybrid search across meetings, people, projects, notes.
The `kbx --help` output should be in context from session startup hooks. If not, run `kbx --help` to load the command reference.

Key capabilities: search (keyword + semantic), people/project profiles, notes with tags, agent context orientation. Use `--plain` flag with `kbx view` for clean markdown output. Use `kbx note edit` to update existing notes (body, tags, pin status).

**kbx is always required.** CoS cannot function without it.

## Configurable Backends

These are declared in the **CoS Configuration** pinned note (created during `/setup`). The task-backend skill provides dispatch logic.

### Task Backend (one of)
- **tasks.md** — simple markdown file, zero dependencies (default for new users)
- **gm (Morgen)** — calendar + cross-source tasks via CLI
- **Project tracker MCP** — Linear, Jira, Asana, etc.

### Calendar Backend (one of)
- **gm** — Google Calendar + Fastmail via CLI
- **Google Calendar MCP** — fallback when gm unavailable
- **none** — calendar features skipped with a warning

## MCP Integrations

These are always accessed via MCP when connected:
- **Slack** — real-time team communication and channel scanning (chat)
- **Gmail** — email scanning for commitments, action items, and people context (email)
- **Linear** — issue tracking, write operations (project tracker)
- **Granola** — meeting transcripts, fallback when kbx search returns nothing
- **Notion** — knowledge base, fallback when kbx search returns nothing

## Graceful Degradation

All commands degrade gracefully when tools are unavailable. Missing sources are noted in output, and the plugin works with whatever subset is available. The task-backend skill documents fallback behaviour for each backend.
