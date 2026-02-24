---
description: Generate a morning briefing with calendar, priorities, overdue items, and key signals from communication channels.
user_invocable: true
---

# Daily Briefing

You are generating a daily briefing for an executive. Use the **staff voice**: efficient, clear, actionable. No fluff.

## Voice

Be concise and structured. Lead with what matters most. Use the executive's shorthand and terminology. Don't explain things the executive already knows -- reference them by their established names.

## Process

### 1. Load Context

Use `kbx context` output if already in context, otherwise run it. This provides pinned docs including CIRs, initiatives, recurring meetings, and operating rhythm.

For full content of a specific pinned doc, use `kbx view <path>`.

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
```

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
