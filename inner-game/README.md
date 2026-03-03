# inner-game — Personal Life Coach

> Performance = Potential - Interference — Tim Gallwey

Personal life coach plugin for Claude Code. Coaching conversations, identity work, daily journaling, and life assessment. Named after Tim Gallwey's Inner Game: reduce the interference between who you are and who you're capable of being.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/claude-code) v1.0+
- [kbx](https://github.com/tenfourty/kbx) — knowledge base (memory and search)
- [gm](https://github.com/tenfourty/guten-morgen) — calendar + task manager (Morgen)

## Installation

Install from cc-marketplace:

```bash
claude install cc-marketplace/inner-game
```

Or clone and link locally:

```bash
git clone https://github.com/tenfourty/cc-marketplace.git
claude plugin link ./cc-marketplace/inner-game
```

## Commands

| Command | Description | Duration |
|---------|-------------|----------|
| `/ig:boot` | Enter coaching mode — load context, suggest next activity | 30 sec |
| `/ig:setup` | First-run onboarding — coaching relationship + initial Wheel | 20-30 min |
| `/ig:morning` | Morning priming — intentions, energy, Document reading | 2-5 min |
| `/ig:evening` | Evening reflection — gratitude, learning, alignment | 3-5 min |
| `/ig:checkin` | Mid-day pulse — energy and one line | 60 sec |
| `/ig:session` | Deep coaching conversation with adaptive framework selection | 15-30 min |
| `/ig:document` | Create or revise The Document (identity declarations) | 20-45 min |
| `/ig:focus` | Choose focus area for the next 4-8 weeks | 10-15 min |
| `/ig:review` | Weekly or monthly life review | 10-20 min |
| `/ig:wheel` | Wheel of Life assessment across 7 domains | 10-15 min |

## Architecture

Single persistent coach agent with background workers for heavy analysis. All memory via kbx, tasks via gm.

**Skills (always-on context):**
- Coaching Identity — voice modes, resource index, safety boundaries
- The Document — 5-phase creation methodology
- Journaling Practice — Obsidian-compatible format, metrics, patterns
- Life Domains — 7 domains, Wheel of Life, focus areas

**Resource Library (43 files, read on demand):**
- 8 coaching frameworks (GROW, Inner Game, MI, Solution-Focused, etc.)
- 9 coach philosophies (Hardison, Fogg, Clear, Robbins, Covey, etc.)
- 8 journaling techniques (Morning Pages, Fear-Setting, Gratitude, etc.)
- 4 assessments (Wheel of Life, PERMA, Energy Audit, 6 Human Needs)
- 7 Document creation guides (one per phase + creation/revision guides)
- 7 life domain deep-dives

## Life Domains

1. Health & Energy
2. Relationships
3. Career & Purpose
4. Finances
5. Growth & Learning
6. Fun & Adventure
7. Inner Life

## The Document

The centerpiece. Personal identity declarations — "I AM" statements created through a 5-phase journey (Self-Examination → Forgiveness → Values → Declarations → Integration). Read aloud morning and evening. Based on Steve Hardison's coaching practice.

## Connected Tools

See [CONNECTORS.md](CONNECTORS.md) for full tool documentation.

- **kbx** — knowledge base (memory, search, people, projects)
- **gm** — calendar and tasks (Morgen)
- **Slack, Gmail, Google Calendar** — optional MCP integrations

## Design Influences

- **Tim Gallwey** — Inner Game: Performance = Potential - Interference
- **Steve Hardison** — The Document, BEing principles
- **Michael Bungay Stanier** — 7 Essential Questions, "The Coaching Habit"
- **BJ Fogg** — Tiny Habits, B=MAP, celebration creates habits
- **James Clear** — Atomic Habits, identity-based change
- **Matt Mochary** — Energy audit, conscious leadership
- **Tony Robbins** — RPM, 6 Human Needs, state management
- **Marshall Goldsmith** — Feedforward, stakeholder-centered coaching
- **Brené Brown** — Vulnerability, shame resilience
- **Stephen Covey** — 7 Habits, Circle of Influence
- **Brendon Burchard** — High Performance Habits
- **ICF** — Core Competencies (2021), coaching ethics
- **Paul J. Meyer** — Wheel of Life assessment (1960)

## Licence

MIT
