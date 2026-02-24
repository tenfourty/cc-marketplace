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

Use `gm today` output if already in context, otherwise run `gm today --json --response-format concise --no-frames`. Match the user's description to a specific event. If ambiguous, ask for clarification. Extract:
- Meeting title
- Time and duration
- Attendees list
- Any agenda or description in the calendar invite
- Whether this is a recurring meeting

### 2. Load Context

Use `kbx context` if already in context (provides pinned docs including CIRs, initiatives, recurring meetings, cadence).

For each attendee:
- `kbx person find "Name" --json` for their profile
- Check if they relate to any known projects via `kbx project find "Name"`

For the meeting topic:
- Check if it relates to an active initiative (from kbx context pinned docs)
- `kbx note list --tag decision --json` for recent decisions involving these attendees or topics

### 3. Gather Recent Intelligence

**Dispatch the meeting-prep agent** to search in parallel across:

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

Use this structure:

```
## Meeting Prep — [Meeting Title]
**Time:** [time and duration]
**Type:** [recurring/one-off] [if recurring: last held on X]

### Attendees
[For each attendee:]
- **[Name]** — [role]. [One line of relevant context: what they own, recent interactions, any open items with them]

### Context
[Why this meeting exists. What's been happening. What's at stake.]

### Open Items
[Action items from previous meetings with these people. Status of commitments.]

### Key Topics to Raise
[Suggested agenda items based on open items, recent signals, and CIRs]

### Decisions Pending
[Any decisions that could/should be made in this meeting]

### Background
[Relevant recent decisions, project status, or context the exec should have in mind]
```

### 5. Offer Follow-ups

- "Want me to draft talking points for any of these topics?"
- "Should I check anything else before the meeting?"
- "After the meeting, run /debrief to capture actions and decisions."

## For Recurring Meetings

If this meeting appears in the pinned recurring meetings note (from `kbx context`), also include:
- What was discussed last time (via `kbx search`)
- Which action items from last time are still open
- Any changes in the attendee list since last time

## Graceful Degradation

| Missing Source | Impact | Fallback |
|---|---|---|
| gm | Cannot identify meeting | Fall back to Calendar MCP if available, or ask user for details |
| kbx | No attendee or meeting context | Fall back to Granola MCP for previous occurrence, note limited people context |
| Slack | No recent interaction history | Note "no recent threads found" |
| Linear | No project status | Skip that section |
