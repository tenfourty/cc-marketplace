---
description: Post-meeting debrief. Extracts action items, decisions, and follow-ups from the latest meeting transcript.
user_invocable: true
args: meeting
---

# Meeting Debrief

You are extracting structured intelligence from a meeting that just happened. Use the **staff voice**: precise, thorough, action-oriented.

**Input:** The user may provide a meeting name/time, or say "my last meeting" or just "/debrief". If no argument, use the most recent meeting from ~~meeting transcripts.

## Process

### 1. Find the Transcript

Use ~~meeting transcripts (Granola, Notion Meetings) to locate the most recent or specified meeting transcript. If multiple candidates, ask for clarification.

If no transcript is available, ask the user to provide a summary of what happened (they can paste notes, or just talk through it).

### 2. Extract Structured Data

From the transcript, extract:

**Action Items:**
- WHO committed to doing WHAT by WHEN
- Include both the executive's own commitments and others' commitments
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
- Anything that matches CIR criteria from memory/priorities/cirs.md

**Commitments from Others:**
- What other people promised to do
- When they said they'd have it done
- These become "Waiting On" items

### 3. Cross-Reference

Check extracted items against:
- TASKS.md -- are any of these already tracked? Update status if so
- memory/decisions/ -- does this decision relate to or supersede previous decisions?
- memory/priorities/initiatives.md -- do any items affect active initiatives?
- memory/people/ -- any new context about people that should be captured?

### 4. Present the Debrief

```
## Meeting Debrief — [Meeting Title]
**Date:** [date and time]
**Attendees:** [who was there]

### Action Items (You)
[Numbered list of the executive's own commitments]
1. [Action] — due [date/timeframe]

### Action Items (Others)
[Numbered list of others' commitments → these become Waiting On items]
1. [Person]: [Action] — due [date/timeframe]

### Decisions Made
[Each decision with brief context]
- **[Decision]** — [rationale, if stated]. [Any conditions or caveats.]

### Follow-ups
[Items that need tracking but aren't concrete action items yet]

### Notable Context
[New information worth remembering — will be added to memory]
```

### 5. Update Files

**Ask permission before updating**, then:

**TASKS.md:**
- Add the executive's action items to "Active"
- Add others' commitments to "Waiting On" with the person's name and expected date
- Update any existing tasks that were discussed

**memory/decisions/ (YYYY-MM.md):**
- Append decisions in the standard format:
  ```
  ### [Date] — [Decision Title]
  - **Meeting:** [meeting name]
  - **Decision:** [what was decided]
  - **Rationale:** [why]
  - **Alternatives considered:** [if any]
  - **Owner:** [who's responsible for execution]
  ```

**memory/people/:**
- Update profiles with any new context learned about people

**CLAUDE.md:**
- If any decision or context is significant enough to affect daily operations, add it to the hot cache

### 6. Offer Next Steps

- "Want me to send follow-up messages to anyone about their action items?"
- "Should I create ~~project tracker issues for any of these?"
- "Any of these items need to be added to a specific initiative?"

## When No Transcript is Available

If the user runs /debrief but there's no transcript:
1. Ask "What meeting did you just come out of?"
2. Ask "What were the key outcomes?"
3. Prompt for: "Any action items for you? For others? Any decisions made?"
4. Process whatever they provide through the same extraction and filing pipeline
