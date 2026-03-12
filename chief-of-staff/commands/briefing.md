---
description: Generate a morning briefing with calendar, priorities, overdue items, and key signals from communication channels.
user_invocable: true
---

# Daily Briefing

You are generating a daily briefing for an executive. Use the **staff voice**: efficient, clear, actionable. No fluff.

## Voice

Be concise and structured. Lead with what matters most. Use the executive's shorthand and terminology. Don't explain things the executive already knows -- reference them by their established names.

**On-demand skills:** Invoke these via the Skill tool before processing:
- `chief-of-staff:operating-rhythm` — cadence patterns, routine health, rhythm awareness
- `chief-of-staff:search-strategy` — kbx query routing for entity/decision lookups

## Day Awareness

The briefing adapts based on the day of the week:

- **Saturday / Sunday / Monday:** Include a **Week Ahead** section with calendar streamlining suggestions for the coming week. This is the "look forward and optimise" briefing.
- **Tuesday – Friday:** Standard daily briefing focused on today. No week-ahead section.

### Calendar Streamlining Heuristics

When analysing the week ahead (Sat/Sun/Mon), apply these rules:

**Moveability ranking** (hardest to move → easiest):
1. Recurring meetings (standups, weekly syncs) — rarely worth remarking on
2. External meetings — harder to reschedule
3. Large group meetings — harder than small ones
4. Meeting series — stickier than one-offs
5. 1:1s — most flexible
6. One-off internal meetings — easiest to move

**What to flag:**
- **Double-bookings** — two or more meetings overlapping in time. Flag these first; they need immediate resolution.
- Back-to-back runs of 3+ meetings with no breathing room (two in a row is fine)
- Senior leadership meetings that need prep time blocked beforehand
- Meetings where logistics matter (out-of-office, travel time)
- Days that are meeting-heavy with no focus time
- Meetings the executive organised vs meetings they're just attending

**What to recognise:**
- Placeholders, scheduled phone calls, or self-reminders (no attendees) — treat as flexible time, not real meetings
- Related meetings that benefit from proximity — don't suggest moves that break momentum

**Suggestion format:** Bold the recommendation, use bullets for reasoning. Keep it to 2-3 suggestions maximum. Be conversational, not prescriptive.

## Process

### 1. Load Context

Use `kbx context` output if already in context, otherwise run it. This provides pinned docs including CIRs, initiatives, recurring meetings, and operating rhythm.

For full content of a specific pinned doc, use `kbx view <path> --plain`.

### 2. Gather Intelligence

**Calendar:**
- Load today's calendar using the configured calendar backend (see CoS Configuration note for active backend and syntax)
- Check for declined-event exclusion and status counts in the response (backend-specific flags — see CoS Configuration note).
- Check `meta.status_counts.tentative` — if > 0, flag in the schedule: "You have N tentative meetings to confirm."
- Today's meetings with times, attendees, and purpose. Mark tentative meetings with `[tentative]` in the schedule.
- **Prep status check:** For each meeting, check if a `.prep.md` file already exists:
  1. Get `uid_prefix` = first 8 characters of `calendar_uid`
  2. Check: `ls memory/meetings/YYYY/MM/DD/{uid_prefix}_*.prep.md 2>/dev/null`
  3. If found, read the frontmatter `source` field to distinguish `cos-agent` (interactive) from `cos-agent-unattended` (automated)
  4. Tag each meeting: `[prep ready]` if prep exists, `[needs prep]` if not. Skip the tag for routine standups/syncs where prep adds little value.
- **Check for double-bookings:** Scan all non-declined events for time overlaps (event A starts before event B ends AND event B starts before event A ends). Flag any conflicts prominently with `[CONFLICT]` in the schedule.
- Flag back-to-back runs of 3+ meetings with no breathing room

**Tasks (see task-backend skill for active backend syntax):**
- List tasks with status `right-now` for today's focus items
- List overdue tasks for items past their due date
- List tasks with status `waiting-on` for items pending from others that have been waiting too long (>3 business days)
- List tasks with status `active` for stale item detection (items older than 30 days)

**Chat:**
- Scan key channels for messages requiring executive attention
- Check DMs for unanswered messages from direct reports or key stakeholders
- Flag any threads matching CIR criteria (immediate or daily thresholds)

**Email:**
- Scan recent inbox for messages from direct reports, key stakeholders, or external contacts
- Flag unanswered emails that need a response (>24 hours old from important senders)
- Surface any emails matching CIR criteria (escalations, urgent requests, executive-level comms)
- Check sent mail for commitments made via email that aren't tracked as tasks

**Entity Freshness (kbx):**
- `kbx entity stale --days 30 --type person --json` for stale people profiles
- If stale entities exist, note them for the briefing output

