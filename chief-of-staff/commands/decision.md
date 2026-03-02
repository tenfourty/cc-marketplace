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
- `/decision help` — active decision coaching with framework selection
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

### Write to kbx

Log the decision as a kbx note:

```bash
kbx memory add "Decision Title" --body "structured markdown" --tags decision
```

If person-related, also link to the entity:
```bash
kbx memory add "Decision Title" --body "structured markdown" --tags decision --entity "Name"
```

The structured markdown body should follow this format:
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
- Create follow-up tasks: `gm tasks create --title "..." --tag Active --list LIST --due ISO --description "..."`
  - **Project linking:** Include `project: <ProjectName>` in the description if the task relates to a known kbx project
- Update initiatives: `kbx memory add "Initiative update" --entity "Project Name" --tags initiative` if applicable

## Recalling Decisions

When the user asks to recall:

### 1. Search
- `kbx search "topic" --fast --json` for keyword match
- `kbx search "topic" --json` for semantic match
- `kbx note list --tag decision --json` for all decision notes
- `kbx search "topic decision" --from YYYY-MM-DD --json` for decisions in meeting transcripts
- Slack MCP for decision-related threads
- Notion MCP if kbx returns nothing relevant

### 2. Present
Show decisions in reverse chronological order:

```
## Decisions on: [Topic]

### [Date] — [Decision Title]
[Full decision record from kbx]

### [Earlier Date] — [Related Decision]
[Full decision record]
```

### 3. Coach Voice Analysis (for recall)
When showing past decisions, add:
- **Pattern:** "You've made 3 decisions on this topic in 2 months. Is the framing right?"
- **Trajectory:** "This decision reversed one from [date]. What changed?"
- **Open items:** "The action items from this decision are still in gm tasks — are they done?"
- **Revisit flag:** "You said to revisit this by [date]. That's [past due / coming up]."

## Helping Decide

When the user runs `/decision help` or `/decision help <topic>`:

### 1. Identify the Decision

**If a topic is provided:** Use it as the decision to work through.

**If no topic is provided:**
- Search recent meetings for undecided items: `kbx search "decision" --from YYYY-MM-DD --fast --json`
- Check for deferred decisions: `kbx search "revisit" --from YYYY-MM-DD --fast --json`
- Check gm tasks for items that imply pending decisions
- Identify **at least 3 big decisions** discussed recently. Summarise them briefly.
- From these, define the **largest, most important decision** and explain why.
- Ask if the executive agrees, or if they want to define the problem differently.

### 2. Frame the Problem

State clearly: **"Problem: [concise framing of the decision to be made]"**

### 3. Select a Framework

Cite three potential decision-making frameworks, each with one sentence describing why it might fit this situation. Choose from (and beyond — select what's most appropriate for the specific problem):

**Structured frameworks:**
- CSD Matrix (Certainties, Suppositions, Doubts)
- SWOT Analysis (Strengths, Weaknesses, Opportunities, Threats)
- Eisenhower Matrix (Urgent vs Important)
- RAPID (Recommend, Agree, Perform, Input, Decide)
- Decision Matrix / Weighted scoring
- Pre-Mortem Analysis (assume failure, work backwards)
- Golden Circle (Why, How, What)
- Six Thinking Hats (de Bono)

**Social science theories** (use when relevant):
- Prospect Theory (loss aversion in decision framing)
- Diffusion of Innovations (adoption and change management)
- Organisational Decision Making Theory
- Social Judgment Theory
- First Principles Thinking

Pick the **one most appropriate** for this specific situation and explain why.

### 4. Walk Through the Framework

Take the chosen framework and go step by step through it, using short, direct, conversational language. Apply it specifically to the executive's decision — not generic guidance, but concrete analysis using the data you have.

Use the McChrystal framework components (Clarity, Inputs, People, Decision, Outcome) as a cross-check alongside the chosen framework to ensure nothing is missed.

### 5. Deliver a Recommendation

After working through the framework:
- State a clear recommendation (or present the top 2 options with your lean)
- Explain the rationale in 2-3 sentences
- Note what would change your recommendation
- Suggest a revisit date if the decision has a time horizon

### 6. Further Reading

Cite 2-3 blog posts, articles, books, or resources that could help go deeper on:
- The specific problem domain
- The chosen framework
- Decision-making in similar contexts

Include descriptions but not invented URLs. Reference publications like Harvard Business Review, specific books, or well-known frameworks.

## Quick Log

If the user just says something like "we decided to go with option B on the API migration", capture it efficiently:
1. Log the decision with whatever context is available via `kbx memory add --tags decision`
2. Ask briefly: "Who decided? Any alternatives considered? When should we revisit?"
3. Don't block on getting perfect data -- a logged decision with gaps is better than an unlogged one
