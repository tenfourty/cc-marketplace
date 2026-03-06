# Meeting Intelligence

This skill defines how the Chief of Staff works with meeting transcripts, meeting preparation, and meeting follow-up.

## Meeting Data Sources

Meeting data is accessed primarily via kbx, which indexes content from Granola and Notion. Each meeting can have up to three file types, and each file type can exist in multiple source variants:

| File Type | Granola variant | Notion variant | When to Use |
|-----------|----------------|----------------|-------------|
| **Transcript** | `.granola.transcript.md` | `.notion.transcript.md` | **Ground truth.** Action extraction, exact quotes, decision capture, deep analysis. Longest but most reliable. |
| **Notes** | `.granola.notes.md` | `.notion.notes.md` | Quick context. What the user considered important, prep for follow-ups. May omit details the user didn't highlight. |
| **AI Summary** | `.granola.ai-summary.md` | — | Quick orientation when transcript is too long, scanning for themes. **Treat as lossy** — always verify key claims against transcript before acting on them. |

### Multi-Source Meeting Files

A single meeting can have files from **both** Granola and Notion — each source produces its own transcript, notes, and (for Granola) AI summary. Always read **every available file** for the meeting, not just one source's files.

**Speaker attribution quality:** When multiple transcripts exist for the same meeting, prefer the one with richer speaker attribution (multiple named speakers, e.g., "Jeremy: … Pierre: …") as the **primary extraction source**. The iPhone Granola app often detects different voices better than the Mac app, producing multi-speaker transcripts while the Mac version may attribute everything to a single speaker. A multi-speaker transcript is higher fidelity — use it as primary, and cross-reference the other transcript for anything it may have captured that the primary missed (e.g., side comments, different audio pickup).

### Source Priority

The transcript is always the primary source for action items, decisions, and quotes — regardless of which recording source produced it. Notes and AI summaries are supplementary — they add context but should not replace the transcript.

**For debrief and deep extraction:** Read all available source variants for the meeting. Transcripts are mandatory; notes show what the user flagged as important; the AI summary is a useful cross-check.

**For search and scanning:** `kbx search` indexes all file types and source variants. When results include multiple files for the same meeting, prefer the transcript with the best speaker attribution for detailed reading.

**Important:** Do not extract action items or decisions solely from AI summaries. They may miss, misattribute, or hallucinate commitments.

### Discovery

Use `kbx search` to find meeting data and `kbx view <path> --plain` to read it. kbx indexes all file types and source variants. If kbx returns nothing, fall back to `kbx granola view <calendar_uid> --all` to fetch live from the Granola API.

## Working with Transcripts

### What to Extract

From every meeting transcript, the Chief of Staff should be able to extract:

1. **Action Items** — WHO committed to WHAT by WHEN
   - Distinguish between the executive's own commitments and others' commitments
   - Flag vague commitments ("I'll look into it") for clarification
   - Map to existing tasks via the task backend where possible (see task-backend skill)

2. **Decisions** — WHAT was decided, by WHOM, with what RATIONALE
   - Note dissent or conditions
   - Note alternatives that were discussed
   - Format for logging via `kbx memory add --tags decision`

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
   - Create a task with status waiting-on via the task backend (see task-backend skill for syntax)
   - Track who, what, and when
   - Include `project: <ProjectName>` in the description if related to a known kbx project (one project per task)

### Extraction Principles

- **Err on the side of capturing too much.** A logged action item that turns out to be trivial costs nothing. A missed commitment that drops can be costly.
- **Use exact names and terminology.** Don't paraphrase project names or people's names.
- **Distinguish between discussion and decision.** Something being talked about is not the same as it being decided. Only log decisions that were clearly made.
- **Note the energy in the room.** If a topic generated significant debate, note that. If someone seemed concerned but didn't push back, note that too (for coach voice analysis).

## Meeting Preparation

### For Recurring Meetings

Recurring meetings have context in the pinned kbx meetings note. For these:
1. `kbx search "meeting title" --fast --json --limit 3` to find the last transcript
2. `kbx view <path> --plain` to read it
3. Cross-reference action items against the task backend to check which are still open
4. Note any changes to the attendee list
5. Surface any relevant developments since last time

### For One-Off Meetings

1. Research attendees via `kbx person find "Name" --json`, chat MCP
2. Identify the likely topic/agenda from the calendar invite (via the calendar backend)
3. `kbx note list --tag decision --json` for related past decisions
4. List tasks via the task backend for open items with attendees

### Pre-Meeting Intelligence Template

For each attendee, build a micro-profile:
```
- **[Name]** ([role])
  - Last interaction: [date and context from kbx person timeline]
  - Open items with them: [list from task backend]
  - Recent activity: [what they've been posting/discussing]
  - Context to know: [anything relevant from kbx]
```

## Post-Meeting Processing

After a meeting (via `/debrief`):

1. **Immediate extraction** — Pull action items, decisions, follow-ups from `kbx search` + `kbx view --plain`
2. **Cross-reference** — Check against the task backend and `kbx note list --tag decision`
3. **Update tasks** — Create tasks via the task backend for new items (include `project: <ProjectName>` in description when related to a kbx project, one project per task), update existing ones
4. **Log decisions** — `kbx memory add --tags decision` for each decision
5. **Update people** — `kbx memory add --entity "Name"` for new context about attendees
6. **Flag for briefing** — Queue any CIR-matching items for next briefing

## Meeting Pattern Analysis (for Weekly Review)

In the weekly review, analyse meeting patterns:
- **Time allocation:** What percentage of the week was in meetings?
- **Meeting types:** How much was 1:1 vs. group? Strategic vs. operational?
- **Decision velocity:** How many meetings resulted in clear decisions?
- **Follow-through:** What percentage of action items from last week's meetings were completed?
- **Recurring meeting health:** Are recurring meetings productive or going through motions?

## Recurring Meeting Context Format

Stored in the pinned kbx meetings note:

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
- **[Any additional fields]:** Special instructions for prep/debrief — e.g., a Notion DB to check for shared meeting notes, a chat channel to scan, a Google Doc with standing agenda. The prep and debrief commands read every field and follow any instructions they find here.
```

## When Transcripts Aren't Available

If no transcript source is connected or a meeting wasn't recorded:
- Ask the executive for a quick verbal debrief
- Prompt with structured questions: "Any action items? Decisions? Follow-ups?"
- Process whatever they share through the same extraction pipeline
- Note in the record that this was a manual capture, not transcript-based
