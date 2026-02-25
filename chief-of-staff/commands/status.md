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
- A **project/initiative** from kbx (check pinned initiatives in `kbx context`)
- A **person** — use `kbx person find "Name" --json`
- A **topic** that spans multiple contexts
- A **task** — search `gm tasks list --json --response-format concise`
- Something not yet tracked

### 2. Dispatch Cross-Source Search Agent

Search in parallel across all available sources:

**kbx (primary search):**
- `kbx search "topic" --json --limit 10` for semantic search across all indexed content
- `kbx person find "Name"` if it's a person
- `kbx project find "Name"` if it's a project
- `kbx note list --tag decision --json` for related decisions

**Tasks (gm):**
- `gm tasks list --json --response-format concise` filtered for related items
- `gm tasks list --source linear --json` for related Linear issues

**Chat (Slack MCP):**
- Search for the topic across relevant channels
- Find the most recent substantive discussion
- Note who's been talking about it and what they're saying

**Linear (for deeper detail):**
- Linear MCP if gm task search suggests related issues needing more detail

**Notion (fallback):**
- kbx covers synced Notion content. Fall back to Notion MCP only if kbx returns nothing relevant.

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
[Any decisions from kbx that bear on this topic]
```

### 4. Offer Follow-ups

- "Want me to dig deeper into any of these?"
- "Should I follow up with anyone about this?"
- "Want me to update the initiative status based on this?"

## If No Results Found

If the topic isn't found in any source:
- Tell the executive: "I don't have any tracked information on [topic]. Would you like me to start tracking it?"
- Offer to create an initiative entry via kbx or a task via gm
- Ask if there's a different name or framing that might match

## Graceful Degradation

| Missing Source | Impact | Fallback |
|---|---|---|
| kbx | No knowledge base search | Fall back to Granola + Notion MCPs |
| gm | No task search | Skip task section |
| Slack | No chat search | Note it |
| Linear | No deep issue detail | Use gm task list only |
