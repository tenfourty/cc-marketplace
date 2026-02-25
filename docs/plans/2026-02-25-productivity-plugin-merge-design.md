# Productivity Plugin Merge — Design

**Date:** 2026-02-25
**Context:** Pull valuable features from the `productivity@knowledge-work-plugins` plugin into `chief-of-staff@cc-marketplace`, then remove the productivity plugin.

## Background

The productivity plugin (Anthropic's Cowork plugin) overlaps with chief-of-staff in task management, memory/context, and morning sync workflows. It uses flat files (TASKS.md, CLAUDE.md, memory/) as its storage layer; chief-of-staff uses kbx + gm. Rather than run both, we're absorbing what's valuable and removing the productivity plugin.

## Features to Absorb

Four features accepted after reviewing the productivity plugin:

1. **Interactive bootstrap in `/cos:setup`** — learn the executive's world (people, projects, shorthand) from available data sources
2. **Active shorthand decoding** — always disambiguate names, acronyms, and references against kbx before acting
3. **Stale task triage** — in briefing (light), todos (medium), and review (deep)
4. **Comprehensive missed-todo scan** — `/cos:todos --deep` for on-demand MCP scan; review always does a lighter version

Features explicitly rejected:
- Visual HTML dashboard (separate brief-deck project handles this)
- Connector abstraction with `~~category` placeholders (our CONNECTORS.md approach is sufficient)
- Flat-file memory system (kbx is our memory layer)
- TASKS.md task management (gm is our task layer)

---

## Feature 1: Interactive Bootstrap in `/cos:setup`

### What Changes

New **Step 2.5: Learn Your World** inserted between "Learn the Executive" (Step 2) and "Write to kbx" (Step 3).

### Design

After the interactive conversation about role, people, priorities, and CIRs, probe available data sources to learn the executive's working language.

#### 1. Probe kbx richness

Run:
- `kbx context` (if not already loaded)
- `kbx person find "" --json --limit 20` — how many people exist?
- `kbx project find "" --json --limit 20` — how many projects?
- `kbx note list --limit 10 --json` — how many notes/transcripts?

Classify:
- **Rich** (20+ people, 10+ meetings/notes): scan kbx directly
- **Sparse** (some data but gaps): scan kbx + supplement from MCPs
- **Empty** (no people, no notes): guide sync or scan MCPs

#### 2a. If Rich — Scan kbx

Search for patterns in existing data:
- People who appear frequently across meetings
- Projects and codenames mentioned repeatedly
- Acronyms and internal terminology
- Recurring meeting names and rhythms

Cross-reference against what the executive told you in Step 2. Flag gaps: "You mentioned Sarah but I don't see her in any transcripts — is she new?"

#### 2b. If Sparse/Empty — Guide or Scan

Present the choice:

> Your knowledge base doesn't have much data yet. Two options:
>
> **Option A — Populate first (recommended):**
> If you have Granola meeting transcripts, let's sync them now. Run: `kb sync granola --since 30d` then `kb index run`. I'll wait, then scan what comes in.
>
> **Option B — Quick scan from connected tools:**
> I'll scan your Slack channels, calendar, and Linear directly to learn your world now. Anything I learn gets written back to kbx so it's there for next time.

If Option A: guide through sync, wait, then proceed as "Rich".

If Option B: scan MCPs:
- **Slack**: read key channels, recent DMs, extract people + projects
- **Calendar (gm)**: recent/upcoming events, attendee patterns
- **Linear**: active projects, team members, labels/terminology
- **Granola MCP**: recent transcripts if available

#### 3. Decode shorthand

From whatever data source, extract:
- **People**: full names, nicknames, roles. Flag ambiguities ("I found two Sarahs — Sarah Chen in Platform and Sarah Williams in Design. Want to clarify?")
- **Projects**: names, codenames, current status
- **Acronyms/terms**: internal jargon, abbreviations

Present findings grouped by confidence:
- **Confirmed** (appeared in multiple sources) → write to kbx
- **Likely** (single source, clear context) → confirm with user
- **Unclear** (ambiguous or low-frequency) → ask user

#### 4. Write learned context to kbx

For each confirmed/approved item:
- People: `kbx memory add "[Name] context" --entity "Name"`
- Terms/acronyms: include in a pinned "Workplace Glossary" note (`--tags glossary --pin`)
- Projects: `kbx memory add "[Project] context" --entity "Project"`

### Rationale

The productivity plugin's bootstrap workflow is its best feature — scanning real data to learn workplace language. But it writes to flat files. We do the same thing, landing everything in kbx so it's searchable and persistent. The two-path approach (populate kbx first vs scan MCPs directly) handles the cold-start problem without compromising kbx as the single source of truth.

---

## Feature 2: Active Shorthand Decoding

### What Changes

Two skill files gain new sections:
- `chief-of-staff-identity/SKILL.md` — establishes the "always disambiguate" behaviour
- `information-management/SKILL.md` — provides the lookup mechanics and learning loop

### Design

#### chief-of-staff-identity/SKILL.md — new section after "Behavioural Principles"

```markdown
## Active Disambiguation

Never assume you know who or what the user means. Always verify against kbx before acting on a name, acronym, or project reference.

Rules:
- When the user mentions a person by first name, run `kbx person find "Name"` to check for multiple matches. If ambiguous, ask.
- When you encounter an unfamiliar acronym or term, check `kbx search "TERM" --fast --limit 5` before asking the user.
- When a project or initiative is referenced, verify it against kbx project entities and pinned initiatives.
- Don't rely solely on session startup context — it's a summary. The full picture is in kbx search.
- If you resolve an ambiguity, remember the resolution for the rest of the session. Don't ask twice.
```

#### information-management/SKILL.md — new section after "Cross-Source Correlation"

```markdown
## Entity Resolution

When processing any input (user message, meeting transcript, Slack thread), resolve all entity references before acting.

### Lookup Flow

1. **Session context** (kbx context loaded at startup) — check first
2. **kbx person find / kbx project find** — authoritative lookup
3. **kbx search** — broader search if entity isn't a person/project
4. **Ask the user** — only after exhausting kbx

### Disambiguation

When multiple matches exist:
- Present the options concisely: "Two matches for 'Sarah': Sarah Chen (Platform) or Sarah Williams (Design). Which one?"
- Use meeting context to infer when possible — if the transcript is from a Platform standup, it's probably Sarah Chen
- Once resolved, don't ask again in the same session

### Learning New Terms

When the user uses a term kbx doesn't know:
- Ask what it means
- Write it to kbx: `kbx memory add "Term: [TERM]" --body "[meaning and context]" --tags glossary`
- If the pinned glossary note exists, append to it: `kbx note edit <path> --append "- **[TERM]**: [meaning]"`

### Staleness Check

Entity context can go stale. When referencing a person or project from kbx, note if the last update was >30 days ago and flag it: "My context on [person] is from [date] — worth verifying if things have changed."
```

### Rationale

The productivity plugin's glossary/decoder is powerful but relies on flat-file lookup. In our architecture, kbx already has people and project entities. The gap is that the agent doesn't proactively check for ambiguity — it trusts whatever was loaded at session start. These additions make disambiguation active (identity skill) and teach the mechanics of lookup and learning (information-management skill).

---

## Feature 3: Stale Task Triage

### What Changes

Three commands gain triage capability, scaled by depth:
- `commands/briefing.md` — light (flag counts, gate behind yes/no)
- `commands/todos.md` — medium (full list, interactive cleanup)
- `commands/review.md` — deep (coach voice, strategic pruning)

### Design

#### commands/briefing.md — light triage

In Step 2 (Gather Intelligence), add to Tasks section:
```
- `gm tasks list --tag Active --json` for stale item detection
```

In Step 4 (Present the Briefing), add after "Quick Stats":
```markdown
### Housekeeping
[Only if stale items exist. Skip entirely if task list is clean.]
You have X overdue tasks and Y items tagged Active for 30+ days.
Want to do a quick triage before your day starts?
```

If the user says yes, run an inline mini-triage: present each stale item and offer mark done / reschedule / move to Someday / delete. Staff voice, fast.

#### commands/todos.md — medium triage

New step between Cross-Reference (Step 3) and Present (Step 4), renumbered as appropriate:

```markdown
### Stale Task Audit

After cross-referencing extracted items against gm, scan for stale tasks:

Query:
- `gm tasks list --overdue --json`
- `gm tasks list --tag Active --json` (filter to items older than 30 days by created/updated date)
- `gm tasks list --tag Waiting-On --json` (filter to items waiting >5 business days)

Present after the main action items output:

---

## Stale Items

### Overdue
* **[Task title]** — due [date], [X days ago]

### Stuck (Active 30+ days)
* **[Task title]** — created [date], no recent activity

### Waiting Too Long (>5 business days)
* **[Person]: [Task]** — waiting since [date]

---

For each item, offer:
- ✓ Mark done (already handled)
- → Reschedule (set new due date)
- ↓ Move to Someday (deprioritise)
- ✕ Delete (no longer relevant)
- ⏭ Skip (leave as-is for now)

Process the user's choices via gm tasks commands.
```

#### commands/review.md — deep triage with coach voice

In Step 3 (Synthesise) and Step 4 (Present), modify the "What Didn't Move" section from passive reporting to interactive challenge:

```markdown
### What Didn't Move

[Don't just list stalled items — challenge them with coach voice]

For each stalled task or initiative:
- How long has it been stuck?
- Is this still a priority, or are you avoiding it?
- What would unblock it? Is there a smaller first step?
- Should this be delegated, deferred, or dropped?

Present as an interactive discussion, not a report:

"**[Task/initiative]** has been sitting for [X weeks]. Last activity was [context]. Three possibilities: it's blocked and needs intervention, it's been silently deprioritised, or it's done and nobody closed it. Which is it?"

After the discussion, execute whatever the user decides via gm tasks commands.
```

### Rationale

The productivity plugin triages stale tasks in its `/update` command. We spread it across three touchpoints with increasing depth: briefing is a quick flag, todos is an efficient cleanup, review is a strategic confrontation. The gradient matches the voice and purpose of each command.

---

## Feature 4: Comprehensive Missed-Todo Scan

### What Changes

- `commands/todos.md` gains a `--deep` flag for on-demand full MCP scan
- `commands/review.md` always runs a lighter version checking the executive's own Slack commitments

### Design

#### commands/todos.md — `--deep` flag

Add to frontmatter:
```yaml
args: "[--deep]"
```

New step after the stale task audit:

```markdown
### Deep Scan (--deep flag only)

When the user passes --deep, extend the scan beyond kbx meeting transcripts to all available MCP sources.

#### Slack
- Read recent messages in key channels (last 5 business days)
- Read recent DMs
- Search for commitment language: "I'll", "I will", "can you", "action item", "todo", "by Friday", "follow up", "send"
- Extract: who committed, what, when, which channel/thread

#### Calendar (gm)
- `gm this-week --json --response-format concise --no-frames`
- For each recent meeting, check if there's a corresponding kbx transcript. If not, flag it: "No transcript found for [meeting] — anything come out of that?"

#### Linear (MCP)
- Check for issues assigned to the executive that aren't reflected in gm tasks
- Check for issues where the executive is mentioned in comments but not assigned

#### Granola (MCP, fallback)
- If kbx didn't have transcripts for recent meetings, check Granola for them
- Apply the same extraction logic as the standard todos process

#### Present deep-scan findings separately:

---

## Caught in the Net

Items from Slack, calendar, and project tracker that aren't tracked anywhere:

### From Slack
* **#[channel]** ([date]): "[commitment quote]" — not in your tasks

### Unaccounted Meetings
* **[Meeting name]** ([date]) — no transcript found, no action items captured

### Linear Gaps
* **[Issue title]** — assigned to you, not in gm tasks

---

Ask: "Want me to create tasks for any of these, or were they already handled?"
```

#### commands/review.md — lighter version always runs

In the weekly-review agent's data gathering (Step 2), add to the Chat (Slack MCP) section:

```markdown
**Missed Commitment Detection (always, lightweight):**
- Search Slack for the executive's own commitment language in the past week: "I'll", "I will", "let me", "I'll send"
- Cross-reference against gm tasks created this week
- Surface any commitments that don't have a corresponding task
```

In Step 4 (Present the Review), add a new subsection after "What Didn't Move":

```markdown
### Commitments Not Yet Tracked
[Items the executive said they'd do in Slack/meetings this week that aren't in gm tasks. Only show if any are found — skip the section entirely if clean.]

* **[Channel/meeting]** ([date]): "[quote]" — no matching task
```

### Rationale

The productivity plugin's `--comprehensive` flag is its second-best feature — scanning all channels for dropped commitments. We split it into two modes: `/cos:todos --deep` is thorough and interactive (scans everything, asks about each item); the review version is passive and lightweight (only checks the executive's own Slack commitments, flags them in the report). This avoids making every review take ages while still catching dropped balls.

---

## Files Modified

| File | Change |
|------|--------|
| `commands/setup.md` | New Step 2.5: Learn Your World (bootstrap) |
| `skills/chief-of-staff-identity/SKILL.md` | New section: Active Disambiguation |
| `skills/information-management/SKILL.md` | New section: Entity Resolution |
| `commands/briefing.md` | Light triage in Housekeeping section |
| `commands/todos.md` | Stale task audit + `--deep` flag for MCP scan |
| `commands/review.md` | Interactive triage in "What Didn't Move" + missed commitment detection |

## Files Not Modified

- Agents, CONNECTORS.md, other commands — no changes needed
- No new files created (all changes are additions to existing files)
