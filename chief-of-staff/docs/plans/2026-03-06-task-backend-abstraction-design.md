# CoS Task Backend Abstraction — Component Design

**Date:** 2026-03-06
**Status:** Draft — decisions resolved 2026-03-06
**Author:** cos-dev
**Parent doc:** `docs/plans/2026-03-06-cross-system-commitment-architecture.md` (Control Tower)

## Context

CoS currently hardcodes `gm tasks create/list/close` in 20 active files (200 occurrences). This couples every CoS command to gm/Morgen, preventing users without Morgen from using task management features. The top-level architecture specifies that CoS should abstract the task backend: gm is one option, `tasks.md` is the default for new users, and other backends (Linear MCP, Google Tasks, etc.) are possible.

**Hard constraint:** CoS is ALWAYS tightly coupled to kbx (required). CoS is NOT coupled to gm. CoS knows nothing about brief-deck.

### Cross-Cutting Decisions (resolved)

- **`min_keyword_len` = 4** — short acronyms (e.g., "AI") should use descriptive `task_keywords` on projects, not rely on substring matching
- **`project` field is a string** (not list) — 1:1 task-to-project enforced. `null` if no project.
- **Strong typing in Python APIs** — `TaskInput(TypedDict)` with `title: str` and `description: str | None` (kbx's own type, no gm dependency). Flexible on CLI interfaces.
- **`--help` output** should use layered LLM context (top-level = overview, subcommand = detailed contracts)

---

## 1. Task Backend Abstraction

### 1a. Generic Interface

Every task backend must support these operations:

| Operation | Signature | Required? |
|-----------|-----------|-----------|
| **create** | `create(title, status, area?, due?, description?, project?: str \| null)` | Yes |
| **list** | `list(status?, area?, overdue?, source?)` | Yes |
| **update** | `update(id, status?, due?, description?)` | Yes |
| **close** | `close(id)` | Yes |
| **search** | `search(query)` | Nice-to-have |

**Universal status values:**
- `right-now` — doing today (max 1-3)
- `active` — in progress
- `waiting-on` — blocked; note who/when in description
- `someday` — backlog
- `done` — completed

**Area values:** User-configured during `/setup`. Defaults: Inbox, Leadership, People, Ops, Admin, Home, Routines. Not all backends support areas natively — see per-backend sections.

**Project linking:** All backends support `project: <Name>` in the description field — a **single string** (not a list). Each task links to exactly one project or `null`. This is a convention, not a backend feature.

### 1b. Where the Abstraction Lives

**Decision: New skill file `task-backend/SKILL.md` — lean, ~80 lines.** ✅ Resolved

**Approach B (context efficiency):** The skill file is intentionally lean — generic interface, status/area definitions, dispatch logic, heuristics. The CoS Configuration pinned note (created by `/setup`) carries the backend-specific syntax for the active backend only (~20-30 lines, LLM-generated during setup). This avoids loading all backend implementations into every session.

Rationale:
- Keeps the identity skill focused on persona/voice/principles
- Minimises always-on context cost — only the generic interface + heuristics live in the skill
- Backend-specific syntax (exact CLI commands, file operations) lives in the config note, generated once during `/setup`
- The config note is pinned → appears in `kbx context` → every command sees the active backend's concrete syntax

Structure:

```
skills/
  task-backend/
    SKILL.md          # ~80 lines: generic interface + dispatch logic + heuristics
```

The skill file contains:
1. The generic interface table (operations, status values, area values)
2. How to read the active backend from the CoS Configuration note
3. The list-selection heuristic
4. The mandatory project-linking flow
5. A reference to the config note for backend-specific syntax

The CoS Configuration note (created by `/setup`) contains:
1. Active backend declaration (task, calendar, chat, email, project tracker)
2. Backend-specific syntax for the active task backend only (e.g., gm commands OR tasks.md Edit tool patterns)
3. Area list and any custom keyword mappings

### 1c. Active Backend Persistence

The active backend is stored as a field in a pinned kbx note tagged `config`:

```bash
kbx memory add "CoS Configuration" --body "..." --tags config --pin
```

Content (~20-30 lines, LLM-generated during `/setup` with backend-specific syntax for active backends only):

**Example: gm backend active**
```markdown
# CoS Configuration

Last updated: 2026-03-06

## Backends
- Task: gm
- Calendar: gm
- Chat: slack-mcp
- Email: gmail-mcp
- Project tracker: linear-mcp

## Task Syntax (gm)
- Create: `gm tasks create --title "..." --tag {Status} --list {Area} --due {ISO} --description "..."`
- List: `gm tasks list --tag {Status} --json --response-format concise`
- List overdue: `gm tasks list --overdue --json`
- Update: `gm tasks update {id} --tag {Status}`
- Close: `gm tasks close {id}`
- Status mapping: right-now→Right-Now, active→Active, waiting-on→Waiting-On, someday→Someday

## Calendar Syntax (gm)
- Today: `gm today --hide-declined --counts --json --response-format concise --no-frames`
- This week: `gm this-week --hide-declined --json --response-format concise --no-frames`

## Areas of Focus
Leadership, People, Ops, Admin, Home, Routines
```

**Example: tasks.md backend active**
```markdown
# CoS Configuration

Last updated: 2026-03-06

## Backends
- Task: tasks.md
- Calendar: none
- Chat: none
- Email: none
- Project tracker: none

## Task Syntax (tasks.md)
- File: TASKS.md (in working directory)
- Create: Edit tool — insert `- [ ] **{title}** — {description} (due: {due}, area: {area}, project: {project})` at top of `## {Status}` section
- List: Read tool — parse `## {Status}` section for `- [ ]` lines
- List overdue: Read + parse all sections for `due:` dates before today
- Update: Edit tool — move task line + sub-bullets between sections
- Close: Edit tool — change `- [ ]` to `- [x]`, wrap title in ~~strikethrough~~, append `(completed: {today})`, move to `## Done`
- No numeric IDs — tasks identified by title (bold portion)

## Areas of Focus
Leadership, People, Ops, Admin, Home, Routines
```

This note appears in `kbx context` output at session start. Every command reads it to determine which backend syntax to use. The note is **generated by the LLM during `/setup`** — not a static template. This means the syntax section is always accurate for the specific backend version installed.

**If kbx is unavailable** (should not happen — kbx is required), the skill falls back to checking for `TASKS.md` in the working directory as the implicit task backend.

### 1d. tasks.md Backend

**File format** (aligned with Anthropic productivity plugin where sensible, adapted for CoS status model):

```markdown
# Tasks

## Right Now
- [ ] **Task title** — context (due: 2026-03-10, area: Ops, project: Platform Stability)
  - Sub-detail if needed

## Active
- [ ] **Task title** — context (due: 2026-03-15, area: Leadership)
  - project: AI Adoption

## Waiting On
- [ ] **[Person]: Task title** — context (since: 2026-03-01, area: People, project: On-Call Rotation)

## Someday
- [ ] **Task title** — context (area: Admin)

## Done
- [x] ~~Task title~~ (completed: 2026-03-05)
```

**Format rules:**
- Each task is a markdown checkbox: `- [ ]` (open) or `- [x]` (done)
- Title in **bold** for scannability
- Metadata in parentheses: `due:`, `area:`, `project:`, `since:` (for Waiting On)
- `project:` is a single string — one project per task, or omit if no project
- Waiting On tasks prefix with `[Person]:` for who's responsible
- Done tasks use strikethrough + completion date
- Sub-bullets for additional context
- Sections are in the order shown — status maps directly to section names

### 1d-ii. Template TASKS.md

Created by `/setup` when tasks.md is the active backend:

```markdown
# Tasks

## Right Now

## Active

## Waiting On

## Someday

## Done
```

Empty sections are pre-created so the Edit tool has clear insertion points. The file is placed in the working directory by default (override via config).

**Operation mapping:**

| Operation | Implementation |
|-----------|---------------|
| **create(title, status, area, due, description, project)** | Use the Edit tool to insert a new `- [ ]` line at the top of the matching status section. Format: `- [ ] **{title}** — {description} (due: {due}, area: {area}, project: {project})` |
| **list(status)** | Use the Read tool to read `TASKS.md`. Parse the relevant `## {Status}` section. Return all `- [ ]` lines with their sub-bullets. |
| **list(overdue)** | Read `TASKS.md`. Parse all sections except Done. Find items with `due:` dates before today. |
| **list(area)** | Read `TASKS.md`. Parse all sections. Filter items containing `area: {value}`. |
| **update(id, status)** | Use the Edit tool to move the task line (and sub-bullets) from the current section to the target section. The "id" is the task title text (bold portion) since tasks.md has no numeric IDs. |
| **close(id)** | Use the Edit tool to: (1) change `- [ ]` to `- [x]`, (2) wrap title in `~~strikethrough~~`, (3) append `(completed: {today})`, (4) move to `## Done` section. |
| **search(query)** | Use the Grep tool to search `TASKS.md` for the query string. |

**Limitations vs gm:**
- No numeric task IDs — tasks are identified by title
- No `--source linear` filtering (single source)
- No `--response-format concise --json` (must parse markdown)
- No calendar integration / timeblocking
- No cross-source task aggregation (gm syncs from Linear, Notion, etc.)

**Advantages:**
- Zero dependencies — works with just Claude Code
- Human-readable and editable outside of Claude
- Git-friendly (diffable, mergeable)
- Can be synced with external tools via `/update`

### 1e. gm Backend

**Operation mapping** (lives in the CoS Configuration note when gm is active, not in the skill file):

| Operation | Implementation |
|-----------|---------------|
| **create** | `gm tasks create --title "..." --tag {Status} --list {Area} --due {ISO} --description "..."` |
| **list(status)** | `gm tasks list --tag {Status} --json --response-format concise` |
| **list(overdue)** | `gm tasks list --overdue --json` |
| **list(area)** | `gm tasks list --list {Area} --json --response-format concise` |
| **list(source)** | `gm tasks list --source {source} --json` |
| **update(id, status)** | `gm tasks update {id} --tag {Status}` |
| **close(id)** | `gm tasks close {id}` |
| **search** | `gm tasks list --json --response-format concise` then filter |

**Status mapping:** gm uses `--tag` with capitalised values: `Right-Now`, `Active`, `Waiting-On`, `Someday`. The skill documents the mapping from generic lowercase to gm-specific capitalised form.

**Area mapping:** gm uses `--list` with the area name directly. Areas must exist as Morgen lists (created during `/setup`).

### 1f. Linear MCP Backend

**Operation mapping** (lives in the CoS Configuration note when Linear is active):

| Operation | Implementation |
|-----------|---------------|
| **create** | Linear MCP `createIssue` with title, description, status mapping, team/project |
| **list** | Linear MCP `searchIssues` filtered by assignee + status |
| **update** | Linear MCP `updateIssue` with status transition |
| **close** | Linear MCP `updateIssue` with status = Done/Completed |

**Status mapping:** Linear's status model (Backlog, Todo, In Progress, Done, Cancelled) maps to CoS statuses:
- right-now → In Progress (with priority flag)
- active → In Progress or Todo
- waiting-on → Todo (with "blocked" label or comment)
- someday → Backlog
- done → Done

**Area mapping:** Linear doesn't have "areas". Projects/teams serve a similar role but aren't 1:1. The skill documents this gap.

**Limitations:** Linear MCP availability is session-dependent (Claude.ai integration). Not available in all environments.

### 1g. Future Backends

The skill includes a "Adding a New Backend" section with the contract:
1. Map create/list/update/close to your backend's operations
2. Map the 5 status values
3. Document how areas are handled (or not)
4. Add a detection method for `/setup`
5. Add a section to the skill file

---

## 2. `/setup` Redesign

### 2a. Current Flow

```
Step 1: Check tool availability (kbx --help, gm --help)
        → If missing, tell user to install
Step 2: Learn the Executive (interview)
Step 2.5: Learn Your World (data source scan)
Step 3: Write to kbx (CIRs, initiatives, meetings, rhythm)
Step 4: Confirm and orient
Step 5: Suggest next actions
```

**Current assumption:** Both kbx and gm are required. Setup fails early if either is missing.

### 2b. Proposed Flow

```
Step 1: Detect available backends
  1a. kbx --help → REQUIRED. If missing, guide installation and stop.
  1b. gm --help → note availability
  1c. Check for project tracker MCP → note availability
  1d. Check for calendar MCP → note availability (don't mention specific vendors in prompts)
  1e. Check for chat/email MCPs → note for commitment scanning
  1f. Ask: "What task systems does your company use? (Linear, Jira, Notion, Todoist, etc.)"
      — This informs which MCPs to suggest connecting and how to route commitments
  1g. Present detected options:
      - If only one backend available → use it, confirm
      - If multiple → ask user to choose. **tasks.md is a first-class option**, not just a fallback
      - Frame as: "I can manage your tasks in: (a) tasks.md — a simple file, zero dependencies, (b) Morgen — full calendar + task integration, (c) [detected MCP] — sync with your existing tracker"
  1h. If no calendar backend detected → warn: "No calendar connection found. Calendar-dependent features (briefing schedule, time analysis) will be limited. You can connect one later via /setup."
  1i. Store configuration in pinned kbx note tagged 'config' (with backend-specific syntax)

Step 2: Learn the Executive (interview — unchanged)

Step 2.5: Learn Your World (data source scan — unchanged)

Step 2.7: Import Existing Tasks (NEW — Anthropic plugin pattern)
  - Ask: "Do you have an existing task list? This could be:
    - A file (todo.txt, TASKS.md, etc.)
    - An app (Linear, Asana, Jira, Notion, Todoist)
    - Or we can start fresh"
  - If file: Read it, decode shorthand, create kbx entities for people/projects found
  - If app: Sync via MCP, decode, create entities
  - If fresh: Skip (tasks will be created naturally through debriefs/todos)
  - For tasks.md backend: import creates the initial TASKS.md
  - For gm backend: import creates gm tasks via CLI

Step 3: Write to kbx (CIRs, initiatives, meetings, rhythm, CONFIG — expanded)

Step 3.5: Create Task Areas (NEW)
  - For gm backend: `gm lists create` for any missing default lists
  - For tasks.md: areas are metadata tags, no setup needed
  - Ask user if default areas (Leadership, People, Ops, Admin, Home, Routines) work
  - Offer to customise

Step 4: Confirm and orient (expanded to mention task backend)

Step 5: Suggest next actions (unchanged)
```

### 2c. kbx as Required Dependency

If kbx is not installed:

```
kbx is required for the Chief of Staff plugin. It's the knowledge backbone
that stores your meetings, people, projects, decisions, and context.

Install it:
  uv tool install "kbx[search]"    # Standard install
  uv tool install --editable ./kbx  # Dev mode (if you have the source)

Then run /cos:setup again.
```

**No auto-install.** kbx requires configuration (data directory, embedding model choice) that shouldn't be guessed. The setup command guides but doesn't force.

### 2d. Configuration Storage

Stored as a pinned kbx note. See section 1c for format.

The note is created/updated during `/setup` Step 1g and Step 3. Commands read it from `kbx context` output (it's pinned, so it's always loaded).

**If the config note doesn't exist** (user hasn't run setup, or ran an old version): commands fall back to probing at runtime:
1. Try `gm --help` → if it works, assume gm backend
2. Check for `TASKS.md` → if it exists, assume tasks.md backend
3. If neither, warn and suggest running `/setup`

