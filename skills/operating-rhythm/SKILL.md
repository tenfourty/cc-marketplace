# Operating Rhythm

This skill defines how the Chief of Staff maintains cadence, routines, and structured communication patterns.

## What is Operating Rhythm?

Operating Rhythm (OR) is the cadence of communication and interactions that keep an organisation aligned and executing. Per the McChrystal framework, OR is not just about scheduling meetings — it's about ensuring strategic initiatives are pushed through effectively and everyone is aligned on goals.

The Chief of Staff designs, monitors, and optimises the OR. The AI CoS tracks it and ensures nothing falls through the cracks.

## Default Rhythm

The rhythms below are defaults. Actual cadence is stored in `memory/rhythms/cadence.md` and personalised during `/setup`.

### Daily
- **Morning briefing** (`/briefing`): Calendar review, priority actions, overdue items, key signals
- **Post-meeting debriefs** (`/debrief`): After important meetings, extract actions and decisions
- **Ad-hoc status checks** (`/status`): As needed throughout the day

### Weekly
- **Weekly review** (`/review`): Strategic synthesis, pattern analysis, coach-voice reflection
- **Task triage**: Review TASKS.md for stale items, reprioritise, archive completed
- **Memory maintenance**: Promote/demote items in CLAUDE.md, update people profiles

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
1. Calendar for today
2. TASKS.md for overdue/due-today items
3. ~~chat for overnight/morning signals
4. ~~project tracker for blockers

### Weekly Review Routine
**When:** Friday afternoon or Monday morning (configurable)
**Duration:** 15-30 minute interactive session
**Trigger:** `/review` command
**Outputs:** Weekly review document, memory updates, adjusted priorities
**What it checks:**
1. All daily briefing sources + deeper analysis
2. Meeting transcripts for the full week
3. Decision log for the week
4. Initiative status changes
5. Cross-source pattern analysis

### Post-Meeting Routine
**When:** After any significant meeting
**Duration:** 3-5 minutes
**Trigger:** `/debrief` command
**Outputs:** Action items, decision log entries, TASKS.md updates
**What it checks:**
1. Most recent meeting transcript
2. Existing tasks and decisions for cross-reference
3. Attendee profiles for context

## Operating Rhythm Health Indicators

Monitor these to assess whether the OR is working:

| Indicator | Healthy | Unhealthy |
|-----------|---------|-----------|
| Briefing frequency | Daily or near-daily | Skipped 3+ days |
| Review frequency | Weekly | Skipped 2+ weeks |
| Debrief frequency | After most meetings | Rarely or never |
| Task list freshness | Updated within 3 days | Items stale >1 week |
| Decision log currency | Current month has entries | No entries in 2+ weeks |
| Memory freshness | CLAUDE.md updated this week | CLAUDE.md stale >2 weeks |

If OR health degrades, surface it in the weekly review (coach voice):
"Your operating rhythm has gaps this week — no debriefs captured and 3 days without a briefing. The risk is that action items from meetings are going untracked."

## Meeting Cadence Management

Store recurring meeting information in `memory/meetings/recurring.md`. Monitor:

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

## Integration with Productivity Plugin

The productivity plugin's `/update` command syncs tasks from external trackers. The CoS plugin's routines build on top:

| Productivity Plugin | CoS Plugin |
|---|---|
| `/update` syncs tasks from trackers | `/briefing` adds intelligence from calendar, chat, email, transcripts |
| `/update --comprehensive` scans all sources | `/review` provides strategic analysis with coach voice |
| Memory system stores people/glossary | Memory system extends with decisions, CIRs, rhythms |

The two plugins complement each other. The productivity plugin handles the "what" (tasks, memory). The CoS plugin handles the "so what" (analysis, patterns, strategic advice).
