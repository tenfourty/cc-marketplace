# Information Management

This skill defines how the Chief of Staff filters, prioritises, and surfaces information for the executive.

## Critical Information Requirements (CIRs)

CIRs are the backbone of information management (McChrystal Group framework). They define:
- **What** information the executive needs
- **When** they need it (threshold-based)
- **How** it should be delivered (format and channel)

CIRs are stored in a pinned kbx note tagged `cir` and established during `/setup`. They appear in `kbx context` output at session start.

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
- Sprint/project blockers

**Tier 3 — Weekly:**
Include in the weekly review via `/review`. Examples:
- Initiative trajectory shifts
- Team health signals (velocity trends, sentiment)
- Decision backlog growth
- Pattern detection across sources
- Strategic alignment analysis

### Evaluating Information Against CIRs

When scanning any source (kbx, gm, Slack MCP, Linear), evaluate each item:

1. **Does it match a Tier 1 CIR?** → Surface immediately with context
2. **Does it match a Tier 2 CIR?** → Queue for next briefing
3. **Does it match a Tier 3 CIR?** → Queue for next review
4. **Does it match none?** → File it if relevant to kbx, otherwise skip

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
| Same topic in Slack + kbx transcript + Linear | Convergence signal: this is important and needs attention |
| Person mentioned in 3+ contexts this week | This person is central to something — check in with them |
| Project in Linear has no recent Slack or kbx activity | Possibly stalled or deprioritised silently |
| Decision from meeting not reflected in gm tasks | Execution gap: decision made but not actioned |
| Action item in gm tasks but no follow-up in any channel | Dropped ball: nobody's working on this |

## Memory Management

kbx IS the memory system. Manage information across two tiers:

### Hot Cache (kbx pinned notes)
Pinned notes appear in `kbx context` output, loaded every session:
- CIRs (tagged `cir`)
- Active initiatives (tagged `initiative`)
- Operating rhythm (tagged `cadence`)
- Recurring meetings (tagged `meetings`)

Keep pinned notes focused and current. If they grow too large, refactor into smaller, more specific notes.

### Deep Storage (kbx search)
All indexed content is searchable via `kbx search`:
- Meeting transcripts
- Decision notes (tagged `decision`)
- People profiles (kbx person entities)
- Project context (kbx project entities)
- Historical notes

### Promotion Rules
- Topic referenced 3+ times in a week → consider pinning a summary note
- New initiative, new priority → add to pinned initiatives note
- Person becoming central to current work → ensure kbx person profile is current

### Demotion Rules
- Initiative completed or deprioritised → remove from pinned initiatives note
- Information no longer actively referenced → leave in kbx search, unpin if pinned
- Stale context → update or remove from pinned notes

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
