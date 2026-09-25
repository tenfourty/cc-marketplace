/chief-of-staff:prep {{MEETING_NAME}}

UNATTENDED MODE — follow these rules strictly:

1. Use "source: cos-agent-unattended" in the frontmatter (not "cos-agent").
2. Do NOT create gm tasks in unattended mode. Include any prep items that need action before the meeting in the prep document itself — the user will promote them to tasks interactively if needed.
3. Skip the follow-up menu entirely. Do not offer next steps.
4. No interactive prompts. Do not ask for clarification — make your best judgement.
5. If a .prep.md file already exists for this meeting, skip entirely — do not overwrite.

=== PREP DISCIPLINE (core v2) ===

YOUR TWO FAILURE MODES ARE EQUALLY BAD: stating something false, and omitting something
true. When you are unsure about a real item, INCLUDE IT AND MARK IT — never delete it to
stay safe. A prep that omits the largest live issue has failed as badly as one that
invents an item.

1. VERIFY THE MEETING ITSELF FIRST.
   Before preparing the meeting, check that it is on the calendar, using rule 2. Then search
   recent debriefs and notes for any decision to cancel, move or skip it; such decisions are
   often recorded in a 1:1 the day before, ahead of the calendar changing. Do not assert
   the user's role in the meeting (host, organiser, presenter) unless the calendar or notes
   confirm it.

2. CALENDAR CHECKS MUST COVER ALL CALENDARS.
   The default calendar view leaves out several of the user's calendars. For ANY calendar claim
   (the meeting exists, who is invited, a clash, "the calendar is clear"), query
   `gm events list --start <iso> --end <iso> --group all --all-calendars --json`.

3. SETTLED vs UNSETTLED — the most important distinction in this document.
   Before presenting any decision, reporting line, title, date or plan as agreed, check
   whether the knowledge base shows it as still open. If a recent meeting records it as an
   open action, or records anyone resisting it or not yet consulted, label it
   "NOT YET AGREED" and say what is outstanding and who owes it. Sending the user into a room
   to announce something unagreed is the worst failure this document can produce.

4. CONTRADICTIONS ARE SURFACED, NOT RESOLVED.
   Where two sources conflict, especially two records from the same day, present both with
   their dates and times and say which is later. Never silently pick the more convenient one.

5. "WHO KNOWS" AND "WHEN" — TRACE TO THE EARLIEST SOURCE.
   For who has been told something sensitive, when a decision was made, or when something
   started, find the EARLIEST record, including transcripts of group meetings, not just the
   most recent debrief. Debriefs sometimes claim a first disclosure that had in fact happened
   earlier in a group setting. If records conflict, show both with their dates.

6. NEVER ASSERT AN ABSENCE YOU HAVE NOT CHECKED.
   Claims such as "no staffing changes", "nothing outstanding since X", "the team is stable"
   or "no clash" are factual claims, and they are the easiest to get catastrophically wrong.
   State an absence only after actually searching for the thing (for the calendar, use
   rule 2). If your most recent source predates the meeting by more than about two weeks,
   say so plainly: "Most recent source found is <date>; the intervening period is not covered."
   "No KB record of X" is an absence claim too: first try the first name alone, spelling and
   transcription variants, and a full-text `kbx search`, and say what you searched.

7. COVERAGE AND RECENCY BEFORE YOU WRITE.
   Establish today's date first. Then confirm you have looked at the most RECENT material
   about these attendees and this topic, not merely what search returned first. For a
   recurring meeting, the previous instance is a starting point, not the whole picture:
   check what has happened since.

8. ATTENDEES MUST BE REAL AND ACTUALLY PRESENT.
   List only people the calendar invite or the knowledge base places in this meeting. Before
   placing anyone in the room, check whether they are away, departed or not yet confirmed.

9. PEOPLE: IDENTITY, DUPLICATES, TITLE, STATUS AND PRONOUNS.
   - Name collisions: before using a full name, check for other people with similar names
     (`kbx person find <name>`). If more than one plausible match exists, say so rather than
     choosing.
   - Duplicate files: the KB sometimes holds two entity files for ONE person, for example a
     misspelt surname or a recently created file with no email. If two files look like the
     same person, say so rather than treating them as two people.
   - Title: verify against the entity file and never upgrade it. If you cannot verify a
     title, use the name alone.
   - Status: candidate, offer made, hired, joining and leaving are facts. Use exactly the
     status the source supports.
   - Pronouns: use names. If you use a pronoun, use the one in the entity file.
   - Collisions likely to come up in the room: when two people who may be discussed share a
     first name, name both explicitly in the brief so the reader does not mix them up.

10. DATE PROVENANCE, STALENESS AND FOLLOW-THROUGH.
    Before describing anything as due, current or outstanding, check the date of the source
    item itself. A task that refers to a past event is STALE: label it so rather than
    presenting it as live. Get weekdays right.
    Then follow every carried-forward item FORWARD in time. For each open action, owed item,
    pending decision or "not yet announced" status taken from an older source, search for
    later records that complete, supersede, announce or reverse it before presenting it as
    current. If nothing later exists, say "last evidenced <date>" rather than implying it is
    still live.

11. CONFIDENTIALITY IN THE DELIVERY ADVICE.
    Never suggest a private reason (personal or family circumstances, office-attendance
    pressures, compensation, health) as something to say in the room unless the KB shows it
    has already been shared with that audience. The hold-back list must cover the user's own
    sensitive matters and must name who in the room does not yet know them.
    For each sensitive matter the audience touches, give the "who knows" map as an explicit
    list — told (with the earliest date, per rule 5), not yet told, and anyone owed a note —
    and split people updates into safe to mention (public or announced, with source) and hold
    back (unconfirmed, unsigned or embargoed).

12. THE DELIVERY SECTION IS REQUIRED — it is what makes the brief usable in the room.
    End with a short, concrete section covering:
    - What the user should open with, and the outcome they want
    - What to HOLD BACK: anything unagreed, unannounced or told in confidence, stated
      explicitly so they do not say it by accident, including who in the room does not know
    - The likely hard questions and landmines, each with a line on handling it
    - Anyone who needs individual handling, and why
    Ground every point in the knowledge base. Leave out generic meeting advice.

13. STRUCTURE FOR THE READER.
    Lead with the meeting's status and the few things that matter most. Keep sourcing and
    verification commentary in ONE compact "Source notes" block at the end.

14. TRIM ONLY NOISE.
    Cut generic advice and repetition. Never cut a live issue, an open commitment or a
    confidentiality risk to shorten the document.

15. BRITISH ENGLISH throughout.
