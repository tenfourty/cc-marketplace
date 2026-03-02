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

Use `gm today` output if already in context, otherwise run `gm today --json --response-format concise --no-frames`. Match the user's description to a specific event. If ambiguous, ask for clarification.

**Skip declined meetings:** Check the `my_status` field on the matched event. If it is `"declined"`, tell the user: "You've declined that meeting — want me to prep anyway?" Only proceed if they confirm. Extract:
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

### 2. Load Context

Use `kbx context` if already in context (provides pinned docs including CIRs, initiatives, recurring meetings, cadence).

For each attendee:
- `kbx person find "Name" --json` for their profile
- Check if they relate to any known projects via `kbx project find "Name"`

### Freshness Awareness

For each attendee looked up via kbx:
- Check the `updated_at` and `last_mentioned_at` fields from `kbx person find "Name" --json`
- If profile data is >30 days old with no recent mentions, add an inline note: "Note: [Name]'s profile was last updated [N] days ago — data may be stale"
- If >90 days old, explicitly caveat any analysis based on that person's role, team, or reporting data

For the meeting topic:
- Check if it relates to an active initiative (from kbx context pinned docs)
- `kbx note list --tag decision --json` for recent decisions involving these attendees or topics

### 3. Gather Recent Intelligence

Spawn the meeting-prep agent using the `Agent` tool with `run_in_background: true` and `model: "haiku"`. **Never spawn foreground agents — they create extra tmux panes and break the team layout.**

The meeting-prep agent should search in parallel across:

**Recent interactions:**
- `kbx person timeline "Name" --from YYYY-MM-DD --json` for each attendee (last 7 days)
- Slack MCP for recent messages from/to each attendee
- Relevant channel discussions related to the meeting topic

**Previous occurrence (if recurring):**
- `kbx search "meeting title" --fast --json --limit 3` to find last transcript
- `kbx view <path> --plain` to read it
- Action items from the previous occurrence
- Any commitments made that may need follow-up

**Tasks and project status:**
- `gm tasks list --json --response-format concise` filtered for tasks related to attendees or topic
- `gm tasks list --source linear --json` for related Linear items

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

### 5. Offer Granola Sync

After presenting the brief, offer to push the prep notes to the meeting's Granola document:

> "Want me to push these prep notes to Granola so they're ready when the meeting starts?"

**If the user confirms**, write the prep brief to a temp file and push:

```bash
# Write prep markdown to temp file
cat > /tmp/prep-notes.md << 'PREP'
[full prep brief markdown from step 4]
PREP

# Push using calendar_uid from gm event
kbx granola push CALENDAR_UID --notes-file /tmp/prep-notes.md --title "Meeting Title"
```

- Get the `calendar_uid` and meeting title from the event identified in step 1 (available as fields on `gm today` events)
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
| gm | Cannot identify meeting | Fall back to Calendar MCP if available, or ask user for details |
| kbx | No attendee or meeting context | Fall back to Granola MCP for previous occurrence, note limited people context |
| Slack | No recent interaction history | Note "no recent threads found" |
| Linear | No project status | Skip that section |
| Granola (write) | Prep notes not synced to Granola | Present prep to user normally, note Granola sync was skipped |
