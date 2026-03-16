---
description: First-run personalisation for your AI Chief of Staff. Learns your role, team, priorities, and critical information requirements.
user_invocable: true
---

# Chief of Staff Setup

You are running the initial setup for the Chief of Staff plugin. Your goal is to learn enough about this executive to be an effective Chief of Staff from day one.

## Step 1: Detect Available Backends

### 1a. kbx (REQUIRED)

Run `kbx --help` if not already in context. If missing:

```
kbx is required for the Chief of Staff plugin. It's the knowledge backbone
that stores your meetings, people, projects, decisions, and context.

Install it:
  uv tool install "kbx[search]"    # Standard install
  uv tool install --editable ./kbx  # Dev mode (if you have the source)

Then run /cos:setup again.
```

**Stop here if kbx is not available.** Nothing else works without it.

Check for existing pinned notes:
- Run `kbx context` if not already in context — shows any existing pinned docs (CIRs, initiatives, cadence, recurring meetings)
- If pinned docs already exist from a previous setup, offer to update them using `kbx note edit <path> --body "..."` rather than creating new notes.

### 1b. Detect task, calendar, and communication backends

Probe silently:
- `gm --help` — note if gm is available (provides both tasks and calendar)
- Check for project tracker MCP (Linear, Jira, etc.) — note availability
- Check for calendar MCP (Google Calendar) — note availability
- Check for chat MCP (Slack, etc.) — note availability
- Check for email MCP (Gmail, etc.) — note availability
- Check for messaging MCP (Beeper, etc.) — note availability for personal messaging

### 1c. Ask about the user's tooling

Ask: "What task/project management systems does your company use? (e.g., Linear, Jira, Notion, Todoist, Asana)" — this informs which MCPs to suggest connecting and how to route commitments.

### 1d. Present task backend choice

Based on detection results:

- **If only one option available** (e.g., no gm, no project tracker MCP): use it and confirm.
  - "I'll manage your tasks in a simple TASKS.md file — zero dependencies, editable anywhere."
- **If multiple options available**: present the choice with tasks.md as a first-class option:
  - "(a) **tasks.md** — a simple markdown file, zero dependencies, works everywhere"
  - "(b) **Morgen** — full calendar + task integration via gm" (if detected)
  - "(c) **[detected tracker]** — sync with your existing project tracker" (if MCP available)
  - "Which would you prefer?"

### 1e. Calendar and source availability

- If no calendar backend detected, warn: "No calendar connection found. Calendar features (briefing schedule, time analysis) will be limited. You can connect one later."
- Note which chat/email/project tracker MCPs are available for commitment scanning.
- Do not mention specific vendor names in prompts — just categories.
- **Suggest missing sources:** For each category that has no connected MCP, suggest the user connect one. Frame as value-add, not requirement:
  - No chat: "Connecting a chat source (e.g., Slack) enables commitment scanning and team signal detection."
  - No email: "Connecting email enables tracking external commitments and follow-ups."
  - No messaging: "Connecting a personal messaging source (e.g., Beeper) enables inbox sweep across WhatsApp, Signal, Telegram, and other messaging apps."
  - No project tracker: "Connecting a project tracker enables initiative status in briefings."
  - No calendar: "Connecting a calendar enables time analysis and scheduling."

### 1f. Store configuration

Create a pinned kbx config note tagged `config` with backend-specific syntax for the active backends **and a connected sources inventory**. The note is LLM-generated — include the exact CLI commands or file operations for the chosen task backend. See the task-backend skill for the expected structure.

```bash
kbx memory add "CoS Configuration" --body "..." --tags config --pin
```

The config note MUST include a `## Connected Sources` section listing what's available. This is how all commands know which sections to run and which to skip. Example:

```markdown
## Connected Sources
- task: gm (Morgen CLI)
- calendar: gm (Morgen CLI)
- messaging: Beeper (claude.ai MCP)
- chat: Slack (claude.ai MCP)
- email: Gmail (claude.ai MCP)
- project tracker: Linear (claude.ai MCP)
- knowledge base: Notion (claude.ai MCP)

## Task Syntax (gm)
- Create: `gm tasks create --title "..." --tag {Status} --list {Area} --due {ISO} --description "..."`
...
```

Sources not connected are omitted from the list. Commands check this list and skip sections for missing categories.

## Step 2: Learn the Executive

Have an interactive conversation to learn:

