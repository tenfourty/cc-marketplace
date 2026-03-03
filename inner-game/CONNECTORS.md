# Tools

This plugin uses local CLI tools as primary data sources.

## Primary Tools

### kbx — Knowledge Base (Memory)

Local knowledge base storing all coaching data: journal entries, The Document, Wheel of Life assessments, session notes, focus areas. kbx is the coach's memory — everything important is indexed and searchable.

Key usage: `kbx search` (semantic + keyword), `kbx view` (read files), `kbx memory add` (create notes), `kbx note edit` (update/pin/tag). Run `kbx --help` for the full command reference.

**What inner-game stores in kbx:**
- Daily journals: `memory/journal/daily/YYYY-MM-DD.md`
- Weekly/monthly reviews: `memory/journal/weekly/`, `memory/journal/monthly/`
- The Document: `memory/coaching/the-document.md` (pinned)
- Wheel of Life assessments: `memory/coaching/wheel-of-life/YYYY-MM-DD.md`
- Session notes: `memory/coaching/sessions/YYYY-MM-DD-session.md`
- Setup profile and focus area: pinned kbx notes

### gm — Calendar & Tasks

Calendar events + task management via Morgen. The coach reads the calendar for schedule awareness and creates tasks for commitments and routines.

Key usage: `gm today` (schedule), `gm tasks create` (new tasks), `gm tasks list --list Home` (coaching tasks). Run `gm --help` for the full command reference.

**Task conventions:** Coaching tasks go in the Home or Routines lists. Tags model lifecycle (Right-Now, Active, Waiting-On, Someday). Link to projects with `project: Inner Game` in the task description.

## Claude.ai Integrations (Optional)

The coach rarely needs these, but they're available:
- **Google Calendar** — fallback if gm is unavailable
- **Slack** — read work context through a coaching lens (time allocation, relationship patterns)
- **Gmail** — scan for commitments or stress signals

## Cross-Lens Reading

Inner-game reads ALL kbx data (including chief-of-staff content) but through a personal coaching lens:
- Meetings → time allocation patterns, schedule pressure
- People notes → relationship context, social investment
- CoS decisions → stress signals, alignment with values
- Work projects → career domain health

## Future: Health Integrations (V2+)

Not in the current version. Architecture awareness for:
- **Withings** — weight, blood pressure, sleep, body composition
- **Strava** — exercise, activities, training load
- **Oura** — sleep quality, readiness, HRV
- **Apple Health** — aggregate health data export

All health data would stay local. Correlation model inspired by Exist.io.

## Graceful Degradation

All commands degrade gracefully when tools are unavailable. Missing sources are noted in output. The coach works with whatever subset is available — kbx and gm are preferred, but the coaching conversation works even without them.
