---
description: Log a new decision or recall past decisions on a topic. Usage: /decision [log|recall] <topic>
user_invocable: true
args: action_and_topic
---

# Decision Management

You manage the executive's decision log. Use the **staff voice** for logging, **coach voice** when recalling decisions to highlight patterns.

**Usage:**
- `/decision log` — interactively log a decision
- `/decision recall <topic>` — find past decisions on a topic
- `/decision` — ask what the user wants to do

## Logging a Decision

Follow the McChrystal Group decision-making framework. Ask for (or extract from context):

### 1. Get the Clarity
- **What was the decision?** (one clear sentence)
- **What was the context/problem being solved?**

### 2. Get the Inputs
- **What information informed this decision?**
- **What alternatives were considered?**

### 3. Get the People
- **Who made the decision?**
- **Who was consulted?**
- **Who needs to know?**

### 4. Get the Decision
- **What was decided?** (restate clearly)
- **Any conditions, caveats, or time-bounds?**
- **What was explicitly NOT decided / deferred?**

### 5. Get the Outcome
- **What actions follow from this decision?**
- **Who owns execution?**
- **When should we revisit this?**

### Write to Decision Log

Append to `memory/decisions/YYYY-MM.md`:

```markdown
### [Date] — [Decision Title]
- **Context:** [why this decision was needed]
- **Decision:** [what was decided]
- **Alternatives considered:** [what else was on the table]
- **Rationale:** [why this option was chosen]
- **Decided by:** [who]
- **Consulted:** [who was in the room/loop]
- **Actions:** [what happens next]
- **Owner:** [who executes]
- **Revisit by:** [date, if applicable]
- **Source:** [meeting name, conversation, etc.]
```

Also:
- Update TASKS.md if the decision creates action items
- Update memory/priorities/initiatives.md if it affects an initiative
- Update CLAUDE.md hot cache if it's a high-impact decision

## Recalling Decisions

When the user asks to recall:

### 1. Search
- Search memory/decisions/ for the topic
- Search ~~meeting transcripts for decisions discussed in meetings
- Search ~~chat for decision-related threads
- Search ~~knowledge base for decision docs

### 2. Present
Show decisions in reverse chronological order:

```
## Decisions on: [Topic]

### [Date] — [Decision Title]
[Full decision record from the log]

### [Earlier Date] — [Related Decision]
[Full decision record]
```

### 3. Coach Voice Analysis (for recall)
When showing past decisions, add:
- **Pattern:** "You've made 3 decisions on this topic in 2 months. Is the framing right?"
- **Trajectory:** "This decision reversed one from [date]. What changed?"
- **Open items:** "The action items from this decision are still in TASKS.md — are they done?"
- **Revisit flag:** "You said to revisit this by [date]. That's [past due / coming up]."

## Quick Log

If the user just says something like "we decided to go with option B on the API migration", capture it efficiently:
1. Log the decision with whatever context is available
2. Ask briefly: "Who decided? Any alternatives considered? When should we revisit?"
3. Don't block on getting perfect data -- a logged decision with gaps is better than an unlogged one
