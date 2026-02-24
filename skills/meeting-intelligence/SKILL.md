# Meeting Intelligence

This skill defines how the Chief of Staff works with meeting transcripts, meeting preparation, and meeting follow-up.

## Transcript Sources

The plugin supports meeting transcript sources:
- **Granola** — meeting transcripts with AI-generated summaries and notes
- **Notion Meetings** — meeting notes and transcripts stored in Notion

These are accessed via ~~meeting transcripts MCP connections.

## Working with Transcripts

### What to Extract

From every meeting transcript, the Chief of Staff should be able to extract:

1. **Action Items** — WHO committed to WHAT by WHEN
   - Distinguish between the executive's own commitments and others' commitments
   - Flag vague commitments ("I'll look into it") for clarification
   - Map to existing tasks in TASKS.md where possible

2. **Decisions** — WHAT was decided, by WHOM, with what RATIONALE
   - Note dissent or conditions
   - Note alternatives that were discussed
   - Format for the decision log (memory/decisions/)

3. **Follow-ups** — Items needing attention but not concrete action items
   - "We should circle back on X"
   - "Let me think about that"
   - Requests for information

4. **Context Updates** — New facts that should be remembered
   - Project status changes
   - People updates (new roles, departures, concerns)
   - Timeline changes
   - Scope changes

5. **Commitments from Others** — What other people promised
   - These become "Waiting On" items in TASKS.md
   - Track who, what, and when

### Extraction Principles

- **Err on the side of capturing too much.** A logged action item that turns out to be trivial costs nothing. A missed commitment that drops can be costly.
- **Use exact names and terminology.** Don't paraphrase project names or people's names — match the shorthand in CLAUDE.md and memory/.
- **Distinguish between discussion and decision.** Something being talked about is not the same as it being decided. Only log decisions that were clearly made.
- **Note the energy in the room.** If a topic generated significant debate, note that. If someone seemed concerned but didn't push back, note that too (for coach voice analysis).

## Meeting Preparation

### For Recurring Meetings

Recurring meetings have context in `memory/meetings/recurring.md`. For these:
1. Pull the transcript from the last occurrence
2. Check what action items came out of it
3. Verify which have been completed and which are still open
4. Note any changes to the attendee list
5. Surface any relevant developments since last time

### For One-Off Meetings

1. Research attendees via memory/people/, ~~chat
2. Identify the likely topic/agenda from the calendar invite
3. Find relevant context from memory/decisions/, memory/priorities/
4. Check for any open items or pending decisions with attendees

### Pre-Meeting Intelligence Template

For each attendee, build a micro-profile:
```
- **[Name]** ([role])
  - Last interaction: [date and context]
  - Open items with them: [list from TASKS.md]
  - Recent activity: [what they've been posting/discussing]
  - Context to know: [anything relevant from memory/]
```

## Post-Meeting Processing

After a meeting (via `/debrief`):

1. **Immediate extraction** — Pull action items, decisions, follow-ups
2. **Cross-reference** — Check against existing tasks and decisions
3. **Update TASKS.md** — Add new items, update existing ones
4. **Update decision log** — Append to memory/decisions/YYYY-MM.md
5. **Update people profiles** — Add any new context about attendees
6. **Update CLAUDE.md** — If any high-impact decisions or priority shifts
7. **Flag for briefing** — Queue any CIR-matching items for next briefing

## Meeting Pattern Analysis (for Weekly Review)

In the weekly review, analyse meeting patterns:
- **Time allocation:** What percentage of the week was in meetings?
- **Meeting types:** How much was 1:1 vs. group? Strategic vs. operational?
- **Decision velocity:** How many meetings resulted in clear decisions?
- **Follow-through:** What percentage of action items from last week's meetings were completed?
- **Recurring meeting health:** Are recurring meetings productive or going through motions?

## Recurring Meeting Context Format

Store in `memory/meetings/recurring.md`:

```markdown
## [Meeting Name]
- **Cadence:** weekly/biweekly/monthly
- **Day/Time:** [when]
- **Duration:** [how long]
- **Attendees:** [who, with roles]
- **Purpose:** [why this meeting exists]
- **Typical agenda:** [what gets discussed]
- **Prep needed:** [what the executive should review before]
- **Key outputs:** [decisions, status updates, action items]
- **Last held:** [date]
- **Notes:** [any context about dynamics, effectiveness, concerns]
```

## When Transcripts Aren't Available

If no transcript source is connected or a meeting wasn't recorded:
- Ask the executive for a quick verbal debrief
- Prompt with structured questions: "Any action items? Decisions? Follow-ups?"
- Process whatever they share through the same extraction pipeline
- Note in the record that this was a manual capture, not transcript-based
