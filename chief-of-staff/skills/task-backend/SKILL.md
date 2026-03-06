# Task Backend

This skill defines how CoS manages tasks across any backend. The active backend and its concrete syntax are in the **CoS Configuration** pinned note (loaded via `kbx context`). This skill provides the generic interface and heuristics.

## Generic Interface

Every task backend supports these operations:

| Operation | Signature |
|-----------|-----------|
| **create** | `create(title, status, area?, due?, description?, project?: str \| null)` |
| **list** | `list(status?, area?, overdue?)` |
| **update** | `update(id, status?, due?, description?)` |
| **close** | `close(id)` |

## Status Values

| Status | Meaning | Max |
|--------|---------|-----|
| `right-now` | Doing today | 1-3 |
| `active` | In progress | — |
| `waiting-on` | Blocked on someone; note who/when in description | — |
| `someday` | Backlog | — |
| `done` | Completed | — |

## Area Selection

When creating a task, infer the area from context using this table:

| Signal Keywords | Area |
|----------------|------|
| hiring, interview, candidate, performance review, coaching, 1:1 follow-up, onboarding, team issue, training, mentoring | People |
| OKR, org design, strategy, AI adoption, career ladder, roadmap, architecture decision, tech debt prioritisation | Leadership |
| incident, deployment, monitoring, tooling, platform, security, infrastructure, on-call, migration, CI/CD | Ops |
| expense, travel, procurement, compliance, approval, vendor, contract, legal, budget | Admin |
| personal, family, household, health, finance | Home |
| journal, review, briefing, standup, recurring habit | Routines |

**Fallback:** If no signal matches, use `Inbox`.

## Mandatory Project Linking

Before creating any task, attempt to link it to a kbx project:

1. **Cache once per workflow:** At the start of any task-creating command, run `kbx project list --json`. Reuse for all task creations in that session.
2. **Match:** Check the action item text against project name, aliases, and `task_keywords` (word-boundary matching; `min_keyword_len=4`).
3. **If matched:** Include `project: <ProjectName>` in description. One project per task (pick the most specific if multiple match).
4. **If no match:** Create without a project link. Do not prompt to create a new project.

## Commitment Routing

Route each extracted commitment using this table:

| Accountability | Destination | How |
|---------------|-------------|-----|
| User personally accountable | Task (status: active or right-now) | Task backend create, with project link |
| User following up on someone | Task (status: waiting-on) | Task backend create, with project link |
| Delegated to direct report (1:1) | Person entity Open Items | Edit entity file: insert after `## Open Items` heading |
| Engineering/product work (not user's) | Project entity Open Items | Edit entity file: insert after `## Open Items` heading |
| General follow-up, no clear owner | Most relevant entity Open Items | Edit entity file |

**Open Items format:** `- [YYYY-MM-DD] Description (from: Meeting Title)`
Include `ref: <url>` when the source system URL is known. Agents may follow refs for automated status checking.

**If connected:** Also offer to create issues in the project tracker, or draft follow-up emails.

## Backend Dispatch

Read the **CoS Configuration** pinned note from `kbx context` output. It declares the active task backend and provides backend-specific syntax (exact CLI commands or file operations). Follow that syntax for all task operations.

**Example config note (gm backend):**
```
## Task Syntax (gm)
- Create: `gm tasks create --title "..." --tag {Status} --list {Area} --due {ISO} --description "..."`
- List: `gm tasks list --tag {Status} --json --response-format concise`
- Close: `gm tasks close {id}`
```

**Example config note (tasks.md backend):**
```
## Task Syntax (tasks.md)
- File: TASKS.md (in working directory)
- Create: Edit tool — insert `- [ ] **{title}** — {description} (due: {due}, area: {area}, project: {project})` at top of `## {Status}` section
- List: Read tool — parse `## {Status}` section for `- [ ]` lines
- Close: Edit tool — change `- [ ]` to `- [x]`, wrap in ~~strikethrough~~, move to `## Done`
```

**If no config note exists** (user hasn't run `/setup`):
1. Try `gm --help` — if it works, use gm backend
2. Check for `TASKS.md` in working directory — if it exists, use tasks.md backend
3. If neither, warn: "No task backend configured. Run `/setup` to get started."

## Calendar

Calendar backend is also declared in the CoS Configuration note. If no calendar backend is configured, warn once per session: "No calendar connection — calendar features will be skipped. Run /setup to connect one." Then skip calendar sections gracefully.

## Generic Source Categories

Use these categories instead of hardcoded tool names:

| Category | Meaning |
|----------|---------|
| project tracker | Linear, Jira, Asana, GitHub Issues — whatever's connected |
| chat | Slack, Teams, Discord — whatever's connected |
| email | Gmail, Outlook — whatever's connected |
| knowledge base | Notion, Confluence — beyond kbx |
| calendar | Google Calendar, Fastmail — if not using gm |

Check the CoS Configuration note for which sources are connected. Skip sections that reference unavailable sources.
