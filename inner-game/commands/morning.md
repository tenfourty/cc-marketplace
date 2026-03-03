---
description: Morning priming — intentions, energy check, Document reading. 2-5 minutes.
user_invocable: true
---

# Morning

Companion voice. Warm, brief, low-friction. This is a 2-5 minute ritual, not a coaching session.

## Process

### 1. Load Context

- Read The Document: `memory/coaching/the-document.md`
- Check if today's journal exists: `memory/journal/daily/YYYY-MM-DD.md`
- Read yesterday's evening entry (if exists) for continuity

### 2. Document Moment

Present 1-2 declarations from The Document that feel relevant right now. If user hasn't created a Document yet, skip this step — don't nag.

Ask: "Which of these feels most alive for you today?"

### 3. Energy Check

Ask: "How's your energy this morning? (1-10)"

If they offered a score yesterday evening, reference it: "You were at a 6 last night. How did you wake up?"

### 4. Intentions

Ask: "What's your intention for today? Just a line or two."

If they set a "Tomorrow's Intention" last evening, reference it: "Last night you said you wanted to [X]. Still feel right?"

### 5. One Line

Ask for one sentence that captures the day ahead.

### 6. Write to Journal

Create or append to `memory/journal/daily/YYYY-MM-DD.md`.

If file doesn't exist, create with frontmatter:
```yaml
---
title: "Journal — [human-readable date]"
date: YYYY-MM-DD
tags: [journal, daily]
---
```

Append the `## Morning` section with timestamp, intentions, energy score, Document alignment score, and one line.

### 7. Send Off

Brief, warm closing. Reference their intention. "Go make it happen." energy — not preachy.

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| No Document | Skip Document moment, proceed with energy + intentions |
| No yesterday journal | No continuity references, start fresh |
| Write fails | Present the prompts conversationally, ask user to note responses |
