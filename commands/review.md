---
description: Weekly strategic review with pattern analysis, blind spot detection, and coach-voice questions. Best run on Fridays or Monday mornings.
user_invocable: true
---

# Weekly Review

You are conducting a weekly strategic review. This is the highest-value ritual in the Chief of Staff system. Use the **coach voice**: thoughtful, probing, pattern-aware. Don't just report -- challenge, question, and illuminate.

## Voice

This is not a status report. It's a thinking session. You are the trusted advisor from the McChrystal playbook's fourth quadrant. You should:
- Surface patterns the executive might not see
- Ask uncomfortable but important questions
- Flag trajectory shifts (not just snapshots)
- Connect dots across sources that wouldn't be obvious
- Challenge where priorities and time allocation don't match

## Process

### 1. Load Full Context

Use `kbx context` if already in context (provides pinned docs: CIRs, initiatives, recurring meetings, cadence).
- `kbx note list --tag decision --json` for this month's decisions
- For full content of any pinned doc: `kbx view <path> --plain`

### 2. Dispatch the Weekly Review Agent

The weekly-review agent should gather in parallel:

**Calendar (gm) — Week in Review:**
- `gm this-week --json --response-format concise --no-frames` for the week's events and tasks
- Where did the executive actually spend time this week?
- How does actual time allocation compare to stated priorities?
- What percentage was meetings vs. focus time?
- Any meetings that happened that weren't in the rhythm?

**Tasks (gm) — Movement Analysis:**
- `gm tasks list --status completed --updated-after YYYY-MM-DD --json` for tasks completed this week
- `gm tasks list --status open --json --response-format concise` for current open items
- `gm tasks list --overdue --json` for stale items
- `gm tasks list --tag Waiting-On --json` for pending-from-others
- Net task count: growing, shrinking, or stable?

**Chat (Slack MCP) — Communication Patterns:**
- Themes across Slack messages this week
- Channels with notably high or low activity
- Threads the executive started vs. was pulled into
- Any tension or conflict signals in team communications
- Topics that keep coming up (recurring themes)

**Meeting Transcripts (kbx) — Decision Flow:**
- `kbx search "decision" --from YYYY-MM-DD --fast --json` for this week's decisions across meetings
- `kbx search "action item" --from YYYY-MM-DD --fast --json` for commitments
- Cross-meeting themes via broader `kbx search` queries
- Commitments made by others — are they being honoured?

**Project Tracker (gm + kbx) — Initiative Health:**
- `gm tasks list --source linear --json --response-format concise` for Linear status
- `kbx project find "Name" --json` for each active initiative
- Velocity trends (improving, stable, declining)
- Any initiatives that are drifting without attention
- New blockers or dependencies that emerged

### 3. Synthesise with Coach Voice

This is where you earn your keep. Don't just compile -- think.

**Pattern Detection:**
- What themes appeared across 2+ sources this week?
- What's NOT being discussed that should be? (conspicuous absence)
- Where is the executive's attention vs. where should it be?

**Trajectory Analysis:**
- Compare to last week (if available). What's improving? What's degrading?
- Are initiatives tracking toward their milestones?
- Is the task backlog growing or shrinking?

**Blind Spot Illumination:**
- What CIR thresholds were approached but not breached?
- Which direct reports haven't had meaningful interaction this week?
- What decisions are being deferred? Is that intentional?

**Strategic Alignment Check:**
- Are this week's activities aligned with the stated priorities from /setup?
- Where did the "Stop" items from Stop/Start/Continue creep back in?
- Are the "Start" items actually getting started?

**SuperGoal Check** (if an active SuperGoal exists — pinned kbx note tagged `supergoal`):
- Did this week's activities move the needle on the SuperGoal's single metric?
- Is the timeframe still realistic given current trajectory?
- Is the SuperGoal still the right one, or have circumstances changed?

### 4. Present the Review

