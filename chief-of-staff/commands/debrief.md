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

**Source preference:** Prefer `.transcript.md` files — they are the ground truth for extracting action items and decisions. If no transcript exists, fall back to `.notes.md`, then `.ai-summary.md`. Do not extract action items or decisions solely from AI summaries — they may miss or misattribute commitments.

If not found in kbx, fall back to Granola MCP for the transcript.

If no transcript is available from any source, ask the user to provide a summary of what happened (they can paste notes, or just talk through it).

### 2. Extract Structured Data

From the transcript, extract:

**Action Items (Two-Tier):**

*Explicit (To Do):* Direct commitments with clear ownership:
- WHO committed to doing WHAT by WHEN
- "I'll send the draft by Friday" / "Can you review this?" / "[Name] to handle X"
- Include both the executive's own commitments and others' commitments

*Inferred:* Implicit commitments where the executive is likely responsible:
- "We should update the docs" (where context suggests executive ownership)
- Group suggestions the executive implicitly agreed to
- Tag these as *(inferred)* in the output

An action item is a **future commitment** — not a status update. "I am doing X" (current work) is NOT an action item. "I will do X" (new commitment) IS.

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

### 5. Entity Change Detection

For each meeting attendee, check if their profile needs updating:

1. Look up their current profile: `kbx person find "Name" --json`
2. Scan the transcript for signals that someone's profile may have changed:
   - Role/title changes ("is now leading...", "moved to the X team", "promoted to...")
   - Reporting line changes ("reports to Y now", "joining Z's team")
   - Responsibility shifts ("taking over...", "handing off...", "no longer owns...")
   - Departures/arrivals ("last day is...", "new hire starting...", "leaving the company")
3. If a change is detected and you're confident:
   - Edit directly: `kbx person edit "Name" --role "New Role"` (or `--team`, `--meta "key=value"`)
   - Add a dated fact: `kbx memory add "change description" --entity "Name"`
   - Report what you changed in the debrief output under "Notable Context"
4. If ambiguous, note it in the debrief output for the user to verify

### 6. Update Systems

**Ask permission before updating**, then:

**Tasks (gm):**
- Executive's action items: `gm tasks create --title "..." --tag Active --list LIST --due ISO --description "..."`
- Others' commitments: `gm tasks create --title "..." --tag Waiting-On --list LIST --description "..."`
- **Project linking:** If the action item relates to a known kbx project, include `project: <ProjectName>` on a line in the `--description` (e.g., `--description "project: CoreLogic Migration\nFollow up on migration timeline"`). Multiple `project:` lines supported.
- Update any existing tasks that were discussed

**Decisions (kbx):**
- `kbx memory add "Decision Title" --body "structured markdown" --tags decision` for each decision made
- If person-related, also `--entity "Name"`

**People context (kbx):**
- `kbx memory add "context" --entity "Name"` for new context about attendees

### 7. Offer Next Steps

Present a follow-on menu based on what's relevant to this meeting:

**Always offer:**
- "Should I create Linear issues for any of these?" (via Linear MCP)
- "Any of these items need to be added to a specific initiative?"

**Offer contextually:**

- **Write a tldr** — Offer when the meeting had external attendees or cross-team relevance ("Want a tldr to share with the team?"). Format: Three sentences. First: "Met with [person/company] to discuss [topic]." Then two bullet points with key outcomes. Designed to be pasted into Slack immediately.

- **Draft a follow-up email** — Offer when there are action items involving external parties or when commitments need confirming. Write a short, casual, action-oriented email. If the executive promised something quick (<5 mins like finding a document), assume it's done and use placeholders (e.g., "[Insert link to DPA]"). If others promised something important, nudge them toward a deadline ("When do you think you'll have X ready?"). Use `[Insert X]` for any missing info. Don't quote the transcript.

- **Schedule a follow-up meeting** — Offer when the discussion clearly needs continuation or a check-in was mentioned. Suggest what follow-up makes sense and a rough timeframe. Check free slots via `gm`. Create the event via `gm` if confirmed.

- **Examine what wasn't asked** — Offer for substantive meetings (strategy sessions, planning, decision-making meetings). Ask: "What questions are you surprised weren't covered? What questions should you have been asking? What would have cut deeper into the topic? If you had 15 more minutes, what would be most incisive to tackle?"

- **Run a deeper risk analysis** — Offer for meetings involving plans, proposals, or significant decisions. "Want me to run a blind spots analysis on what was discussed?" This triggers `/cos:blindspots` in post-meeting mode.

## When No Transcript is Available

If the user runs /debrief but there's no transcript:
1. Ask "What meeting did you just come out of?"
2. Ask "What were the key outcomes?"
3. Prompt for: "Any action items for you? For others? Any decisions made?"
4. Process whatever they provide through the same extraction and filing pipeline
