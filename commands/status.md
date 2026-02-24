---
description: Cross-source status check on a topic, project, person, or initiative. Usage: /status <topic>
user_invocable: true
args: topic
---

# Status Check

You are running a cross-source status check. Use the **staff voice**: fast, factual, comprehensive. The executive wants to know "what's the state of X?" and you should answer from every available source.

**Input:** A topic, project name, person name, initiative, or any query. Examples:
- `/status Project Atlas`
- `/status Sarah's onboarding`
- `/status the migration`
- `/status board deck`

## Process

### 1. Understand the Query

Parse what the user is asking about. It could be:
- A **project/initiative** from memory/priorities/initiatives.md
- A **person** from memory/people/
- A **topic** that spans multiple contexts
- A **task** from TASKS.md
- Something not yet tracked

### 2. Dispatch Cross-Source Search Agent

Search in parallel across all available sources:

**Internal Memory:**
- TASKS.md for related tasks and their status
- memory/decisions/ for related decisions
- memory/priorities/initiatives.md for initiative status
- memory/people/ for person context

**Chat (~~chat):**
- Search for the topic across relevant channels
- Find the most recent substantive discussion
- Note who's been talking about it and what they're saying

**Meeting Transcripts (~~meeting transcripts):**
- Search for when this topic was last discussed in a meeting
- What was said, decided, or committed to

**Project Tracker (~~project tracker):**
- Related issues/items, their status
- Recent activity (comments, status changes)
- Any blockers

**Knowledge Base (~~knowledge base):**
- Related documents or pages
- Recent updates to documentation

### 3. Present the Status

```
## Status: [Topic]

### Summary
[2-3 sentence summary of current state]

### Key Facts
- **Last discussed:** [when and where]
- **Current state:** [status from project tracker or most recent signal]
- **Owner:** [who's responsible]
- **Next milestone:** [if applicable]

### Recent Activity
[Timeline of recent relevant events across sources, most recent first]
- [Date] — [Source] — [What happened]

### Open Items
[Related tasks, action items, or pending decisions]

### Related Decisions
[Any decisions from memory/decisions/ that bear on this topic]
```

### 4. Offer Follow-ups

- "Want me to dig deeper into any of these?"
- "Should I follow up with anyone about this?"
- "Want me to update the initiative status based on this?"

## If No Results Found

If the topic isn't found in any source:
- Tell the executive: "I don't have any tracked information on [topic]. Would you like me to start tracking it?"
- Offer to create an initiative entry, task, or memory file
- Ask if there's a different name or framing that might match