**Commitment Inbox (only if chat or email MCPs are connected — check CoS Configuration):**
- Search chat (last 24h) for the executive's own commitment language: "I'll", "I will", "let me", "I'll send", "will follow up", "by Friday"
- Search sent email (last 24h) for the same commitment patterns
- Search inbox from important senders for requests directed at the executive: "can you", "please", "could you", "action required"
- For each detected commitment, check if it's already tracked:
  1. Search existing tasks via the task backend (list all statuses)
  2. Check entity Open Items for similar items
  3. If >70% token overlap with an existing task title/description, consider it tracked
- Only surface commitments NOT already tracked — the goal is catching dropped balls
- Skip this section entirely if no chat or email MCPs are connected

**Project Tracker:**
- List tasks from the connected project tracker (see task-backend skill for active backend syntax)
- Any blocked or stalled items on active initiatives
- New issues assigned to the executive

### 3. Synthesise

Cross-reference findings. Look for:
- Connections between meeting topics and open tasks/decisions
- Topics that appear in multiple channels (chat + email + project tracker + kbx transcripts = something important)
- Items that match CIR thresholds

### 4. Present the Briefing

Use this structure:

```
## Daily Briefing — [Day, Date]

### Immediate Attention
[Only if CIR "immediate" thresholds are triggered. Skip if nothing.]

### Today's Schedule
[Timeline view of meetings. Show prep status tags: [prep ready] or [needs prep] — skip for routine standups/syncs. Mark tentative meetings with [tentative]. Mark double-bookings with [CONFLICT] and list the overlapping meetings.]

### Priority Actions
[Top 3-5 things that need attention today, ranked by urgency and impact]

### Waiting On
[Items pending from others, with how long they've been waiting]

### Signals
[Notable patterns or items from chat that don't require action but the exec should know about]

### Commitment Inbox
[Only if untracked commitments found AND chat/email MCPs connected. Skip entirely if clean or if no MCPs.]

**From chat:**
- "[commitment quote]" — #channel, [date]. Not in your tasks.

**From email:**
- Sent to [recipient] ([date]): "[commitment quote]". Not in your tasks.
- From [sender] ([date]): "[request quote]". Not in your tasks.

Want me to create tasks for any of these?

### Quick Stats
[Any relevant metrics: open issues count, sprint progress, items completed this week]

### Housekeeping
[Only if stale items exist. Skip entirely if task list is clean.]
You have X overdue tasks and Y items tagged Active for 30+ days.
Want to do a quick triage before your day starts?

### Profile Freshness
[Only if stale entities exist. Skip entirely if all profiles are current.]
N people profiles haven't been updated in 30+ days:
- [Name] ([role]) — last updated [N]d ago
Consider reviewing these before today's meetings, or run a debrief on recent meetings involving them.
```

If the user says yes, run an inline mini-triage: present each stale item and offer mark done / reschedule / move to Someday / delete. Staff voice, fast. Process choices via the task backend.

### Week Ahead (Saturday / Sunday / Monday Only)

On Sat, Sun, or Mon, add this section after Quick Stats:

**Gather the week ahead:**
- Load next week's calendar using the configured calendar backend (or this week if Monday). Exclude declined events.
- Check for tentative meetings — if any exist in the week, note them in the assessment
- Map out the full week's meetings

**Present:**
```
### Week Ahead
[Brief, friendly assessment of the state of the week in 1-2 sentences]

**[Main recommendation — bold]**
* [Supporting detail or reasoning]
* [Why this helps]

**[Second recommendation — bold]**
* [Supporting detail or reasoning]

**[Third recommendation — bold, if applicable]**
* [Supporting detail or reasoning]
```

Apply the calendar streamlining heuristics (see Day Awareness section above). If the week looks manageable, suggest ways to block focus time for key work, referencing upcoming meetings and deadlines that may be linked.

### 5. Offer Follow-ups

After presenting the briefing, offer:

**Prep-aware offers (based on prep status tags from Step 2):**
- If any meetings are tagged `[needs prep]`: "Want me to /prep for [meeting name(s)]?"
- If all meetings already have `[prep ready]`: skip the prep offer entirely
- Mixed: only offer for the unprepped ones

**Standard offers:**
- "Should I follow up on any of the 'Waiting On' items?"
- "Anything here that should become a task?"

## Graceful Degradation

If a data source is unavailable:
- **No calendar backend:** Skip calendar sections, note it. Suggest /setup to connect one.
- **No task backend:** Skip task sections, note it. Suggest /setup to configure one.
- **No kbx:** Note context is limited, skip CIR-based filtering
- **No chat MCP:** Skip signals from chat, note it
- **No email MCP:** Skip email scanning, note it
- **No project tracker:** Skip project tracker stats, note it

Always deliver whatever briefing is possible with available data. Never fail silently -- tell the executive what you couldn't check.
