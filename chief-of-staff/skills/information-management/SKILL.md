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
- Key chat threads requiring response
- Sprint/project blockers

**Tier 3 — Weekly:**
Include in the weekly review via `/review`. Examples:
- Initiative trajectory shifts
- Team health signals (velocity trends, sentiment)
- Decision backlog growth
- Pattern detection across sources
- Strategic alignment analysis

### Evaluating Information Against CIRs

When scanning any source (kbx, task backend, chat, project tracker), evaluate each item:

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
| Same topic in chat + email + kbx transcript + project tracker | Convergence signal: this is important and needs attention |
| Person mentioned in 3+ contexts this week | This person is central to something — check in with them |
| Project in project tracker has no recent chat, email, or kbx activity | Possibly stalled or deprioritised silently |
| Decision from meeting not reflected in task backend | Execution gap: decision made but not actioned |
| Action item in task backend but no follow-up in any channel | Dropped ball: nobody's working on this |
| Email commitment not tracked in task backend | Dropped ball: promised something via email but never captured it |
| External stakeholder emailing frequently with no kbx/chat activity | Relationship happening outside internal channels — may need visibility |

## Entity Resolution

When processing any input (user message, meeting transcript, chat thread), resolve all entity references before acting.

### Lookup Flow

1. **Session context** (kbx context loaded at startup) — check first
2. **kbx person find / kbx project find** — authoritative lookup
3. **kbx search** — broader search if entity isn't a person/project
4. **Ask the user** — only after exhausting kbx

### Disambiguation

When multiple matches exist:
- Present the options concisely: "Two matches for 'Sarah': Sarah Chen (Platform) or Sarah Williams (Design). Which one?"
- Use meeting context to infer when possible — if the transcript is from a Platform standup, it's probably Sarah Chen
- Once resolved, don't ask again in the same session

### Learning New Terms

When the user uses a term kbx doesn't know:
- Ask what it means
- Write it to kbx: `kbx memory add "Term: [TERM]" --body "[meaning and context]" --tags glossary`
- If the pinned glossary note exists, append to it: `kbx note edit <path> --append "- **[TERM]**: [meaning]"`

### Staleness Check (ENFORCED)

Entity context goes stale. When referencing a person or project from kbx:
- **ALWAYS** check the `updated_at` and `last_mentioned_at` fields
- If the most recent timestamp is >30 days ago: add an inline note — "Context on [person] is from [date] — may be stale"
- If >90 days ago: explicitly caveat any analysis — "This data may be outdated — consider verifying before acting on it"
- After `/debrief`, check if any attendees' profiles were updated. If they weren't and should have been, flag it.

## Dedup Before Writing (Entity Writes)

Before writing **any** fact, entity update, or Open Items entry to a kbx entity, run this dedup check to prevent duplicate information accumulating over time.

### Protocol

1. **Read the target entity file:** `kbx view <entity-path> --plain`
2. **Compare** the candidate write against existing content — facts, metadata, and Open Items already on the entity
3. **Decide** one of three outcomes:

| Decision | When | Action |
|----------|------|--------|
| **SKIP** | Information is already captured (same meaning, even if phrased differently) | Do nothing. Log "SKIP: [reason]" internally. |
| **MERGE** | Known but stale, incomplete, or less specific — the new information adds meaningful detail | Update the existing entry in place (e.g., `kbx memory edit-fact <id> --text "updated text"` for facts, or Edit tool for Open Items). |
| **CREATE** | Genuinely new information not present on the entity | Write normally (`kbx memory add --entity`, `kbx person edit`, or Edit tool for Open Items). |

### What Counts as a Duplicate

- **Facts:** Same core meaning regardless of phrasing. "Henri prefers async" and "Henri likes asynchronous communication" are duplicates. "Henri prefers async for status updates but sync for decisions" is a MERGE (more specific).
- **Open Items:** Same commitment/action even if the meeting source differs. "Follow up on migration timeline" from two different meetings is a duplicate — keep the most recent date.
- **Entity metadata:** Same role/team/reporting line already set. Only MERGE if the new value is different.

### Lightweight Execution

This is an in-context check — no extra tool calls beyond the `kbx view` that commands already perform. The LLM compares existing content with candidate writes in a single reasoning step. Do not over-engineer: if the entity file is short, scan it visually. If long, focus on the `## Facts` and `## Open Items` sections.

### Batch Writes

When writing multiple items to the same entity (common in debriefs), read the entity file **once**, then apply the dedup check to all candidate writes together before executing any of them.

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
- Topic referenced 3+ times in a week → consider pinning a summary note (`kbx note edit <path> --pin`)
- New initiative, new priority → add to pinned initiatives note (`kbx note edit <path> --append "..."`)
- Person becoming central to current work → ensure kbx person profile is current

### Demotion Rules
- Initiative completed or deprioritised → remove from pinned initiatives note (`kbx note edit <path> --body "..." ` with updated content)
- Information no longer actively referenced → leave in kbx search, unpin if pinned (`kbx note edit <path> --unpin`)
- Stale context → update or remove from pinned notes

## Session Startup Freshness Check

When `kbx context` is loaded at session start, also check for stale entity profiles:

1. Run `kbx entity stale --days 30 --type person --json`
2. If results come back non-empty, inject a summary line into the session context:
   ```
   [Freshness] N pinned people have stale profiles — consider reviewing before meetings.
   ```
3. If any stale entities are pinned, list them by name so the executive is immediately aware
4. This check is lightweight and should NOT block the session — surface and move on

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

These windows are NOT guidelines — they are thresholds. When presenting information older than the freshness window, you MUST flag it. Do not silently present stale data as current.