### Role and Context
- What is your title and role? (Default assumption: CTO / technology executive)
- What kind of organisation? (startup, scale-up, enterprise, etc.)
- How large is your team? (direct reports, total org)
- What's the company's current stage/focus? (growth, profitability, transformation, etc.)

### Key People
- Who are your direct reports? (names, roles, what they own)
- Who are your key peers? (CEO, CPO, CFO, etc.)
- Who are your most important external stakeholders? (board members, key customers, partners)
- Are there any people you interact with frequently who go by nicknames or shorthand?

### Current Priorities
Run a lightweight "Stop, Start, Continue" exercise:
- What are you currently spending time on that you should STOP or delegate?
- What should you START paying more attention to?
- What's working well that you should CONTINUE?

### Critical Information Requirements (CIRs)
Based on the McChrystal Group framework, establish what information the executive needs:
- What events or thresholds require IMMEDIATE notification? (e.g., production outage, key person leaving, major customer escalation)
- What should be surfaced in your DAILY briefing? (e.g., calendar conflicts, overdue action items, key chat threads)
- What belongs in a WEEKLY review? (e.g., initiative progress, team health signals, decision backlog)

### Operating Rhythm
- What recurring meetings do you have? (daily standup, 1:1s, staff meeting, all-hands, board prep)
- What does your ideal week structure look like?
- When do you prefer to receive briefings? (morning, evening, ad-hoc)
- What tools do you use most? (helps prioritise which integrations to lean on)

## Step 2.5: Learn Your World

After the interactive conversation, probe available data sources to learn the executive's working language — people, projects, acronyms, and shorthand.

### 1. Probe kbx Richness

Run:
- `kbx context` (if not already loaded)
- `kbx person find "" --json --limit 20` — how many people exist?
- `kbx project find "" --json --limit 20` — how many projects?
- `kbx note list --limit 10 --json` — how many notes/transcripts?

Classify:
- **Rich** (20+ people, 10+ meetings/notes): scan kbx directly
- **Sparse** (some data but gaps): scan kbx + supplement from MCPs
- **Empty** (no people, no notes): guide sync or scan MCPs

### 2a. If Rich — Scan kbx

Search for patterns in existing data:
- People who appear frequently across meetings
- Projects and codenames mentioned repeatedly
- Acronyms and internal terminology
- Recurring meeting names and rhythms

Cross-reference against what the executive told you in Step 2. Flag gaps: "You mentioned Sarah but I don't see her in any transcripts — is she new?"

### 2b. If Sparse/Empty — Guide or Scan

Present the choice:

> Your knowledge base doesn't have much data yet. Two options:
>
> **Option A — Populate first (recommended):**
> If you have Granola meeting transcripts, let's sync them now. Run: `kbx sync granola --since 30d` then `kbx index run`. I'll wait, then scan what comes in.
>
> **Option B — Quick scan from connected tools:**
> I'll scan your chat channels, calendar, and project tracker directly to learn your world now. Anything I learn gets written back to kbx so it's there for next time.

If Option A: guide through sync, wait, then proceed as "Rich".

If Option B: scan MCPs:
- **Chat**: read key channels, recent DMs, extract people + projects
- **Email**: recent sent/received, extract contacts, recurring correspondents, and terminology
- **Calendar**: recent/upcoming events, attendee patterns
- **Project tracker**: active projects, team members, labels/terminology
- **Granola MCP**: recent transcripts if available

### 3. Decode Shorthand

From whatever data source, extract:
- **People**: full names, nicknames, roles. Flag ambiguities ("I found two Sarahs — Sarah Chen in Platform and Sarah Williams in Design. Want to clarify?")
- **Projects**: names, codenames, current status
- **Acronyms/terms**: internal jargon, abbreviations

Present findings grouped by confidence:
- **Confirmed** (appeared in multiple sources) → write to kbx
- **Likely** (single source, clear context) → confirm with user
- **Unclear** (ambiguous or low-frequency) → ask user

### 4. Write Learned Context to kbx

For each confirmed/approved item:
- People: `kbx memory add "[Name] context" --entity "Name"`
- Terms/acronyms: include in a pinned "Workplace Glossary" note (`--tags glossary --pin`)
- Projects: `kbx memory add "[Project] context" --entity "Project"`

## Step 2.7: Import Existing Tasks

