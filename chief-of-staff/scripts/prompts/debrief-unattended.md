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
   - Items where the user is personally accountable: before creating a new gm task, run `gm tasks list --status open --json` and check for an existing task with a similar title. If a match exists, enrich it via `gm tasks update <id> --description "..."` with the new context rather than creating a duplicate. If no match exists, create the task normally.
3. Auto-update kbx entities for HIGH-CONFIDENCE changes only — role changes, team moves, reporting line changes that are explicitly stated in the transcript. Skip ambiguous signals. **Dedup check:** Before writing any fact or entity edit, read the entity file and check if the information is already captured. SKIP duplicates, MERGE if the new info updates existing content.
4. Skip the follow-up menu entirely. Do not offer next steps.
5. No interactive prompts. Do not ask for clarification — make your best judgement.
6. If a .debrief.md file already exists for this meeting, skip entirely — do not overwrite.
7. Read ALL available source files for the meeting — a single meeting can have both Granola and Notion variants of each file type:
   - **Transcripts** (`.granola.transcript.md`, `.notion.transcript.md`) — always read ALL available transcripts. These are the ground truth for action items, decisions, and exact quotes.
   - **Notes** (`.granola.notes.md`, `.notion.notes.md`) — read when available. Shows what the user flagged as important during the meeting.
   - **AI Summary** (`.granola.ai-summary.md`) — read when available. Useful as cross-check but do not extract action items solely from summaries.
8. **Speaker attribution preference:** When multiple transcripts exist for the same meeting, prefer the one with more named speakers as the primary extraction source. iPhone Granola recordings often detect different voices better than the Mac app — a transcript with "Speaker A: ... Speaker B: ..." is higher fidelity than one with no speaker labels or a single "Speaker:" throughout. Read all transcripts, but weight the multi-speaker one most heavily for extraction.

=== EXTRACTION DISCIPLINE (core) ===

YOUR TWO FAILURE MODES ARE EQUALLY BAD: stating something false, and omitting
something true. Do not trade one for the other. When you are unsure about a real
item, INCLUDE IT AND MARK IT — never delete it to stay safe. Deleting a genuine
commitment is as serious as inventing one.

1. THE TRANSCRIPT IS THE ONLY SOURCE FOR ACTION ITEMS, DECISIONS, OWNERS AND QUOTES.
   The `.granola.ai-summary.md` file and the `granola_summary` frontmatter field are a
   cross-check only. Never derive an item, decision, owner or quote from them. If it is
   in the summary but you cannot find it in the transcript, drop it. Quotation marks are
   reserved for words actually spoken in the transcript — never quote summary text.

2. OWNERS MUST BE NAMED IN THE SOURCE.
   Assign an owner only where the transcript names one, or a single speaker
   unambiguously commits ("I'll do X", "leave that with me"). Where the transcript says
   "we need to do X" and names nobody, keep the item and append
   "(owner unclear — needs confirmation)". Never hand an unowned task to the most
   plausible person. Never assign an item to someone not in the meeting, and never
   assign a decision to the person the decision is ABOUT.

3. DECIDED vs DISCUSSED.
   Record something under Decisions only if you could quote the line where it was
   settled or confirmed as already settled. If you cannot, keep the substance but place
   it under discussion or open questions — do not silently drop it, and do not promote
   it. Options weighed, preferences voiced and thinking-aloud are not decisions. Never
   invent a rationale; if the reason was not stated, do not supply one.
   The same applies to action items and reported facts: keep the speaker's modality.
   "Maybe", "we could", "I'd like to", "probably", "I think" are not commitments — carry
   the hedge into the item or file it under open questions. No date is attached to a
   follow-up unless one was spoken. Something a speaker reports second-hand ("I heard",
   "apparently", "he told me") stays attributed to that speaker, never stated as fact.

4. PRONOUN ANTECEDENTS AND POORLY DIARISED TRANSCRIPTS.
   Many transcripts are badly diarised — every line may be labelled "Me", or speakers
   unlabelled. Before attributing a statement, resolve who "he"/"she"/"they" refers to
   by re-reading the surrounding lines; the nearest named person is often not the
   antecedent. If attribution rests on inference rather than speaker labels, say so once
   near the top: "Attributions below are inferred from role and content context; this
   transcript is not reliably diarised."

5. NUMBERS ARE QUOTED, NEVER DERIVED.
   Reproduce figures exactly as stated. Do not compute, adjust, round, reconcile or
   combine them, and never assert which direction an adjustment moves a number unless
   the transcript says so. If two figures conflict, record both and flag it — unless the
   speaker self-corrects in the following lines, in which case take the correction.
   Transcription garbles numbers. If a figure is implausible for its context, or the words
   around it are garbled, write it as spoken and add "(figure unclear in transcript)" rather
   than cleaning it into a confident number.

6. NAMES AND ENTITY RESOLUTION — check for collisions before you resolve.
   This knowledge base contains people with very similar names (two people sharing a
   first name; near-identical surnames). Before expanding a bare first name into a full
   name, search for other candidates (`kbx person find <name>`). If more than one plausible
   person exists and the transcript does not disambiguate, use the name EXACTLY as spoken
   and add "(ambiguous — more than one match in KB)". A confidently wrong person is worse
   than an unresolved first name.
   "No KB match" is itself a claim. Before writing that someone or something is not in the
   KB, try the first name alone, likely spelling and transcription variants, and a full-text
   `kbx search`. Only then say it is not found — and say what you searched.

7. NEVER STATE A ROLE OR TITLE FROM MEMORY.
   Verify every title against that person's kbx entity file. If you cannot verify it,
   use the name alone. Do not upgrade, infer or paraphrase a title.

8. DATE PROVENANCE.
   Establish today's date first. Before describing anything as due, current, upcoming or
   outstanding, check the date of the source item itself — an item referencing a past
   event is stale, and should be labelled stale rather than presented as live. Get
   weekdays right; if a source states a weekday that does not match its date, flag the
   discrepancy rather than propagating it.

9. TRIM ONLY NOISE. Cut social digression and repeated statements of the same point.
   Never cut a commitment, decision, open question or number to shorten the document.

10. BRITISH ENGLISH throughout — organise, prioritise, finalise, recognise.

=== SPECIFICS MUST TRACE TO A SOURCE ===

Every specific — a date, a calendar event, a person's attendance, a task's status, a figure,
a full name — must trace to something opened in this session. If it was not read, do not
assert it; "not verified in the KB" is better than a plausible invention.
- Before naming any meeting, event or double-booking, confirm it exists in the calendar
  (`gm events list … --group all --all-calendars`).
- Before placing anyone in the room, confirm they are attending and that nothing says they
  are away, departed or not yet confirmed.
- Before calling anything due, current or outstanding, open the item and check its date and
  the event it refers to, then look for anything later that completed, replaced or reversed it.