---

## 3. Command Migration

### 3a. Full Inventory of gm References

**Active files requiring migration (excluding docs/plans/):**

| File | gm occurrences | What it uses |
|------|---------------|--------------|
| **Skills** | | |
| `skills/chief-of-staff-identity/SKILL.md` | 1 | Defines gm as task system |
| `skills/operating-rhythm/SKILL.md` | 12 | Calendar + task CLI references |
| `skills/meeting-intelligence/SKILL.md` | 8 | Task cross-ref, create, project linking |
| `skills/decision-support/SKILL.md` | 2 | Task creation after decisions |
| `skills/strategic-oversight/SKILL.md` | 2 | Linear via gm, velocity tracking |
| `skills/information-management/SKILL.md` | 3 | CIR evaluation, correlation |
| **Commands** | | |
| `commands/briefing.md` | 9 | Calendar (today/this-week), tasks (all tags, overdue, stale) |
| `commands/debrief.md` | 6 | Task creation (Active, Waiting-On), cross-ref |
| `commands/prep.md` | 5 | Calendar (today), task cross-ref |
| `commands/review.md` | 10 | Calendar (this-week), tasks (all tags, overdue), stale audit |
| `commands/todos.md` | 14 | Task cross-ref, creation, stale audit, deep scan |
| `commands/decision.md` | 3 | Task creation, calendar |
| `commands/status.md` | 3 | Task search, Linear via gm |
| `commands/coach.md` | 4 | Calendar, task patterns |
| `commands/blindspots.md` | 1 | Task status check |
| `commands/setup.md` | 1 | gm --help check, list creation |
| `commands/culture.md` | 1 | Calendar awareness |
| `commands/boot-team.md` | 1 | Tool reference |
| **Agents** | | |
| `agents/action-tracker.md` | 12 | Task creation, audit, cross-ref |
| `agents/weekly-review.md` | 7 | Calendar, tasks, Linear via gm |
| `agents/ops.md` | 4 | Calendar, tasks |
| `agents/briefer.md` | 3 | Task creation after debrief |
| `agents/meeting-prep.md` | 3 | Calendar, Linear via gm |
| `agents/cross-source-search.md` | 2 | Task search, Linear via gm |
| `agents/advisor.md` | 1 | Workload analysis |
| **Other** | | |
| `CONNECTORS.md` | 1 | gm tool description |