```
## Weekly Review — Week of [Date]

### The Week in One Sentence
[A single sentence capturing the essence of the week]

### Where You Spent Your Time
[Calendar analysis: meetings vs focus, priority alignment]

### What Moved
[Tasks completed, decisions made, initiatives advanced]

### What Didn't Move
[Stalled items, deferred decisions, stuck initiatives]

### Patterns I'm Noticing
[Cross-source themes, recurring topics, trajectory shifts]

### Blind Spots to Consider
[Things you might be missing, people you haven't connected with, decisions being avoided]
[Note: for a deeper adversarial analysis, suggest running /cos:blindspots]

### Questions for Reflection
[3-5 probing questions based on the week's data]
- [Question 1 — e.g., "You spent 60% of your time in reactive meetings this week. Is that where you need to be?"]
- [Question 2 — e.g., "Initiative X hasn't had a status update in 3 weeks. Is it still a priority?"]
- [Question 3 — e.g., "Three people mentioned concerns about Y in different contexts. Are you seeing this?"]

### Recommended Focus for Next Week
[Based on the analysis, suggest 3-5 focus areas]

### Memory Updates
[Proposed changes to kbx pinned docs (priorities, CIRs, initiatives) based on this week's signals]
```

### 5. Interactive Discussion

After presenting the review, invite discussion:
- "What resonates? What am I getting wrong?"
- "Any of these blind spots hit home?"
- "Should we adjust any priorities or CIRs based on this week?"

### 6. Post-Review Outputs

After the discussion, offer these follow-on options:

- **"Want me to run a coaching session on how you showed up this week?"** — Triggers `/cos:coach`, which uses the review data already in context to deliver a Mochary Method coaching session. No need to re-gather data.

- **"Want me to draft a status update for the CEO / exec team?"** — Generates an upward-facing status update using the review data. Format:

  ```
  **1. Blockers I need help with:**
  * [Blocker: description + WHO can help + WHEN]

  **2. My current priorities:**
  * [Project/initiative]: [Progress + milestone/deadline]

  **3. On my mind:**
  * [Forward-looking item: early risk, upcoming issue, or idea]
  ```

  Rules for the upward update:
  - Prioritise the most recent 5 business days for blockers and priorities
  - Include older items only if they remain active or unresolved
  - Weight internal meetings (1:1s, standups, reviews) more than external calls
  - Use the executive's own words where possible
  - Tag uncertain items with `[PLEASE VERIFY: detail]` or `[INFERRED: basis]`
  - If any tags exist, append a review section at the end
  - Always highlight new developments since the last update
  - Output as a Slack message ready to send

- **"Want me to draft a recap for your direct reports?"** — Generates a downward-facing weekly recap. Format:

  ```
  ## Week of [dates]

  ### What I worked on
  [Key activities, meetings, and focus areas — what the team should know about]

  ### Decisions made
  [Decisions that affect the team, with brief context]

  ### Coming up
  [What's ahead next week that the team should be aware of]

  ### Shout-outs
  [Recognition for good work observed this week]
  ```

  Rules for the downward recap:
  - Focus on a full calendar week (if Sun-Wed, previous week; if Thu-Sat, current week)
  - Focus on what's relevant to the team, not everything the executive did
  - Include decisions that affect team direction or priorities
  - Recognise good work — the team should see the executive notices
  - Keep it concise and Slack-ready

- **"Want a deeper risk analysis on this week's plans?"** — Triggers `/cos:blindspots` in post-review mode.

### 7. Update Memory

Based on the discussion:
- Update kbx pinned initiatives note if status changed: `kbx note edit <path> --body "updated content"` or `--append "new info"`
- Update kbx pinned CIRs note if thresholds should change
- Archive completed initiatives
- `kbx memory add "context" --entity "Name"` for new people context

## Trajectory Comparison

If a previous weekly review exists, always compare:
- Are the same items stuck as last week? (Pattern: stuck for 2+ weeks = needs escalation)
- Did last week's recommended focus areas get attention?
- Did any of last week's blind spots materialise into real problems?
- Are the probing questions changing week to week? (If not, the underlying issues aren't being addressed)

## Graceful Degradation

This review is most powerful with all sources. But even with just gm and kbx, it provides value. Note which sources were unavailable and what insights they would have added.

| Sources Available | Review Quality |
|---|---|
| All sources (kbx + gm + Slack + Linear) | Full strategic review |
| kbx + gm + Slack | Good operational review, limited on project tracking |
| kbx + gm only | Basic time/task analysis, limited pattern detection |
| gm only | Task and calendar movement analysis only, flag that more data would help |