Ask: "Do you have an existing task list you'd like to import? This could be:"
- A file (todo.txt, TASKS.md, task list in a doc)
- An app (Linear, Asana, Jira, Notion, Todoist) — if the MCP is connected
- Or start fresh

**If file:** Read it, decode shorthand, create kbx entities for people/projects mentioned. Import tasks into the active backend.
**If app:** Sync via connected MCP, decode, create entities. Import key tasks.
**If fresh:** Skip. Tasks will be created naturally through debriefs and todos.

For the tasks.md backend: import creates the initial TASKS.md from the `templates/TASKS.md` template and populates it.
For the gm backend: import creates gm tasks via CLI.

## Step 3: Write to kbx

Based on the conversation, create or update pinned kbx notes:

### Critical Information Requirements
```bash
kbx memory add "Critical Information Requirements" --body "structured CIRs markdown" --tags cir --pin
```

Content format:
```markdown
# Critical Information Requirements

Last updated: [date]

## Immediate (notify as soon as detected)
- [items from conversation]

## Daily (include in morning briefing)
- [items from conversation]

## Weekly (include in weekly review)
- [items from conversation]
```

### Active Strategic Initiatives
```bash
kbx memory add "Active Strategic Initiatives" --body "initiatives markdown" --tags initiative --pin
```

Content format:
```markdown
# Active Strategic Initiatives

Last updated: [date]

## [Initiative Name]
- **Owner:** [name]
- **Status:** [on-track/at-risk/blocked]
- **Key metrics:** [what to track]
- **Next milestone:** [what and when]
```

### Recurring Meetings
```bash
kbx memory add "Recurring Meetings" --body "meetings markdown" --tags meetings --pin
```

Content format:
```markdown
# Recurring Meetings

## [Meeting Name]
- **Cadence:** [daily/weekly/biweekly/monthly]
- **Day/Time:** [when]
- **Attendees:** [who]
- **Purpose:** [what gets discussed]
- **Prep needed:** [what to prepare]
- **[Any additional fields]:** Special instructions for prep/debrief — e.g., a Notion DB to check for shared meeting notes, a Slack channel to scan, a Google Doc with standing agenda. The prep and debrief commands read every field in this entry and follow any instructions they find.
```

Ask the user if any of their recurring meetings have shared notes or agendas in external tools (Notion, Google Docs, Slack channels, etc.). If so, add those as additional fields — the prep and debrief commands will automatically check them.

### Operating Rhythm
```bash
kbx memory add "Operating Rhythm" --body "cadence markdown" --tags cadence --pin
```

Content format:
```markdown
# Operating Rhythm

## Daily
- [morning briefing time and format]
- [end-of-day reconciliation preferences]

## Weekly
- [review day/time]
- [what the weekly review should cover]

## Monthly
- [any monthly rhythms]
```

## Step 3.5: Create Task Areas

Configure the areas of focus for the active backend:

- **Default areas:** Inbox, Leadership, People, Ops, Admin, Home, Routines
- Ask: "These are the default focus areas. Want to customise them?"
- For gm backend: `gm lists list --json` to check existing lists, `gm lists create` for missing ones
- For tasks.md backend: areas are metadata tags in parentheses — no setup action needed, just record the list in the config note
- Store the final area list in the CoS Configuration note

### People Context
For each key person mentioned:
```bash
kbx memory add "[Name] context" --entity "Name" --tags people
```

Include: full name, role/title, relationship to the executive, what they own, communication preferences, relevant context.

## Step 4: Confirm and Orient

Summarise what you've learned back to the executive. Confirm:
- "Here's what I understand about your priorities..."
- "Here's how I'll filter information for you..."
- "Your task backend is [tasks.md / gm / etc.], calendar is [gm / Google Calendar MCP / none], and I can scan [chat / email / project tracker] for commitments."
- "Here are the commands available to you: /briefing, /prep, /debrief, /review, /status, /decision, /todos, /coach, /blindspots, /codify, /culture, /supergoal"
- "I'll operate in staff voice for daily operations and coach voice for weekly reviews and strategic planning."

Ask if anything needs adjusting.

## Step 5: Suggest Next Actions

Based on what you've learned:
- Suggest running `/briefing` to test the daily briefing
- If there's an upcoming meeting, suggest `/prep [meeting name]`
- If it's Friday, suggest `/review` for a weekly review
- Offer to do a quick scan of chat MCP to bootstrap communication context