**Total: 26 active files, ~118 occurrences** (excluding docs/plans/).

### 3b. Migration Pattern

**Before (literal gm):**

```markdown
**Tasks (gm):**
- `gm tasks list --tag Right-Now --json` for today's focus items
- `gm tasks list --overdue --json` for overdue items
- `gm tasks list --tag Waiting-On --json` for items pending from others
```

**After (generic interface):**

```markdown
**Tasks (see task-backend skill for active backend):**
- List tasks with status `right-now` for today's focus items
- List overdue tasks for overdue items
- List tasks with status `waiting-on` for items pending from others
```

**Before (task creation):**

```markdown
| User is personally accountable | Morgen task (Active or Right-Now) | `gm tasks create --title "..." --tag Active --list LIST --due ISO --description "..."` |
```

**After:**

```markdown
| User is personally accountable | Task (active or right-now) | Create task: title, status=active, area=[from heuristic], due=[if stated], description="[context]\nproject: [Name]" |
```

**Before (calendar):**

```markdown
- `gm today --hide-declined --counts --json --response-format concise --no-frames`
```

**After:**

```markdown
- Load today's calendar using the configured calendar backend (see CoS Configuration note):
  - If gm: `gm today --hide-declined --counts --json --response-format concise --no-frames`
  - If Google Calendar MCP: query today's events via the MCP
  - If none: warn "No calendar backend configured — calendar sections will be skipped. Run /setup to connect one." Then skip calendar section.
```

