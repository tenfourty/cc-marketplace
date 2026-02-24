---
description: Generate a morning briefing with calendar, priorities, overdue items, and key signals from communication channels.
user_invocable: true
---

# Daily Briefing

You are generating a daily briefing for an executive. Use the **staff voice**: efficient, clear, actionable. No fluff.

## Voice

Be concise and structured. Lead with what matters most. Use the executive's shorthand and terminology from CLAUDE.md and memory/glossary.md. Don't explain things the executive already knows -- reference them by their established names.

## Process

### 1. Load Context
- Read CLAUDE.md for current priorities and CIRs
- Read memory/priorities/cirs.md for information requirements
- Read memory/priorities/initiatives.md for active initiatives
- Read TASKS.md for current task state

### 2. Gather Intelligence

**Calendar (~~calendar):**
- Today's meetings with times, attendees, and purpose
- Flag any meetings that need prep (check memory/meetings/recurring.md for prep requirements)
- Flag any scheduling conflicts or back-to-back stretches with no buffer

**Tasks (TASKS.md):**
- Items in "Active" that are overdue or due today
- Items in "Waiting On" that have been waiting too long (>3 business days)
- Any tasks added by the /debrief command since last briefing

**Chat (~~chat):**
- Scan key channels for messages requiring executive attention
- Check DMs for unanswered messages from direct reports or key stakeholders
- Flag any threads matching CIR criteria (immediate or daily thresholds)

**Project Tracker (~~project tracker):**
- Any blocked or stalled items on active initiatives
- New issues assigned to the executive
- Sprint/cycle status if relevant

### 3. Synthesise

Cross-reference findings. Look for:
- Connections between meeting topics and open tasks/decisions
- Topics that appear in multiple channels (Slack + Linear + transcripts = something important)
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
[Notable patterns or items from chat/email that don't require action but the exec should know about]

### Quick Stats
[Any relevant metrics: open issues count, sprint progress, items completed this week]
```

### 5. Offer Follow-ups

After presenting the briefing, offer:
- "Want me to /prep for any of today's meetings?"
- "Should I follow up on any of the 'Waiting On' items?"
- "Anything here that should become a task?"

## Graceful Degradation

If a data source is unavailable:
- **No calendar:** Skip schedule section, note it's unavailable
- **No chat:** Skip signals from chat, note it
- **No project tracker:** Skip sprint stats, note it
- **No transcripts:** Not needed for daily briefing

Always deliver whatever briefing is possible with available data. Never fail silently -- tell the executive what you couldn't check.
