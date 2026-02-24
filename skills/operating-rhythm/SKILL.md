# Operating Rhythm

This skill defines how the Chief of Staff maintains cadence, routines, and structured communication patterns.

## What is Operating Rhythm?

Operating Rhythm (OR) is the cadence of communication and interactions that keep an organisation aligned and executing. Per the McChrystal framework, OR is not just about scheduling meetings — it's about ensuring strategic initiatives are pushed through effectively and everyone is aligned on goals.

The Chief of Staff designs, monitors, and optimises the OR. The AI CoS tracks it and ensures nothing falls through the cracks.

## Default Rhythm

The rhythms below are defaults. Actual cadence is stored in a pinned kbx note tagged `cadence` and personalised during `/setup`.

### Daily
- **Morning briefing** (`/briefing`): Calendar review, priority actions, overdue items, key signals
- **Post-meeting debriefs** (`/debrief`): After important meetings, extract actions and decisions
- **Ad-hoc status checks** (`/status`): As needed throughout the day

### Weekly
- **Weekly review** (`/review`): Strategic synthesis, pattern analysis, coach-voice reflection
- **Task triage**: Review gm tasks for stale items, reprioritise, complete done items
- **Memory maintenance**: Update kbx pinned notes, update people context

### Monthly
- **Priority reassessment**: Are the current priorities still right? Run a mini Stop/Start/Continue
- **CIR review**: Are the Critical Information Requirements still capturing the right signals?
- **Initiative portfolio review**: What's complete? What's stalled? What should be added?
- **Decision audit**: Review decisions with "Revisit by" dates. Check for decision debt

### Quarterly
- **Strategic alignment check**: Deep review of priorities vs. actual activities
- **Operating rhythm audit**: Are the right meetings happening? Are they effective?
- **Relationship inventory**: Which key relationships need attention?

## Routine Definitions

### Morning Briefing Routine
**When:** Start of the working day (configurable)
**Duration:** 5-10 minute read
**Trigger:** `/briefing` command
**Outputs:** Structured daily brief
**What it checks:**
1. `gm today` for calendar and today's tasks
2. `gm tasks list --overdue` for overdue items
3. `gm tasks list --tag Right-Now` for today's focus
4. Slack MCP for overnight/morning signals
5. `gm tasks list --source linear` for blockers

### Weekly Review Routine
**When:** Friday afternoon or Monday morning (configurable)
**Duration:** 15-30 minute interactive session
**Trigger:** `/review` command
**Outputs:** Weekly review document, kbx updates, adjusted priorities
**What it checks:**
1. `gm this-week` for calendar and task overview
2. `kbx search` with date ranges for meeting transcript analysis
3. `kbx note list --tag decision` for the week's decisions
4. `gm tasks list` variants for task movement
5. Slack MCP for communication themes
6. `kbx project find` for initiative status

### Post-Meeting Routine
**When:** After any significant meeting
**Duration:** 3-5 minutes
**Trigger:** `/debrief` command
**Outputs:** Action items, decision log entries, gm task updates
**What it checks:**
1. `kbx search` for the most recent meeting transcript
2. `gm tasks list` for cross-reference against existing tasks
3. `kbx person find` for attendee context

## Operating Rhythm Health Indicators

Monitor these to assess whether the OR is working:

| Indicator | Healthy | Unhealthy |
|-----------|---------|-----------|
| Briefing frequency | Daily or near-daily | Skipped 3+ days |
| Review frequency | Weekly | Skipped 2+ weeks |
| Debrief frequency | After most meetings | Rarely or never |
| Task list freshness | gm tasks updated within 3 days | Items stale >1 week |
| Decision log currency | Current month has entries in kbx | No decision notes in 2+ weeks |
| kbx pinned notes freshness | Updated this week | Stale >2 weeks |

If OR health degrades, surface it in the weekly review (coach voice):
"Your operating rhythm has gaps this week — no debriefs captured and 3 days without a briefing. The risk is that action items from meetings are going untracked."

## Meeting Cadence Management

Recurring meeting information is stored in a pinned kbx note tagged `meetings`. Monitor:

### Meeting Effectiveness Signals
- Meetings that consistently produce no action items or decisions → possibly unnecessary
- Meetings that consistently run over → agenda or scope issue
- Meetings where key people are absent → attendance problem
- Meetings with topics that never resolve → deeper issue to address

### Operating Rhythm Audit Questions
(From the McChrystal playbook, Appendix 4)
- Are the right people involved in each meeting?
- Who are the decision makers?
- Are they receiving the right amount of information?
- Is the messaging clear and actionable?
- Are meetings happening at the right time to drive decisions?

## Rhythm Disruptions

The Chief of Staff should flag when the rhythm is disrupted:
- **Travel weeks:** Adjusted cadence, compressed briefings
- **Crisis mode:** Shift from strategic to operational focus, increase briefing frequency
- **Holiday periods:** Reduced cadence, focus on coverage and delegation
- **Board/investor cycles:** Increased prep, different information focus
- **Restructuring:** Heightened people sensitivity, more frequent check-ins

In each case, note the disruption and suggest adjusted routines.

## Tool Integration

kbx and gm are the primary tools underpinning the operating rhythm:

| Tool | Role in OR |
|------|-----------|
| `gm today` / `gm this-week` | Calendar awareness for briefings and reviews |
| `gm tasks list` variants | Task movement tracking, overdue detection |
| `gm tasks create` / `gm tasks close` | Task lifecycle from debriefs |
| `kbx context` | Pinned docs provide CIRs, initiatives, rhythm, meetings |
| `kbx search` | Transcript analysis for decisions and actions |
| `kbx memory add` | Decision logging, people context updates |
| Slack MCP | Real-time communication signals |

The two systems complement each other. gm handles the "what" (events and tasks). kbx handles the "who" and "why" (people, context, decisions). The CoS plugin provides the "so what" (analysis, patterns, strategic advice).