### 3c. How Commands Reference the Active Backend

1. At the start of each command's process, the model reads the CoS Configuration from `kbx context` output (it's a pinned note)
2. The task-backend skill provides the dispatch logic: "If task backend is `gm`, use these commands. If `tasks.md`, use these operations."
3. Commands use generic language ("create a task with status active") rather than backend-specific syntax
4. The skill translates generic operations to concrete syntax based on the active backend

**Why this works for LLMs:** The model processes all always-on skills before executing commands. When a command says "create a task", the model already knows from the skill that "task backend is tasks.md" → "use Edit tool to insert into ## Active section". No template engine or runtime dispatch needed.

---

## 4. List-Selection Heuristic

### 4a. The Mapping Table

| Signal Keywords | Area |
|----------------|------|
| hiring, interview, candidate, performance review, coaching, 1:1 follow-up, onboarding, team issue, training, mentoring | People |
| OKR, org design, strategy, AI adoption, career ladder, roadmap, architecture decision, tech debt prioritisation | Leadership |
| incident, deployment, monitoring, tooling, platform, security, infrastructure, on-call, migration, CI/CD | Ops |
| expense, travel, procurement, compliance, approval, vendor, contract, legal, budget | Admin |
| personal, family, household, health, finance | Home |
| journal, review, briefing, standup, recurring habit | Routines |

