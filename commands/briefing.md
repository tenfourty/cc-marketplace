---
description: Generate a morning briefing with calendar, priorities, overdue items, and key signals from communication channels.
user_invocable: true
---

# Daily Briefing

You are generating a daily briefing for an executive. Use the **staff voice**: efficient, clear, actionable. No fluff.

## Voice

Be concise and structured. Lead with what matters most. Use the executive's shorthand and terminology. Don't explain things the executive already knows -- reference them by their established names.

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

**Calendar (gm):**
- Use `gm today` output if already in context, otherwise run `gm today --json --response-format concise --no-frames`
- Today's meetings with times, attendees, and purpose
- Flag any meetings that need prep (check recurring meetings from kbx context)
- Flag any scheduling conflicts or back-to-back stretches with no buffer

**Tasks (gm):**
- `gm tasks list --tag Right-Now --json` for today's focus items
- `gm tasks list --overdue --json` for overdue items
- `gm tasks list --tag Waiting-On --json` for items pending from others that have been waiting too long (>3 business days)
- `gm tasks list --tag Active --json` for stale item detection (items older than 30 days)

**Chat (Slack MCP):**
- Scan key channels for messages requiring executive attention
- Check DMs for unanswered messages from direct reports or key stakeholders
- Flag any threads matching CIR criteria (immediate or daily thresholds)

**Project Tracker (gm + Linear):**
- `gm tasks list --source linear --json` for Linear task status
- Any blocked or stalled items on active initiatives
- New issues assigned to the executive

### 3. Synthesise

Cross-reference findings. Look for:
- Connections between meeting topics and open tasks/decisions
- Topics that appear in multiple channels (Slack + Linear + kbx transcripts = something important)
- Items that match CIR thresholds

### 4. Present the Briefing

Use this structure:

```
## Daily Briefing — [Day, Date]

### Immediate Attention
[Only if CIR "immediate" thresholds are triggered. Skip if nothing.]

### Today's Schedule
[Timeline view of meetings. Flag which need prep.]

### Priority Actions
[Top 3-5 things that need attention today, ranked by urgency and impact]

### Waiting On
[Items pending from others, with how long they've been waiting]

### Signals
[Notable patterns or items from chat that don't require action but the exec should know about]

### Quick Stats
[Any relevant metrics: open issues count, sprint progress, items completed this week]

### Housekeeping
[Only if stale items exist. Skip entirely if task list is clean.]
You have X overdue tasks and Y items tagged Active for 30+ days.
Want to do a quick triage before your day starts?
```

If the user says yes, run an inline mini-triage: present each stale item and offer mark done / reschedule / move to Someday / delete. Staff voice, fast. Process choices via `gm tasks` commands.

### Week Ahead (Saturday / Sunday / Monday Only)

On Sat, Sun, or Mon, add this section after Quick Stats:

**Gather the week ahead:**
- `gm next-week --json --response-format concise --no-frames` (or `gm this-week` if Monday)
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
- "Want me to /prep for any of today's meetings?"
- "Should I follow up on any of the 'Waiting On' items?"
- "Anything here that should become a task?"

## Graceful Degradation

If a data source is unavailable:
- **No gm:** Fall back to Calendar MCP if available, note tasks unavailable
- **No kbx:** Note context is limited, skip CIR-based filtering
- **No Slack:** Skip signals from chat, note it
- **No Linear:** Skip project tracker stats, note it

Always deliver whatever briefing is possible with available data. Never fail silently -- tell the executive what you couldn't check.
