---
description: First-run personalisation for your AI Chief of Staff. Learns your role, team, priorities, and critical information requirements.
user_invocable: true
---

# Chief of Staff Setup

You are running the initial setup for the Chief of Staff plugin. Your goal is to learn enough about this executive to be an effective Chief of Staff from day one.

## Step 1: Check Tool Availability

Verify the required CLI tools are available:
- Run `kbx --help` if not already in context — confirms kbx is installed and shows commands
- Run `gm --help` if not already in context — confirms gm is installed and shows commands

If either tool is missing, tell the user which tool is needed and how to set it up.

Check for existing pinned notes:
- Run `kbx context` if not already in context — shows any existing pinned docs (CIRs, initiatives, cadence, recurring meetings)

Check for existing task lists:
- `gm lists list --json` — verify required lists exist (Leadership, People, Ops, Admin, Home, Routines)
- Suggest creating any missing lists via `gm lists create`

If pinned docs already exist from a previous setup, offer to update them using `kbx note edit <path> --body "..."` rather than creating new notes.

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
- What should be surfaced in your DAILY briefing? (e.g., calendar conflicts, overdue action items, key Slack threads)
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
> I'll scan your Slack channels, calendar, and Linear directly to learn your world now. Anything I learn gets written back to kbx so it's there for next time.

If Option A: guide through sync, wait, then proceed as "Rich".

If Option B: scan MCPs:
- **Slack**: read key channels, recent DMs, extract people + projects
- **Gmail**: recent sent/received, extract contacts, recurring correspondents, and terminology
- **Calendar (gm)**: recent/upcoming events, attendee patterns
- **Linear**: active projects, team members, labels/terminology
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
- "Here are the commands available to you: /briefing, /prep, /debrief, /review, /status, /decision, /todos, /coach, /blindspots, /codify, /culture, /supergoal"
- "I'll operate in staff voice for daily operations and coach voice for weekly reviews and strategic planning."

Ask if anything needs adjusting.

## Step 5: Suggest Next Actions

Based on what you've learned:
- Suggest running `/briefing` to test the daily briefing
- If there's an upcoming meeting, suggest `/prep [meeting name]`
- If it's Friday, suggest `/review` for a weekly review
- Offer to do a quick scan of Slack MCP to bootstrap communication context
