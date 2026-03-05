---
description: Post-meeting debrief. Extracts action items, decisions, and follow-ups from the latest meeting transcript.
user_invocable: true
args: meeting
---

# Meeting Debrief

You are extracting structured intelligence from a meeting that just happened. Use the **staff voice**: precise, thorough, action-oriented.

**Input:** The user may provide a meeting name/time, or say "my last meeting" or just "/debrief". If no argument, find the most recent meeting transcript.

## Process

### 1. Find the Transcript

Use `kbx search "meeting title" --fast --json --limit 5` to find the most recent or specified meeting. Use `kbx view <path> --plain` to read each file.

**Read all available sources for the meeting:**
- **Transcript** (`.transcript.md`) — **always read this.** It is the ground truth for action items, decisions, and exact quotes.
- **Notes** (`.notes.md`) — read when available. Shows what the user flagged as important during the meeting. May surface items the user was already tracking mentally.
- **AI Summary** (`.ai-summary.md`) — read when available. Useful as a cross-check, but do not extract action items or decisions solely from AI summaries — they may miss or misattribute commitments.

Use all three to build the fullest picture: the transcript is the primary extraction source, notes highlight user intent, and the AI summary can catch things you might skim past in a long transcript.

**Fallback — live Granola API:** If local files aren't found (sync hasn't run yet), fall back to `kbx granola view <calendar_uid> --all` to fetch notes, AI summary, and transcript directly from the Granola API. Get the `calendar_uid` from `gm today` output.

If no transcript is available from any source, ask the user to provide a summary of what happened (they can paste notes, or just talk through it).

### 1b. Check for Existing Debrief

Construct the debrief file path from the identified meeting:

1. Get `calendar_uid` and meeting date — either from `gm today` output or from the transcript's frontmatter
2. `uid_prefix` = first 8 characters of `calendar_uid`
3. Date directory: `memory/meetings/YYYY/MM/DD/` (from meeting date)
4. Look for existing meeting files to reuse the established naming prefix:
   ```bash
   ls memory/meetings/YYYY/MM/DD/{uid_prefix}_* 2>/dev/null
   ```
5. If existing files found (transcripts, notes), extract the base name (everything before the first `.`) — this gives the established `{uid_prefix}_{Title}` prefix
6. If no existing files, sanitise the meeting title for a filename (replace spaces/special chars with hyphens, lowercase)
7. Debrief file path: `memory/meetings/YYYY/MM/DD/{base_name}.debrief.md`

**If a debrief file already exists:**

1. Read it with `kbx view <path> --plain`
2. Check the frontmatter `source` field. If `source: cos-agent-unattended`, note to the user: "This debrief was auto-generated and hasn't had tasks extracted yet."
3. Display to the user: "Found existing debrief for this meeting:"
4. Present the existing content
5. Ask: "Want to **(a) review this as-is**, **(b) update with new information**, **(c) regenerate from scratch**, or **(d) extract tasks and update systems**?"
   - **(a)** — Skip to Step 7 (next steps)
   - **(b)** — Continue the normal debrief process (Steps 2–4) using the existing debrief as reference. Save the updated version, overwriting the file
   - **(c)** — Continue the normal debrief process (Steps 2–4) from scratch. Save, overwriting the file
   - **(d)** — Use the existing debrief content as-is. Also re-read the transcript (Step 1 sources) to catch entity signals the summary may have compressed. Then jump directly to Step 5 (Entity Change Detection) and Step 6 (Update Systems) — create gm tasks, log decisions, update people context. Skip Steps 2–4b.
   - If `source: cos-agent-unattended`, recommend option **(d)** since tasks and entity updates weren't created during unattended generation.

**If no debrief file exists:** Continue to Step 2.

### 1c. Apply Recurring Meeting Instructions

