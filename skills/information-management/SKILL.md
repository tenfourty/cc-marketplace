# Information Management

This skill defines how the Chief of Staff filters, prioritises, and surfaces information for the executive.

## Critical Information Requirements (CIRs)

CIRs are the backbone of information management (McChrystal Group framework). They define:
- **What** information the executive needs
- **When** they need it (threshold-based)
- **How** it should be delivered (format and channel)

CIRs are stored in `memory/priorities/cirs.md` and established during `/setup`.

### CIR Tiers

**Tier 1 — Immediate:**
Surface as soon as detected. Don't wait for a briefing. Examples:
- Production incident (P0/P1)
- Key person resignation or serious concern
- Security breach or vulnerability disclosure
- Major customer escalation
- Budget threshold breach

**Tier 2 — Daily:**
Include in the morning briefing via `/briefing`. Examples:
- Calendar conflicts or notable gaps
- Overdue action items (>2 days past due)
- Key Slack threads requiring response
- Emails from key stakeholders awaiting reply
- Sprint/project blockers

**Tier 3 — Weekly:**
Include in the weekly review via `/review`. Examples:
- Initiative trajectory shifts
- Team health signals (velocity trends, sentiment)
- Decision backlog growth
- Pattern detection across sources
- Strategic alignment analysis

### Evaluating Information Against CIRs

When scanning any source (Slack, email, transcripts, Linear), evaluate each item:

1. **Does it match a Tier 1 CIR?** → Surface immediately with context
2. **Does it match a Tier 2 CIR?** → Queue for next briefing
3. **Does it match a Tier 3 CIR?** → Queue for next review
4. **Does it match none?** → File it if relevant to memory, otherwise skip

## Information Filtering Principles

### What to Surface
- Items matching CIR criteria
- Messages from direct reports and key stakeholders
- Decisions that need the executive's input
- Blockers on active initiatives
- Patterns (same topic appearing in 2+ sources)
- Time-sensitive items with approaching deadlines
- Items the executive was explicitly mentioned in or assigned to

### What to Filter Out
- Status updates that don't indicate problems
- Routine automated notifications
- Conversations where the executive's input isn't needed
- Information the executive has already seen and acted on
- Noise: off-topic threads, social chat, general announcements (unless they match CIRs)

### The Signal-to-Noise Principle
A good Chief of Staff doesn't show everything — they show the right things. The executive's attention is the scarcest resource. Every item surfaced should justify the cognitive load it creates.

If unsure whether something is worth surfacing: **err on the side of including it, but put it at the end** under "Signals" or "For Your Awareness" rather than "Immediate Attention."

## Cross-Source Correlation

The highest-value information management is connecting signals across sources:

| Pattern | What It Means |
|---------|--------------|
| Same topic in Slack + email + meeting | Convergence signal: this is important and needs attention |
| Person mentioned in 3+ contexts this week | This person is central to something — check in with them |
| Project in tracker has no recent chat/email activity | Possibly stalled or deprioritised silently |
| Decision from meeting not reflected in tracker | Execution gap: decision made but not actioned |
| Action item in tasks but no follow-up in any channel | Dropped ball: nobody's working on this |

## Context Window Management

The executive's working context (CLAUDE.md) is a limited resource. Manage it like memory:

### Hot Cache (CLAUDE.md)
- Current top priorities (3-5)
- Key people quick reference (name → role, one line)
- Active CIRs summary
- This week's focus areas
- Recent high-impact decisions

Keep to ~50-80 lines. If it grows beyond that, demote less-referenced items.

### Warm Storage (memory/)
- Full people profiles
- Complete decision logs
- Initiative details with history
- Meeting context and patterns
- Organisational context

### Promotion Rules
- Referenced 3+ times in a week → promote to CLAUDE.md
- New hire, new initiative, new priority → add to CLAUDE.md immediately
- Person becoming central to current work → promote to CLAUDE.md

### Demotion Rules
- Not referenced in 2+ weeks → demote from CLAUDE.md to memory/
- Initiative completed or deprioritised → archive from CLAUDE.md
- Person no longer in regular interaction → demote from CLAUDE.md

## Information Freshness

All information has a shelf life. Track and manage it:

| Type | Freshness Window | Action When Stale |
|------|-----------------|-------------------|
| Task status | 3 days | Flag in briefing |
| Initiative status | 1 week | Flag in review |
| Person context | 1 month | Verify on next interaction |
| Decision | 3 months | Flag for revisit |
| CIRs | 1 month | Suggest reassessment |
| Priorities | 2 weeks | Suggest check-in |
