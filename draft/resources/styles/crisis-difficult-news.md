---
title: "Crisis & Difficult News"
category: style
use_when: "Incident response, delivering difficult news, departures, high-stakes situations"
related: [strategic-announcement, cultural-reinforcement]
source: "Generic communication framework"
---

## Overview

For incident response, delivering difficult news, and managing high-stakes situations. Combines transparency, calm authority, and clear action orientation. The guiding principle is hypertransparency — acknowledge issues honestly, communicate to affected parties, and take ownership.

## Key Characteristics

- **Structured transparency:** Clear sections — What Happened / Impact / Current Status / Next Steps
- **Calm authority:** Direct about severity without panic. Acknowledge honestly.
- **Lead with positive (when possible):** If announcing departures alongside promotions, lead with positive news first.
- **Immediate continuity plan:** Always follow difficult news with concrete next steps and contingency plans.
- **Customer-first mindset:** Strong emphasis on transparent communication to affected parties.
- **Clear ownership:** Specify who is doing what and by when.
- **Learning orientation:** Frame incidents as opportunities to improve systems and processes.
- **Reframe positively:** End by connecting the challenge to larger values or commitments.

## Structure Template

For incidents:
```
[Channel], [Status update context]

Short summary of where we are:
• **Status:** [Current state]
• **Next step:** [What's happening now + owner + estimate]
• **Expectation:** [What we expect after the fix]
• **Monitoring:** [What we're watching]

[Any logistical notes]
```

For difficult organisational news:
```
[Channel], [Title — lead with positive if mixing good and bad news]

[Positive news first — promotions, new roles, growth]

[Transition to difficult news — honest, direct, no sugar-coating]
• [Person/team]: [What's happening + honest context]
  ◦ **Our continuity plan:** [Concrete steps]

[Reframe — connect to values, commitment, team strength]

:question: Questions? Drop them in the thread :thread:
```

## Illustrative Examples

> **Note:** These are generic templates. Your real examples (loaded from `memory/draft/styles/crisis-difficult-news.md` if available) will be used as the primary voice reference when drafting.

### Example A: Incident Status Update

> #ops, Quick status update on the API latency issue. Here's where we are:
> * **Status:** Root cause identified — a misconfigured connection pool was exhausting DB connections under load
> * **Fix:** Config change deployed to staging, production rollout in ~30 minutes
> * **Expectation:** Latency should return to normal within an hour of deployment
> * **Monitoring:** Dashboards open, alerting thresholds tightened until we're confident
>
> <@Name> is leading the fix. A few of us are grabbing lunch and will be back online shortly.

**Why it works:** Structured, factual, no panic. Each bullet is a clear status point. Named owner. Human touch at the end.

### Example B: Team Restructure with Departures

> #company, :wave: Team Update — Some Changes to Share
>
> First, the good news: we're creating a dedicated Developer Experience team, led by <@Name>, who has been doing excellent work in this space already.
>
> We also have some departures to share:
> * **Backend team:** <@Name A> is leaving at the end of the month for a new opportunity. **Continuity:** <@Name B> is stepping up as interim lead, and we've already started hiring for a backfill.
> * **QA team:** <@Name C> is moving on in two weeks. **Continuity:** We're redistributing their responsibilities across the team and bringing in contract support for the transition.
>
> Change is never easy, but I'm confident in the people stepping up. We'll get through this stronger.
>
> :question: Questions or concerns? Thread is open :thread:

**Why it works:** Positive first. Honest about the difficult parts. Immediate continuity plan for each departure. Ends on team confidence.

### Example C: Pushing for Customer Transparency

> I'd like to push for us to communicate proactively with affected customers on this one.
>
> We know there was an impact. The right thing to do is acknowledge it, explain what happened, and share what we're doing to prevent it happening again. Silence erodes trust faster than any outage.

**Why it works:** Takes a strong position. Principled ("silence erodes trust"). Specific about what the communication should cover.

## Common Mistakes

- Burying the bad news in a paragraph of context
- Not providing a continuity plan alongside departures
- Being vague about next steps ("we're looking into it")
- Panic tone or defensive language
- Failing to acknowledge the human impact
- Not pushing for transparency when it's needed

## PCM Variations

- **Thinker audience:** More detail on root cause analysis and prevention measures
- **Persister audience:** Connect response to values — integrity, transparency, doing the right thing
- **Harmoniser audience:** Acknowledge the emotional impact, check on people's well-being
- **General incident channel:** Default structured template works — facts, status, next steps

## User Examples

When drafting, also check for the user's style file at `memory/draft/styles/crisis-difficult-news.md`. If it exists, use those real examples as the primary voice reference.