**Fallback:** If no signal matches, default to `Inbox` (triage point).

### 4b. Where It Lives

In `skills/task-backend/SKILL.md` under a "## Area Selection" heading. This keeps all task-related logic in one skill.

### 4c. Custom Areas

During `/setup`, the user can customise areas. The heuristic table is stored in the CoS Configuration note alongside the area list. If a user has different areas (e.g., "Engineering" instead of "Ops"), they map their keywords during setup.

**For tasks.md backend:** Areas are metadata tags in parentheses, not structural sections. A task `(area: Ops)` lives in the `## Active` section, not a separate `## Ops` section. Status drives section placement; area is metadata.

**For gm backend:** Areas map to Morgen lists, which are structural. `gm tasks create --list Ops` places the task in the Ops list.

---

## 5. Mandatory Project Linking

### 5a. The Flow

```
Before creating any task:
1. Load project list: `kbx project list --json`
   (Cache for the session — this rarely changes mid-conversation)
2. For the action item text, attempt to match:
   a. Explicit: item mentions a known project name or alias
   b. Keyword: item contains a project's task_keywords
   c. Context: the meeting being debriefed relates to a known project
3. If matched:
   - Include `project: <ProjectName>` in the task description (always)
   - If multiple matches, pick the **most specific** one (1:1 enforced — `project` is a string, not a list)
4. If no match:
   - Create without project link
   - Do NOT offer to create a new project (noisy for most items)
5. If the kbx project list is empty or kbx is slow:
   - Create without project link, note it
```

### 5b. Performance

**Concern:** Running `kbx project list --json` before every task creation could be slow.

**Mitigation:** Cache the project list at the start of any task-creating command (debrief, todos, decision). These commands typically create 3-10 tasks in one session, so one `kbx project list` call serves all of them.

