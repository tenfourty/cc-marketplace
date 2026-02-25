---
description: List your outstanding action items and commitments others owe you from recent meetings. Creates gm tasks for tracking.
user_invocable: true
---

# Todos

You are scanning recent meetings to surface what the executive has committed to and what others have committed to them. Use the **staff voice**: precise, scannable, actionable.

## Process

### 1. Gather Meeting Data

Search recent meetings in reverse chronological order:
- `kbx search "action item" --from YYYY-MM-DD --fast --json --limit 20` (last 7-10 days)
- `kbx search "I will" --from YYYY-MM-DD --fast --json --limit 10`
- `kbx search "follow up" --from YYYY-MM-DD --fast --json --limit 10`
- `kbx search "send" --from YYYY-MM-DD --fast --json --limit 10`
- Broader `kbx search` for recent transcripts to scan

For each relevant meeting found, read the transcript: `kbx view <path> --plain`

Also check:
- `gm tasks list --json --response-format concise` to cross-reference against already-tracked items

### 2. Extract Action Items

For each meeting transcript, extract two categories:

**Executive's commitments (Your Action Items):**
- Explicit: "I'll do X", "I will handle X", "[Executive] to do X"
- Implicit: "We should update docs" (where the executive is likely responsible based on context and role)
- Include deadlines only where they were actually promised

**Others' commitments (Owed to You):**
- "Sarah will send the report by Friday"
- "Marcus said he'd look into the pricing issue"
- Include who committed, what they committed to, and any stated deadline

### Action Item Definition

An action item is a **future commitment** — a task to be done after the meeting. It is NOT a status update.

| Pattern | Action item? |
|---|---|
| "I am doing X" (current work / progress update) | **No** — status update |
| "I will do X" / "I'll handle X" (new commitment) | **Yes — explicit** |
| "We should do X" (group suggestion, executive likely responsible) | **Yes — inferred** |
| "Can you check on X?" (directed at executive) | **Yes — explicit** |
| "Let me look into that" / "I'll get back to you" (soft commitment) | **Yes — explicit** |
| Clearly assigned to someone else | **No** — goes in "Owed to You" |

Be thoughtful about this distinction, especially in standups or project updates where people speak about ongoing work they will continue to do. Err on the side of inclusion if it is likely the executive's responsibility based on their role and context.

### 3. Cross-Reference

Check each item against existing gm tasks:
- Already tracked? → Note it, don't duplicate
- Updates an existing task? → Note the update needed
- Entirely new? → Flag for creation

### 4. Present

Add a short intro line: *"Here are your recent action items and commitments, organised by meeting:"*

Group by day, most recent first.

```
## Your Action Items

### [Day — e.g., Today, Yesterday, Monday 24 Feb]

**[Meeting Name]**
* [Explicit action item] — due [date if stated]
* [Inferred action item] *(inferred)*

**[Meeting Name]**
* No action items found

---

## Owed to You

### [Day]

**[Meeting Name]**
* [Person]: [What they committed to] — due [date if stated]

**[Meeting Name]**
* No commitments found
```

### Formatting Rules

- Use `*` bullets, one per item
- Bold the meeting name
- If a meeting has no items, write "No action items found" or "No commitments found"
- Keep phrasing short and actionable: "Send draft contract" not "I said I'd probably send a contract"
- Tag inferred items with *(inferred)*
- Include deadlines only where they were actually stated
- Never output `* -` or empty bullets
- If a meeting has no title, use **Unnamed Meeting**

### 5. Pagination

Show the most recent calendar day of meetings first. If that's fewer than 5 meetings, include earlier days until at least 5 meetings are shown.

- Never split a day across outputs. If showing any meeting from a day, include all meetings from that day.
- After finishing a day (and reaching 5+ meetings), ask: "Want me to keep going with previous days?"
- When continuing, deliver meetings in complete day chunks.
- Keep track of which meetings have already been displayed — never repeat them.

### 6. Create Tasks

After presenting, ask:

> "Want me to create gm tasks for these? Your items will be tagged Active, others' commitments will be tagged Waiting-On."

If yes:
- Executive's items: `gm tasks create --title "..." --tag Active --list LIST --due ISO`
- Others' commitments: `gm tasks create --title "[Person]: [Action]" --tag Waiting-On --list LIST --due ISO`
- Skip items that are already tracked in gm
- Choose the appropriate list (Leadership, People, Ops, Admin) based on the item's context

## Date Handling

- Anchor to today's date as the fixed reference point
- Resolve relative references: if a transcript says "today", "yesterday", or a weekday, resolve to the actual calendar date of that meeting
- Assume items mentioned more than ~7 business days ago may be done unless they appear again as unresolved
- Prioritise freshness: always surface what's new first; include older items only if they remain clearly active
- Check for completion: tasks mentioned in older meetings may have been resolved since

## Self-Check

Before final output:
- Re-read extracted items and confirm no commitments were skipped
- Confirm no `* -` formatting errors exist
- Verify explicit vs inferred distinction is correct for each item
