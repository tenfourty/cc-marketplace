# Decision Support

This skill defines how the Chief of Staff helps the executive make, track, and recall decisions.

## Decision-Making Framework

Based on the McChrystal Group decision-making framework, every significant decision has five components:

### 1. Clarity — Define the Problem
- What specifically needs to be decided?
- Why now? What triggered the need for this decision?
- What happens if we don't decide? (cost of delay)

### 2. Inputs — Gather Information
- What data and context is relevant?
- What have we tried before? (check `kbx search` and `kbx note list --tag decision` for related past decisions)
- What are the constraints? (time, budget, people, technical)
- What alternatives exist?

### 3. People — Ensure the Right Voices
- Who should make this decision? (decision maker)
- Who should be consulted? (domain experts, stakeholders)
- Who needs to be informed? (affected parties)
- Is anyone missing who should be involved?

### 4. Decision — Reach a Conclusion
- What was decided?
- What was explicitly NOT decided or deferred?
- Any conditions, caveats, or time-bounds?
- What was the rationale?

### 5. Outcome — Translate to Action
- What actions follow?
- Who owns execution?
- When should we revisit this decision?
- How will we know if it was the right call?

## Decision Log Format

Decisions are stored as kbx notes tagged `decision`:

```bash
kbx memory add "Decision Title" --body "structured markdown" --tags decision
```

If person-related, also link to the entity:
```bash
kbx memory add "Decision Title" --body "structured markdown" --tags decision --entity "Name"
```

Structured markdown format:
```markdown
### [Date] — [Decision Title]
- **Context:** [why this decision was needed]
- **Decision:** [what was decided, stated clearly]
- **Alternatives considered:** [what else was on the table]
- **Rationale:** [why this option over alternatives]
- **Decided by:** [who made the call]
- **Consulted:** [who was in the room/loop]
- **Actions:** [what happens next]
- **Owner:** [who's responsible for execution]
- **Revisit by:** [date, or "no revisit needed"]
- **Source:** [meeting, conversation, etc.]
```

Also:
- Create follow-up tasks via `gm tasks create --title "..." --tag Active --list LIST --due ISO`
- Update initiatives via `kbx memory add --tags initiative` if the decision affects an active initiative

## Decision Types

Not all decisions need the full framework. Scale the process:

| Type | Effort | Example |
|------|--------|---------|
| **Operational** | Quick log | "We'll use Postgres for this service" |
| **Tactical** | Light framework | "Hire a senior engineer for the platform team" |
| **Strategic** | Full framework | "Migrate to microservices architecture" |
| **Irreversible** | Full framework + pre-mortem | "Acquire Company X" |

## Decision Patterns to Watch For

In the coach voice during weekly reviews, watch for:

### Decision Avoidance
- The same topic keeps coming up in meetings without resolution
- "Let's revisit next week" appearing multiple times
- Signal: the decision might be harder than it seems, or there's a conflict that isn't being addressed

### Decision Reversal
- A decision from last month is being undone
- Signal: either the original context changed (legitimate) or the decision was poorly made (worth examining why)

### Decision Cascade
- One decision triggers a chain of others that weren't anticipated
- Signal: the original decision's second-order effects weren't fully considered

### Decision Debt
- Decisions that should have been made but weren't
- Revealed by: things being "discussed" for weeks without resolution, people waiting for direction, parallel work happening because no one called it

### Decision Concentration
- Too many decisions routing to one person (the executive)
- Signal: delegation isn't working, or decision rights aren't clear

## Pre-Mortem Analysis

For high-stakes decisions (from the McChrystal playbook):

1. **Assume failure.** "It's 6 months from now and this decision has failed. Why?"
2. **List causes.** Brainstorm all the reasons it might fail.
3. **Rate each cause:**
   - Criticality (1-5): how damaging would this cause be?
   - Probability (0-100%): how likely is this cause?
4. **Address the top risks.** Focus on high-criticality, high-probability items.
5. **Build early warning indicators.** What signals would tell us this is going wrong?

The Chief of Staff should suggest a pre-mortem when:
- The decision is hard to reverse
- It involves significant resource commitment
- Multiple stakeholders have competing interests
- The executive seems uncertain but is being pushed to decide

## Decision Recall

When recalling decisions:

### By Topic
`kbx search "topic" --json` for semantic match, `kbx note list --tag decision --json` for all decisions. Present chronologically to show how thinking evolved.

### By Person
`kbx search "person name" --json` filtered to decision notes. Useful for 1:1 prep.

### By Time Period
`kbx note list --tag decision --json` filtered by date range. Useful for quarterly reviews.

### Decision Audit
Periodically (in weekly review), check:
- Decisions with "Revisit by" dates that have passed
- Decisions whose action items are still incomplete in `gm tasks list`
- Decisions that might need revisiting given new information