The task-backend skill documents this: "At the start of any task-creating workflow, load the project list once. Reuse it for all task creations in that workflow."

### 5c. Matching Logic

Use the same two-tier matching that kbx's `match_tasks_to_projects()` implements (per the top-level design doc):
- **Tier 1:** Explicit `project: <Name>` already in the source (e.g., meeting had a project mentioned)
- **Tier 2:** Word-boundary matching of task title against project name + aliases + task_keywords. Short keywords (< 4 chars, i.e. `min_keyword_len=4`) require word boundaries. Short acronyms (e.g., "AI") should use descriptive `task_keywords` on projects instead.

The skill describes the matching heuristic so the LLM can apply it during extraction, before creating the task.

---

## 6. Commitment Routing Table

### 6a. Full Two-Dimensional Table

**Rows: Accountability** | **Columns: Source System**

| Accountability | Default (any backend) | If project tracker connected | If email connected |
|---------------|----------------------|-----------------------------|--------------------|
| **User personally accountable** | Task (status: active, with project link) | Also offer: create issue in ~~project tracker | — |
| **User following up on someone else's commitment** | Task (status: waiting-on, with project link) | Also offer: create issue assigned to them | — |
| **Engineering/product work item (not user's)** | Entity Open Items on project entity | Offer: create issue in ~~project tracker | — |
| **Delegated to direct report (1:1)** | Entity Open Items on person entity | — | — |
| **External stakeholder follow-up** | Task (status: active, with project link) | — | Also offer: draft follow-up email via ~~email |
| **General follow-up, no clear owner** | Entity Open Items on most relevant entity | — | — |

### 6b. Graceful Degradation

| Missing Backend | Impact | Fallback |
|----------------|--------|----------|
| No task backend configured | Can't create tasks | Warn user, suggest `/setup` |
| No project tracker MCP | Can't offer issue creation | Skip project tracker column |
| No email MCP | Can't offer email drafts | Skip email column |
| No chat MCP | Can't scan for commitment language | Skip commitment scanning in briefing |
| No calendar | Can't schedule follow-ups | Skip calendar suggestions |

The routing table in the skill always includes all columns but annotates each with: "Only if ~~{category} is connected (see CoS Configuration)."

### 6c. Generic Source Categories

The skill and all commands use these category placeholders:

| Category | Placeholder | What it means |
|----------|------------|---------------|
| Project tracker | ~~project tracker | Linear, Jira, Asana, GitHub Issues — whatever's connected |
| Chat | ~~chat | Slack, Teams, Discord — whatever's connected |
| Email | ~~email | Gmail, Outlook, Fastmail — whatever's connected |
| Knowledge base | ~~knowledge base | Notion, Confluence — beyond kbx (fallback sources) |
| Calendar | ~~calendar | Google Calendar, Fastmail — if not using gm |

**Migration:** Replace all hardcoded "Linear" references with "~~project tracker" (except where Linear-specific features are being used). Replace "Slack" with "~~chat". Replace "Gmail" with "~~email".

**Exceptions:** Some references are legitimately Linear-specific (e.g., `gm tasks list --source linear`). These only apply when the gm backend is active AND Linear is the connected tracker. The skill documents this.

---

## 7. Briefing Commitment Inbox

### 7a. What Gets Scanned

| Source | What's scanned | Commitment signals |
|--------|---------------|-------------------|
| ~~chat (Slack etc.) | Key channels, DMs from direct reports and stakeholders | "I'll", "I will", "let me", "by Friday", "action item", "todo", "follow up", "will send" |
| ~~email (Gmail etc.) | Sent mail (last 24h), inbox from important senders | Same patterns in sent mail = user's commitments. In inbox = requests directed at user. |

### 7b. Duplicate Detection

For each detected commitment:
1. Search existing tasks (via task backend `list` + `search`)
2. Fuzzy match on title/description — if a task exists with >70% token overlap, consider it tracked
3. Check entity Open Items for similar items

**Only surface commitments NOT already tracked.** The goal is to catch dropped balls, not duplicate existing tasks.

### 7c. Output Format

```markdown
### Commitment Inbox
[Only if untracked commitments found. Skip entirely if clean.]

**From ~~chat:**
- "[commitment quote]" — #channel, [date]. Not in your tasks.
- "[commitment quote]" — DM with [Person], [date]. Not in your tasks.

**From ~~email:**
- Sent to [recipient] ([date]): "[commitment quote]". Not in your tasks.
- From [sender] ([date]): "[request quote]". Not in your tasks.

Want me to create tasks for any of these?
```

### 7d. Tier Availability

| Tier | Commitment Inbox available? | Why |
|------|---------------------------|-----|
| Tier 0 | No | No chat/email MCPs |
| Tier 1 | No | No chat/email MCPs (gm doesn't provide chat/email) |
| Tier 2 | Yes | Chat and/or email MCPs available |

The briefing command checks the CoS Configuration for connected chat/email backends. If neither is available, the Commitment Inbox section is skipped entirely (not even mentioned).

---

## 8. Inner Game Considerations

### 8a. Current State

Inner Game currently uses `project: Inner Game` in gm task descriptions to link its coaching tasks to a kbx project. It also uses `gm tasks create` directly in:
- `agents/coach.md` — creates coaching tasks in Home/Routines lists
- `CONNECTORS.md` — documents the convention

### 8b. Does Inner Game Need the Task Backend Abstraction?

**Recommendation: Not yet, but eventually yes.**

Inner Game creates far fewer tasks than CoS (just coaching commitments). The gm dependency is lighter. But for the "lego block" vision, Inner Game should eventually:
1. Read the CoS Configuration note for the active task backend
2. Use the same generic interface to create coaching tasks
3. Use `area: Home` or `area: Routines` instead of `--list Home`

**For now:** Inner Game can remain gm-coupled. If a user has no gm, Inner Game's task creation silently fails (coaching works fine without tasks). This is acceptable for the initial release.

**For the tasks.md backend:** `project: Inner Game` works the same way — it's a text convention in the description, not a backend feature. No change needed.

### 8c. Migration Path (Future)

When Inner Game is ready to adopt the abstraction:
1. Read the task-backend skill from CoS (cross-plugin dependency, or duplicate the skill)
2. Replace `gm tasks create --list Home` with generic create operations
3. ~3 files to change, ~5 occurrences

---

## 9. Decisions — All Resolved ✅

### D1: tasks.md Section Names ✅

**Decision: 5-section format matching CoS status names exactly.**

`## Right Now`, `## Active`, `## Waiting On`, `## Someday`, `## Done`. CoS has 5 statuses; the Anthropic plugin has 4. Right Now is important for the briefing command's "today's focus" view.

### D2: Where to Store Backend Config ✅

**Decision: Pinned kbx config note, created as first `/setup` action.**

kbx is installed and functional even when empty. The note gets updated as setup progresses. See section 1c for format.

### D3: tasks.md Location ✅

**Decision: CWD with override.** `TASKS.md` in the working directory by default. User-configurable path stored in the config note. kbx shouldn't index it.

### D4: Calendar References ✅

**Decision: gm-first with MCP fallback. Warn if no calendar available.** Don't mention specific vendors in setup prompts — just detect what's available. If nothing detected, warn the user that calendar features will be limited.

### D5: Skill File Size ✅

**Decision: Single lean skill file (~80 lines).** Generic interface + heuristics in the skill. Backend-specific syntax lives in the CoS Configuration note (~20-30 lines), LLM-generated during `/setup` with syntax for active backends only. This is **Approach B** for context efficiency — avoids loading all backend implementations into every session.

### D6: `/setup` Detection ✅

**Decision: Auto-detect, ask when ambiguous. tasks.md is a first-class option, not just a fallback.** Setup should ask what task systems the user's company uses (Linear, Jira, Notion, etc.) to inform MCP suggestions and commitment routing. If only one backend available → use it and confirm. If multiple → present choice with tasks.md as an equal option.

### D7: Command Language ✅

**Decision: Generic command language + skill reference.** Commands use generic operations ("create a task with status active") and reference "see task-backend skill" for dispatch. No backend-specific syntax in commands.

### D8: Open Items `ref:` Links ✅

**Decision: Include when known, offer to ask user. Agents can follow refs for automated status checking.** When a debrief extracts an item that clearly relates to a Linear issue or Slack thread, include the `ref:`. Agents should be able to follow ref links to check external status (e.g., "is this Linear issue still open?") as part of automated workflows like weekly review or stale-item triage.

---

## 10. Test Plan

CoS is a pure-markdown plugin — no unit tests. But testable contracts exist:

### 10a. tasks.md Format Validation

**Manual test:** Create a `TASKS.md` with the documented format. Verify:
- CoS can parse all sections correctly
- Create/list/update/close operations produce valid markdown
- Dates are parsed correctly for overdue detection
- Project links are preserved through operations
- Moving a task between sections preserves sub-bullets

**Automation opportunity:** A bash script that creates a test `TASKS.md`, runs CoS commands via `claude -p`, and verifies the file was modified correctly. Similar to the existing `auto-meeting-intel.sh` pattern.

### 10b. Backend Detection

**Manual test matrix:**

| Condition | Expected backend |
|-----------|-----------------|
| gm available, no MCP | gm |
| gm available, Linear MCP available | Offer choice, default gm |
| No gm, Linear MCP available | Offer choice, default Linear or tasks.md |
| No gm, no MCP | tasks.md |
| kbx not available | Error, guide installation |

### 10c. Command Migration Smoke Test

For each migrated command, run it once with:
1. gm backend configured → verify existing behaviour unchanged
2. tasks.md backend configured → verify it creates/reads TASKS.md correctly

### 10d. Project Linking

**Test:** Create a project entity in kbx with `task_keywords`. Run a debrief that extracts an action item matching those keywords. Verify:
- The created task includes `project: <Name>` in its description
- The match was word-boundary safe (no false positives)

### 10e. Regression Contract

The following behaviours MUST be preserved after migration:
- Debrief creates tasks with correct status (Active for user items, Waiting-On for others)
- Briefing shows overdue tasks and Right-Now focus items
- Review performs stale task audit
- Todos extracts and cross-references action items
- Decision command creates follow-up tasks
- All commands degrade gracefully when backends are missing

---

## 11. Breaking Changes

### 11a. Impact on Jeremy's Setup

Jeremy uses gm (Morgen) as his task backend. After this migration:

| What | Impact |
|------|--------|
| **Daily workflow** | No change. gm backend produces identical CLI commands. |
| **CoS Configuration note** | New pinned note created (or during next `/setup` refresh). Tiny context increase. |
| **Existing commands** | Behaviour identical when gm is the active backend. |
| **New skill file** | `task-backend/SKILL.md` added to always-on context. ~80 lines — lean by design. Backend-specific syntax is in the config note (already loaded via `kbx context`). |
| **Generic language in commands** | Commands reference "task backend" instead of "gm". Model still produces `gm` commands because the config note says `Task: gm` and includes gm-specific syntax. |

**Risk: Low.** The gm backend mapping is a direct 1:1 translation of existing commands. No logic changes, just indirection.

### 11b. Breaking Changes for Plugin Users

| Change | Who's affected | Mitigation |
|--------|---------------|------------|
| New skill file added | All users | Always-on context, no action needed |
| `/setup` expanded | Users re-running setup | Old config still works; setup detects existing config and offers to update |
| Config note format | N/A (new) | Didn't exist before; no migration needed |
| Generic command language | Users reading command files | Commands still reference "see task-backend skill"; more readable, not less |

**No breaking changes for existing users.** This is additive — the gm backend path produces identical output to the current hardcoded commands.

### 11c. Inner Game Impact

Inner Game continues to use `gm` directly. No impact until Inner Game opts into the abstraction (future work, see section 8).

---

## Appendix A: File-by-File Migration Notes

**High-touch files** (>5 gm occurrences, need careful migration):

| File | Occurrences | Key changes |
|------|-------------|------------|
| `commands/todos.md` | 14 | Task creation, cross-ref, stale audit, deep scan. Calendar refs stay gm-specific (calendar isn't abstracted yet). |
| `agents/action-tracker.md` | 12 | Task creation, audit mode. All `gm tasks list/create` → generic. `--source linear` → "list tasks from ~~project tracker". |
| `skills/operating-rhythm/SKILL.md` | 12 | Calendar + task CLI reference table. Split into calendar (keep gm) and tasks (genericise). |
| `commands/review.md` | 10 | Calendar, tasks (all tags, overdue), stale audit. Task parts genericise; calendar parts stay gm with MCP fallback. |
| `commands/briefing.md` | 9 | Calendar, tasks (Right-Now, overdue, Waiting-On, Active). Add Commitment Inbox section. |
| `skills/meeting-intelligence/SKILL.md` | 8 | Task cross-ref, create, project linking. All generic. |

**Low-touch files** (1-3 gm occurrences, simple find-and-replace):

`commands/blindspots.md`, `commands/culture.md`, `commands/boot-team.md`, `agents/advisor.md`, `CONNECTORS.md`, `skills/chief-of-staff-identity/SKILL.md`

**No-touch files** (docs/plans/ — historical, don't migrate):

`docs/plans/2026-02-24-kbx-gm-integration-design.md`, `docs/plans/2026-02-24-kbx-gm-integration-plan.md`, `docs/plans/2026-02-25-productivity-plugin-merge-design.md`
