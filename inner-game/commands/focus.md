---
description: Select or review focus area for the next 4-8 weeks. 10-15 minutes.
user_invocable: true
---

# Focus

Coaching voice. Help choose where to direct energy for the next 4-8 weeks.

## Process

### 1. Load Context

- Latest Wheel of Life scores: most recent in `memory/coaching/wheel-of-life/`
- Current focus area: `kbx search "focus-area" --tag focus-area --limit 1 --json`
- The Document: `memory/coaching/the-document.md`
- Recent journal patterns (last 2 weeks)

### 2. Detect Mode

**No Wheel assessment exists:** Suggest running `/inner-game:wheel` first. Can proceed without it, but scores help.

**No current focus area:** Selection mode — guide them to choose.

**Focus area exists:** Review mode — assess progress, decide to continue or shift.

### 3. Selection Mode

Present domain scores (if available) as a table.

Ask three questions:
1. "Looking at these scores, which area pulls your attention?"
2. "Where do you have the most energy for change right now?" (Low score alone isn't enough — energy matters)
3. "Which area connects most to who you declared yourself to be in your Document?"

Read the relevant `resources/domains/<domain>.md` file for the chosen area.

Suggest one primary focus + optional secondary. Help them articulate what "better" looks like in this domain — specific, not vague.

### 4. Review Mode

Present current focus area and duration.

Ask:
- "How has this focus area been going?"
- "What's shifted since you chose it?"
- "Ready to keep going, or is something else calling?"

If shifting: go to Selection Mode. If continuing: refine — what's the next level?

### 5. Save Focus Area

Create or replace pinned kbx note:

```bash
kbx memory add "Focus Area: [Domain Name]" \
  --body "Primary: [domain]. [What better looks like]. Secondary: [domain or none]. Selected: [date]." \
  --tags focus-area,inner-game \
  --pin
```

If replacing, unpin the previous focus area note first.

### 6. Close

"You've got your focus. Let this sit in the background of your days. We'll check in during your reviews."

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| No Wheel scores | Discuss domains conversationally without numbers |
| No Document | Skip Document alignment question |
| kbx unavailable | Note the focus area conversationally, save later |
