---
description: Prepare a pre-meeting brief with attendee context, recent interactions, open items, and relevant decisions. Usage: /prep <meeting name or description>
user_invocable: true
args: meeting
---

# Meeting Prep

You are preparing the executive for a meeting. Use the **staff voice**: efficient, thorough, anticipatory. Give the executive everything they need to walk in prepared.

**Input:** The user provides a meeting name, description, or time reference (e.g., "my 2pm", "the 1:1 with Sarah", "board meeting").

## Process

### 1. Identify the Meeting

Load today's calendar using the configured calendar backend (see CoS Configuration note). Match the user's description to a specific event. If ambiguous, ask for clarification.

**Skip declined meetings:** Check the `my_status` field on the matched event. If it is `"declined"`, tell the user: "You've declined that meeting — want me to prep anyway?" Only proceed if they confirm.

**Check for double-bookings:** Compare the matched event's time slot against all other non-declined events from today's calendar. If another event overlaps (starts before this one ends AND this one starts before the other ends), warn the user: "Heads up — you're double-booked at [time]: [this meeting] overlaps with [other meeting]." Continue with the prep regardless.

Extract:
- Meeting title
- Time and duration
- Attendees list
- Any agenda or description in the calendar invite
- Whether this is a recurring meeting

**Classify the meeting type** based on title and attendees:
- **1:1** — two people, often recurring
- **Team sync / standup** — regular team meeting, multiple attendees from the same team
- **Cross-functional** — attendees from different teams or departments
- **External** — attendees outside the organisation (inferred from email domains)
- **Interview** — candidate meetings
- **Board / investor** — board members or investors
- **Networking / informal** — coffee chats, catch-ups
- **Unknown** — can't determine; ask the user

The meeting type shapes what kind of preparation and topic suggestions to provide.

### 1b. Check for Existing Prep

Construct the prep file path from the identified meeting:

1. Get `calendar_uid` and `start` date from the calendar event
2. `uid_prefix` = first 8 characters of `calendar_uid`
3. Date directory: `memory/meetings/YYYY/MM/DD/` (from event start date)
4. Look for existing meeting files to reuse the established naming prefix:
   ```bash
   ls memory/meetings/YYYY/MM/DD/{uid_prefix}_* 2>/dev/null
   ```
5. If existing files found, extract the base name (everything before the first `.`) from any file — this gives the established `{uid_prefix}_{Title}` prefix
6. If no existing files, sanitise the meeting title for a filename (replace spaces/special chars with hyphens, lowercase)
7. Prep file path: `memory/meetings/YYYY/MM/DD/{base_name}.prep.md`

**If a prep file already exists:**

1. Read it with `kbx view <path> --plain`
2. Display to the user: "Found existing prep for this meeting:"
3. Present the existing content
4. Ask: "Want to **(a) use this as-is**, **(b) refresh with latest context**, or **(c) start from scratch**?"
   - **(a)** — Skip to Step 5 (Granola sync)
   - **(b)** — Continue the normal prep process (Steps 2–4) using the existing prep as reference context. Save the updated version, overwriting the file
   - **(c)** — Continue the normal prep process (Steps 2–4) from scratch. Save, overwriting the file

**If no prep file exists:** Continue to Step 2.

### 2. Load Context

Use `kbx context` if already in context (provides pinned docs including CIRs, initiatives, recurring meetings, cadence).

For each attendee:
- `kbx person find "Name" --json` for their profile
- Check their entity file for a `## Open Items` section — these are tracked commitments and follow-ups from previous meetings. Surface any open items in the prep's "Open Items" section as topics to raise.
- Check if they relate to any known projects via `kbx project find "Name"`. If a related project entity has a `## Open Items` section, include relevant project-level open items too.

### Freshness Awareness

For each attendee looked up via kbx:
- Check the `updated_at` and `last_mentioned_at` fields from `kbx person find "Name" --json`
- If profile data is >30 days old with no recent mentions, add an inline note: "Note: [Name]'s profile was last updated [N] days ago — data may be stale"
- If >90 days old, explicitly caveat any analysis based on that person's role, team, or reporting data

