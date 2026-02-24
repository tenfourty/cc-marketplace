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

Use ~~calendar to find the specific meeting. If ambiguous, ask for clarification. Extract:
- Meeting title
- Time and duration
- Attendees list
- Any agenda or description in the calendar invite
- Whether this is a recurring meeting

### 2. Load Context

**From memory:**
- Check memory/meetings/recurring.md for established context about this meeting type
- Check memory/people/ for profiles of each attendee
- Check CLAUDE.md for quick-reference info about attendees
- Check memory/priorities/initiatives.md for relevant initiatives

**From decision history:**
- Check memory/decisions/ for recent decisions involving these attendees or topics

**From tasks:**
- Check TASKS.md for items owned by or waiting on attendees
- Check for items related to the meeting topic

### 3. Gather Recent Intelligence

**Dispatch the meeting-prep agent** to search in parallel across:

**Chat (~~chat):**
- Recent messages from/to each attendee (last 7 days)
- Relevant channel discussions related to the meeting topic
- Any unresolved threads involving attendees

**Meeting transcripts (~~meeting transcripts):**
- Last meeting with same attendees (if recurring)
- Action items from the previous occurrence
- Any commitments made that may need follow-up

**Project tracker (~~project tracker):**
- Issues/items relevant to the meeting topic
- Items assigned to or created by attendees
- Sprint/project status for relevant initiatives

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

If this meeting is in memory/meetings/recurring.md, also include:
- What was discussed last time
- Which action items from last time are still open
- Any changes in the attendee list since last time

## Graceful Degradation

| Missing Source | Impact | Fallback |
|---|---|---|
| Calendar | Cannot identify meeting | Ask user for details |
| People memory | No attendee context | Note "no profile on file" and offer to create one |
| Chat | No recent interaction history | Note "no recent threads found" |
| Transcripts | No previous meeting history | Note "no transcript available for last occurrence" |
| Project tracker | No project status | Skip that section |
