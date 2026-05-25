/chief-of-staff:debrief {{MEETING_NAME}}

UNATTENDED MODE — follow these rules strictly:

1. Use "source: cos-agent-unattended" in the frontmatter (not "cos-agent").
2. Do NOT create gm tasks in unattended mode — too noisy. Instead, write non-personal items as Open Items on the relevant kbx entity file:
   - Read the entity file first: `kbx view <entity-path> --plain`
   - **Dedup check (required):** Check existing Open Items for the same commitment (even if from a different meeting). SKIP duplicates. If the new item adds detail to an existing one, use the Edit tool to update it in place (MERGE) rather than adding a new line.
   - **Insert new items with `kbx note edit --insert-under`** (kbx >= 0.2.13). This is the deterministic path — creates the section if absent, inserts most-recent-first if present, idempotent on exact duplicates:
     ```
     kbx note edit <entity-path> --insert-under "## Open Items" --body "- [YYYY-MM-DD] description (from: Meeting Title)"
     ```
   - Do NOT use the raw Edit tool for Open Items insertion — it has produced duplicate `## Open Items` headings on the same file. `--insert-under` is the only supported path.
   - Do NOT use `kbx note edit --append` for Open Items — it appends to EOF and breaks most-recent-first ordering.
   - Items where Jeremy is personally accountable: before creating a new gm task, run `gm tasks list --status open --json` and check for an existing task with a similar title. If a match exists, enrich it via `gm tasks update <id> --description "..."` with the new context rather than creating a duplicate. If no match exists, create the task normally.
3. Auto-update kbx entities for HIGH-CONFIDENCE changes only — role changes, team moves, reporting line changes that are explicitly stated in the transcript. Skip ambiguous signals. **Dedup check:** Before writing any fact or entity edit, read the entity file and check if the information is already captured. SKIP duplicates, MERGE if the new info updates existing content.
4. Skip the follow-up menu entirely. Do not offer next steps.
5. No interactive prompts. Do not ask for clarification — make your best judgement.
6. If a .debrief.md file already exists for this meeting, skip entirely — do not overwrite.
7. Read ALL available source files for the meeting — a single meeting can have both Granola and Notion variants of each file type:
   - **Transcripts** (`.granola.transcript.md`, `.notion.transcript.md`) — always read ALL available transcripts. These are the ground truth for action items, decisions, and exact quotes.
   - **Notes** (`.granola.notes.md`, `.notion.notes.md`) — read when available. Shows what the user flagged as important during the meeting.
   - **AI Summary** (`.granola.ai-summary.md`) — read when available. Useful as cross-check but do not extract action items solely from summaries.
8. **Speaker attribution preference:** When multiple transcripts exist for the same meeting, prefer the one with more named speakers as the primary extraction source. iPhone Granola recordings often detect different voices better than the Mac app — a transcript with "Speaker A: ... Speaker B: ..." is higher fidelity than one with no speaker labels or a single "Speaker:" throughout. Read all transcripts, but weight the multi-speaker one most heavily for extraction.
