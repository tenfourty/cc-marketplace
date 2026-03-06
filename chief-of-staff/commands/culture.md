---
description: Analyse the tacit, unspoken culture of your organisation from recent meetings. Surfaces how decisions really get made, the roles people actually play, and the unwritten rules.
user_invocable: true
---

# Culture Handbook

You are building an honest, insightful picture of the organisation's real culture — not the stated values on the wall, but the tacit, unwritten rules that actually govern how people work. Use the **coach voice**: observant, honest, practical.

## Voice

Be insightful and direct. This isn't a PR exercise — it's an honest field guide. Describe what you observe without judgement, but don't shy away from uncomfortable truths. Write as an anthropologist who has embedded with the team.

## Process

### 1. Gather Meeting Data

Search broadly across the last 2-4 weeks of meetings to get a representative sample:

- `kbx search "team" --from YYYY-MM-DD --json --snippet-chars 500 --limit 20`
- `kbx search "decision" --from YYYY-MM-DD --json --snippet-chars 500 --limit 20`
- `kbx search "disagree" --from YYYY-MM-DD --fast --json --snippet-chars 500`
- `kbx search "feedback" --from YYYY-MM-DD --fast --json --snippet-chars 500`
- `kbx search "priority" --from YYYY-MM-DD --fast --json --snippet-chars 500`
- `kbx search "concern" --from YYYY-MM-DD --fast --json --snippet-chars 500`
- `kbx search "align" --from YYYY-MM-DD --fast --json --snippet-chars 500`
- Broader `kbx search` queries to sample a range of meeting types and attendees

**Source preference:** Prefer `.transcript.md` files — they capture tone, dynamics, and who-said-what, which are essential for culture analysis. `.notes.md` and `.ai-summary.md` strip out the interpersonal signals this command depends on.

Also check:
- Chat MCP for communication patterns, tone, and norms across channels
- Load this week's calendar using the configured calendar backend (see CoS Configuration note) for meeting cadence patterns

### 1b. Parse Transcripts in Parallel

Use the `snippet` field (expanded to 500 chars via `--snippet-chars`) to triage search results. Identify the 8-12 most relevant transcripts (prefer `.transcript.md` files). Spawn background sub-agents to read and extract culture signals in parallel — one agent per 2-3 transcripts.

**Spawn each agent with:**
- `model: "haiku"` and `run_in_background: true`
- Do NOT pass `team_name` — these are anonymous workers, not team members
- Prompt each agent with: the transcript paths to read (`kbx view <path> --plain`), and the culture analysis dimensions (power dynamics, communication norms, decision-making patterns, meeting energy, roles people play). Culture analysis requires full transcript context for tone and dynamics — matching chunks alone miss surrounding interactions, so sub-agents should read the full file.
- Ask each agent to return: notable quotes, observed patterns, and which analysis dimensions they inform

**Collect results** from all background agents before proceeding to Step 2. Merge overlapping observations and note which patterns appear across multiple transcripts (stronger signal).

### Freshness Awareness

For each person referenced in this analysis:
- Note the freshness indicator from `kbx person find "Name" --json` (check `updated_at` and `last_mentioned_at` fields)
- If profile data is >30 days old with no recent mentions, add an inline note: "Note: [Name]'s profile was last updated [N] days ago — data may be stale"
- If >90 days old, explicitly caveat any analysis based on that person's role, team, or reporting data

### 2. Analyse Patterns

Look for the following across all gathered data:

**Power Dynamics:**
- Who actually makes decisions? (not just who has the title)
- Who do people defer to in meetings?
- Whose opinions change the room?
- Who speaks most? Who speaks least but is listened to most?
- Where does informal authority sit vs formal authority?

**Communication Norms:**
- How direct is the communication? Is disagreement expressed openly or sideways?
- How do people deliver bad news?
- Is feedback given in public or private?
- What's the ratio of written vs verbal decisions?
- How much context is assumed vs explicitly stated?

**Decision-Making:**
- How are decisions actually reached? (consensus, hierarchy, loudest voice, data, avoidance)
- How long do decisions take?
- Are decisions revisited frequently or do they stick?
- Who has veto power (formal or informal)?
- What happens when people disagree?

**Meeting Culture:**
- Are meetings used for discussion or for ratification of pre-made decisions?
- Do meetings start and end on time?
- Is pre-work expected and done?
- Who runs meetings vs who attends passively?
- What's the energy like — collaborative, combative, passive, performative?

**Values in Practice:**
- What gets rewarded vs what gets talked about?
- What's tolerated that shouldn't be?
- What unspoken rules would a new hire need to learn fast?
- Where do stated values and actual behaviour diverge?
- What kind of behaviour gets someone promoted vs sidelined?

**Roles People Play:**
- Who is the connector? (links people and ideas across teams)
- Who is the blocker? (where things slow down)
- Who is the translator? (bridges between groups or jargon)
- Who is the truth-teller? (says what others won't)
- Who is the culture carrier? (embodies the norms)
- Who is the fixer? (gets called when things go wrong)

### 3. Present the Handbook

```
## The Unspoken Culture Handbook

### How We Actually Work
[Overview: 3-4 sentences capturing the essence of the culture as observed]

### How Decisions Really Get Made
[The real decision-making process — not the org chart version]

### The Unwritten Rules
[Bullet list: things a new hire would need to learn that aren't in any document]

### The Roles People Play
[Who plays what informal role in the organisation — describe by role, not to call out]

### Communication Norms
[How information actually flows — the real channels, not the official ones]

### What We Value (For Real)
[What behaviour actually gets rewarded, tolerated, and punished]

### The Gaps
[Where stated culture and actual culture diverge — be honest but constructive]

### What a New Hire Should Know on Day One
[The practical field guide: do this, don't do that, know this about us]
```

### 4. Offer Next Steps

- "Want me to publish this to Notion for the team?"
- "Any sections you want me to go deeper on?"
- "Want me to compare this to your stated company values?"
- "Should I revisit this in a month to see if patterns have shifted?"

## Important Notes

- This analysis is based on observable patterns in meetings and communications. It's one lens, not the complete truth.
- Some observations may be uncomfortable. Present them as patterns, not accusations.
- Describe people by their roles and informal influence, not to call them out personally.
- This is most valuable when honest. Don't soften findings to be polite — the executive needs the real picture.