If this is a recurring meeting, **read the full recurring meetings doc** if not already in context. Find its path from `kbx context` output (it's a pinned doc titled "Recurring Meetings"), then:

```bash
kbx view <path-from-kbx-context> --plain
```

Find the section for this meeting and read every field. Beyond the standard fields (Cadence, Attendees, Purpose, Prep needed), the entry may contain **additional fields with special instructions** — e.g., external data sources to check, Notion databases to fetch, Slack channels to scan, or any other meeting-specific context.

**Follow all instructions in the entry.** Treat each additional field as a directive. Examples of what you might find:
- A Notion DB to search for this week's meeting notes (fetch the page matching the meeting date and cross-reference with the transcript — catch items that were listed but not discussed)
- A Slack channel to check for post-meeting discussion or follow-ups
- A Google Doc with shared action items to reconcile against

If an instruction references an external source and no matching content is found for this occurrence, skip silently — the transcript is sufficient for debrief.

### 2. Extract Structured Data

From the transcript, extract:

**Action Items (Two-Tier):**

*Explicit (To Do):* Direct commitments with clear ownership:
- WHO committed to doing WHAT by WHEN
- "I'll send the draft by Friday" / "Can you review this?" / "[Name] to handle X"
- Include both the executive's own commitments and others' commitments

*Inferred:* Implicit commitments where the executive is likely responsible:
- "We should update the docs" (where context suggests executive ownership)
- Group suggestions the executive implicitly agreed to
- Tag these as *(inferred)* in the output

An action item is a **future commitment** — not a status update. "I am doing X" (current work) is NOT an action item. "I will do X" (new commitment) IS.

- Flag any items that are vague ("I'll look into it") and ask for clarification

**Decisions Made:**
- WHAT was decided, by WHOM, with what RATIONALE
- Note any dissent or conditions attached to the decision
- Note what alternatives were considered (if mentioned)

**Follow-ups Needed:**
- Items that need to be followed up on but aren't clear action items
- "We should circle back on X" type items
- Requests for information that need to be gathered

**Key Information:**
- New facts or context that should be remembered
- Updates to project status, timelines, or scope
- Changes to people's roles, responsibilities, or availability
- Anything that matches CIR criteria (from kbx context pinned CIRs doc)

**Commitments from Others:**
- What other people promised to do
- When they said they'd have it done
- These become "Waiting-On" tagged tasks

### 3. Cross-Reference

Check extracted items against:
- `gm tasks list --json --response-format concise` — are any of these already tracked? Update status if so
- `kbx note list --tag decision --json` — does this decision relate to or supersede previous decisions?
- kbx context pinned docs — do any items affect active initiatives?
- `kbx person find "Name"` — any new context about people that should be captured?

### 4. Present the Debrief

```
## Meeting Debrief — [Meeting Title]
**Date:** [date and time]
**Attendees:** [who was there]

### Action Items (You)
[Numbered list of the executive's own commitments]
1. [Action] — due [date/timeframe]

### Action Items (Others)
[Numbered list of others' commitments → these become Waiting-On items]
1. [Person]: [Action] — due [date/timeframe]

### Decisions Made
[Each decision with brief context]
- **[Decision]** — [rationale, if stated]. [Any conditions or caveats.]

### Follow-ups
[Items that need tracking but aren't concrete action items yet]

### Notable Context
[New information worth remembering — will be added to kbx]
```

### 4b. Save Debrief File

Write the debrief to a markdown file alongside the meeting's other artifacts (transcripts, notes). Use the file path constructed in Step 1b.

**Frontmatter:**
```yaml
---
title: 'Debrief: [Meeting Title]'
date: '[meeting date YYYY-MM-DD]'
type: debrief
source: cos-agent
calendar_uid: '[full calendar_uid from gm event or transcript frontmatter]'
attendees:
- name: [Attendee Name]
  email: [attendee@example.com]
---
```

**Body:** The full debrief from Step 4 (starting from `## Meeting Debrief — [Title]`).

**Write the file** using the Write tool or bash heredoc. Create the date directory if it doesn't exist (`mkdir -p`).

Confirm to the user: "Debrief saved to `[file path]` — it'll be indexed by kbx on next search."

### 5. Entity Change Detection

For each meeting attendee, check if their profile needs updating:

1. Look up their current profile: `kbx person find "Name" --json`
2. Scan the transcript for signals that someone's profile may have changed:
   - Role/title changes ("is now leading...", "moved to the X team", "promoted to...")
   - Reporting line changes ("reports to Y now", "joining Z's team")
   - Responsibility shifts ("taking over...", "handing off...", "no longer owns...")
   - Departures/arrivals ("last day is...", "new hire starting...", "leaving the company")
3. If a change is detected and you're confident:
   - Edit directly: `kbx person edit "Name" --role "New Role"` (or `--team`, `--meta "key=value"`)
   - Add a dated fact: `kbx memory add "change description" --entity "Name"`
   - Report what you changed in the debrief output under "Notable Context"
4. If ambiguous, note it in the debrief output for the user to verify

### 6. Update Systems

**Ask permission before updating**, then:

**Route each item using this decision table:**

| Condition | Destination | How |
|-----------|-------------|-----|
| User is personally accountable | Morgen task (Active or Right-Now) | `gm tasks create --title "..." --tag Active --list LIST --due ISO --description "..."` |
| User needs to follow up on someone else's commitment (will be asked about it) | Morgen task (Waiting-On) | `gm tasks create --title "..." --tag Waiting-On --list LIST --description "..."` |
| Someone else owns it on a steered project | Open Items on the **project** entity file | `kbx note edit <project-entity-path> --append "- [YYYY-MM-DD] Description (from: Meeting Title)"` — prepend to the `## Open Items` section (create it if it doesn't exist) |
| Someone in a 1:1 owns it | Open Items on the **person** entity file | `kbx note edit <person-entity-path> --append "- [YYYY-MM-DD] Description (from: Meeting Title)"` — prepend to the `## Open Items` section (create it if it doesn't exist) |
| General follow-up, no clear personal accountability | Open Items on the most relevant entity (person or project) | Same format as above |

**Open Items format:** `- [YYYY-MM-DD] Description (from: Meeting Title)` — always prepend new items to the top of the `## Open Items` section so the most recent items appear first. If the entity file has no `## Open Items` section yet, create one at the end of the file.

**Project linking (for Morgen tasks):** If a task relates to a known kbx project, include `project: <ProjectName>` on a line in the `--description` (e.g., `--description "project: CoreLogic Migration\nFollow up on migration timeline"`). Multiple `project:` lines supported.

- Update any existing tasks that were discussed

**Decisions (kbx):**
- `kbx memory add "Decision Title" --body "structured markdown" --tags decision` for each decision made
- If person-related, also `--entity "Name"`

**People context (kbx):**
- `kbx memory add "context" --entity "Name"` for new context about attendees

### 7. Offer Next Steps

Present a follow-on menu based on what's relevant to this meeting:

**Always offer:**
- "Should I create Linear issues for any of these?" (via Linear MCP)
- "Any of these items need to be added to a specific initiative?"

**Offer contextually:**

- **Write a tldr** — Offer when the meeting had external attendees or cross-team relevance ("Want a tldr to share with the team?"). Format: Three sentences. First: "Met with [person/company] to discuss [topic]." Then two bullet points with key outcomes. Designed to be pasted into Slack immediately.

- **Draft a follow-up email** — Offer when there are action items involving external parties or when commitments need confirming. Write a short, casual, action-oriented email. If the executive promised something quick (<5 mins like finding a document), assume it's done and use placeholders (e.g., "[Insert link to DPA]"). If others promised something important, nudge them toward a deadline ("When do you think you'll have X ready?"). Use `[Insert X]` for any missing info. Don't quote the transcript.

- **Schedule a follow-up meeting** — Offer when the discussion clearly needs continuation or a check-in was mentioned. Suggest what follow-up makes sense and a rough timeframe. Check free slots via `gm`. Create the event via `gm` if confirmed.

- **Examine what wasn't asked** — Offer for substantive meetings (strategy sessions, planning, decision-making meetings). Ask: "What questions are you surprised weren't covered? What questions should you have been asking? What would have cut deeper into the topic? If you had 15 more minutes, what would be most incisive to tackle?"

- **Run a deeper risk analysis** — Offer for meetings involving plans, proposals, or significant decisions. "Want me to run a blind spots analysis on what was discussed?" This triggers `/cos:blindspots` in post-meeting mode.

## When No Transcript is Available

If the user runs /debrief but there's no transcript:
1. Ask "What meeting did you just come out of?"
2. Ask "What were the key outcomes?"
3. Prompt for: "Any action items for you? For others? Any decisions made?"
4. Process whatever they provide through the same extraction and filing pipeline