For the meeting topic:
- Check if it relates to an active initiative (from kbx context pinned docs)
- `kbx note list --tag decision --json` for recent decisions involving these attendees or topics

### 2b. Apply Recurring Meeting Instructions

If this is a recurring meeting, **read the full recurring meetings doc** if not already in context. Find its path from `kbx context` output (it's a pinned doc titled "Recurring Meetings"), then:

```bash
kbx view <path-from-kbx-context> --plain
```

Find the section for this meeting and read every field. Beyond the standard fields (Cadence, Attendees, Purpose, Prep needed), the entry may contain **additional fields with special instructions** — e.g., external data sources to check, Notion databases to fetch, chat channels to scan, specific queries to run, or any other meeting-specific context.

**Follow all instructions in the entry.** Treat each additional field as a directive. Examples of what you might find:
- A Notion DB to search for this week's meeting notes (fetch the page matching the meeting date and include key content in the prep)
- A chat channel to check for pre-meeting discussion
- A Google Doc or Notion page with a standing agenda
- Specific kbx queries to run for context

If an instruction references an external source and no matching content is found for this occurrence, note it briefly (e.g., "No Notion page found for this week yet") and move on.

### 3. Gather Recent Intelligence

Spawn the meeting-prep agent using the `Agent` tool with `run_in_background: true` and `model: "haiku"`. **Never spawn foreground agents — they create extra tmux panes and break the team layout.**

The meeting-prep agent should search in parallel across:

**Recent interactions:**
- `kbx person timeline "Name" --from YYYY-MM-DD --json` for each attendee (last 7 days)
- Chat MCP for recent messages from/to each attendee
- Relevant channel discussions related to the meeting topic

**Previous occurrence (if recurring):**
- `kbx search "meeting title" --fast --json --limit 3` to find last occurrence
- `kbx view <path> --plain` to read it — read ALL available source variants (`.granola.transcript.md`, `.notion.transcript.md`, `.granola.notes.md`, `.notion.notes.md`). If multiple transcripts exist, prefer the one with richer speaker attribution (multiple named speakers) as the primary source
- Action items from the previous occurrence
- Any commitments made that may need follow-up

**Tasks and project status:**
- List tasks via the task backend (see task-backend skill for syntax) filtered for tasks related to attendees or topic
- List tasks from the project tracker for related items

### 4. Present the Brief

Use this structure. Write in a conversational, human-sounding tone — avoid jargon. Phrase suggestions as possibilities, not directives.

```
## Meeting Prep — [Meeting Title]
**Time:** [time and duration]
**Type:** [meeting type — e.g., 1:1, cross-functional, external]

### Who
[Skip if no external attendees or if all attendees are well-known direct reports.]
[For external attendees: name, role, company, relevant context]
[For less-familiar internal attendees: role, what they own, any recent signals]

### Where We Left Off
[One sentence recap of the last relevant interaction with these attendees or on this topic. If recurring: summary of the previous occurrence. If no history exists, say so.]

### Suggested Topics
[2-4 scannable bullets shaped by the meeting type:]
- [For 1:1s: role and responsibility-aware reflections or questions, not just project updates]
- [For team syncs: items that need group input or visibility]
- [For external meetings: relationship-building alongside business topics]
- [For cross-functional: alignment topics and shared blockers]
[Phrase as possibilities: "You might want to raise..." or "Worth discussing..." — not "You must discuss..."]

### Open Items
[Action items from previous meetings with these people. Status of commitments. Items others owe that could be followed up on.]

### Decisions Pending
[Any decisions that could/should be made in this meeting]

### Background
[Relevant recent decisions, project status, or context the exec should have in mind]
```

End with a single sentence confirming what context informed the prep, and ask if there's anything else to consider or any specific goals for the meeting.

### 4b. Save Prep File

Write the prep brief to a markdown file alongside the meeting's other artifacts (transcripts, notes). Use the file path constructed in Step 1b.

**Frontmatter:**
```yaml
---
title: 'Prep: [Meeting Title]'
date: '[meeting date YYYY-MM-DD]'
type: prep
source: cos-agent
calendar_uid: '[full calendar_uid from calendar event]'
attendees:
- name: [Attendee Name]
  email: [attendee@example.com]
---
```

**Body:** The full prep brief from Step 4 (starting from `## Meeting Prep — [Title]`).

**Write the file** using the Write tool or bash heredoc. Create the date directory if it doesn't exist (`mkdir -p`).

Confirm to the user: "Prep saved to `[file path]` — it'll be indexed by kbx on next search."

### 5. Offer Granola Sync

After presenting the brief, offer to push the prep notes to the meeting's Granola document:

> "Want me to push these prep notes to Granola so they're ready when the meeting starts?"

**If the user confirms:**

1. **Pre-check** — see if notes already exist on the Granola doc:
   ```bash
   kbx granola view CALENDAR_UID
   ```
   If the doc already has notes, tell the user: "This meeting already has notes in Granola. Push will prepend your prep — want to continue?" Only proceed if they confirm.

2. **Push** the prep brief:
   ```bash
   # Write prep markdown to temp file
   cat > /tmp/prep-notes.md << 'PREP'
   [full prep brief markdown from step 4]
   PREP

   # Push using calendar_uid from calendar event
   kbx granola push CALENDAR_UID --notes-file /tmp/prep-notes.md --title "Meeting Title"
   ```

3. **Verify** the push landed:
   ```bash
   kbx granola view CALENDAR_UID
   ```
   Confirm to the user: "Prep notes synced to Granola." If the notes aren't there, report the issue.

- Get the `calendar_uid` and meeting title from the event identified in step 1 (available as fields on calendar events)
- **Always use the full `calendar_uid` from the calendar output.** Recurring events have instance-specific UIDs (e.g., `base_id_20260303T143000Z`) — using only the base ID could match the wrong week's occurrence.
- Pass `--title` so the doc gets a proper name — Granola does not auto-populate the title from the calendar event

**If the user declines or doesn't respond**, skip the push and continue to follow-ups.

**Graceful fallback:** If the push fails for any reason, tell the user: "Prep notes ready but couldn't sync to Granola: [reason]. You can copy them manually."

### 6. Offer Follow-ups

- "Want me to draft talking points for any of these topics?"
- "Should I check anything else before the meeting?"
- "After the meeting, run /debrief to capture actions and decisions."

## For Recurring Meetings

If this meeting appears in the pinned recurring meetings note (from `kbx context`), also include:
- What was discussed last time (via `kbx search`)
- Which action items from last time are still open
- Any changes in the attendee list since last time

## Unknown Attendees / No History

If there is no related or recent meeting history that appears relevant to this conversation:

1. Identify it as a meeting with [person] from [company — inferred from their email domain, not gmail/personal domains]
2. If enough context exists to make useful suggestions, do so based on:
   - The meeting type
   - The executive's role and current priorities
   - Any company context that can be inferred
3. If not enough context, ask: "I don't have much history with [person]. What's the context for this meeting? Any specific goals?"

For 1:1s with direct reports, add role and responsibility-aware reflections or questions — not just status updates. Think about what a good manager would want to check on with this person specifically.

## Graceful Degradation

| Missing Source | Impact | Fallback |
|---|---|---|
| Calendar backend | Cannot identify meeting | Fall back to Calendar MCP if available, or ask user for details |
| kbx | No attendee or meeting context | Fall back to Granola MCP for previous occurrence, note limited people context |
| Chat | No recent interaction history | Note "no recent threads found" |
| Project tracker | No project status | Skip that section |
| Granola (write) | Prep notes not synced to Granola | Present prep to user normally, note Granola sync was skipped |
