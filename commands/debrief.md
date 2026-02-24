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

Use `kbx search "meeting title" --fast --json --limit 5` to find the most recent or specified meeting transcript. Use `kbx view <path> --plain` to read it.

If not found in kbx, fall back to Granola MCP for the transcript.

If no transcript is available from any source, ask the user to provide a summary of what happened (they can paste notes, or just talk through it).

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

### 5. Update Systems

**Ask permission before updating**, then:

**Tasks (gm):**
- Executive's action items: `gm tasks create --title "..." --tag Active --list LIST --due ISO`
- Others' commitments: `gm tasks create --title "..." --tag Waiting-On --list LIST`
- Update any existing tasks that were discussed

**Decisions (kbx):**
- `kbx memory add "Decision Title" --body "structured markdown" --tags decision` for each decision made
- If person-related, also `--entity "Name"`

**People context (kbx):**
- `kbx memory add "context" --entity "Name"` for new context about attendees

### 6. Offer Next Steps

- "Want me to send follow-up messages to anyone about their action items?"
- "Should I create Linear issues for any of these?" (via Linear MCP)
- "Any of these items need to be added to a specific initiative?"

## When No Transcript is Available

If the user runs /debrief but there's no transcript:
1. Ask "What meeting did you just come out of?"
2. Ask "What were the key outcomes?"
3. Prompt for: "Any action items for you? For others? Any decisions made?"
4. Process whatever they provide through the same extraction and filing pipeline
