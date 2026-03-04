---
title: "Knowledge Share"
category: style
use_when: "Sharing articles, podcasts, event summaries, conference takeaways with teams"
related: [strategic-announcement, building-alignment]
source: "Generic communication framework"
---

## Overview

Sharing valuable external content (articles, podcasts, event summaries) with specific teams or the wider company. The goal is to distil key insights and make them relevant. You do the summarisation work so others don't have to.

## Key Characteristics

- **Lead with the source:** Start with a link to the original content.
- **Summarise key takeaways:** Numbered or bulleted list of the most important points. Do the work of extraction.
- **Add a "So What":** Explicitly state why this information is relevant to the team or company.
- **Keep it focused:** The message is about the content and its application, not about you.

## Structure Template

```
[Channel], [Context sentence — why you're sharing this]

<link|[Source title]>

Key takeaways:
• [Insight 1]
• [Insight 2]
• [Insight 3]

[So-what paragraph — why this matters for us / what we should consider]
```

## Illustrative Examples

> **Note:** These are generic templates. Your real examples (loaded from `memory/draft/styles/knowledge-share.md` if available) will be used as the primary voice reference when drafting.

### Example A: Article Summary for a Specific Team

> #platform, Sharing this write-up on how Stripe handles database migrations at scale <link|Stripe Engineering Blog — Online Migrations>
>
> Their key principle: every migration must be backwards-compatible. They never do a big-bang cutover.
>
> They run dual-writes during the transition period and validate consistency with shadow reads before switching traffic.
>
> The migration tooling is self-serve — any team can run one without involving the platform team.
>
> Worth considering for our own migration tooling — we're hitting some of the same scaling challenges they describe.

**Why it works:** Goes straight to the takeaways. Each point is a standalone insight. Closes with "so what for us".

### Example B: Conference Takeaways for a Technical Team

> #security, Hey folks — I was at a meetup last week and there was a great talk on supply chain security for CI/CD pipelines.
>
> <link|Speaker's slides>, but key takeaways for us:
> * Pinning dependencies by hash (not just version) catches more tampering than most teams realise
> * The biggest risk vector isn't packages — it's GitHub Actions from third-party repos running with write access to your codebase
>
> Some of this maps directly to what we're building... thought it was worth sharing.

**Why it works:** Provides full context link but extracts the actionable bits. The "relevant for us" framing makes it a conversation starter, not a lecture.

## Common Mistakes

- Sharing a link with no summary ("Check this out!")
- Writing a long essay instead of bullet points
- Forgetting the "so what" — why should anyone care?
- Sharing to too broad an audience when only one team would find it relevant

## PCM Variations

- **Thinker audience:** More detailed breakdown, perhaps with your own analysis of the methodology
- **Persister audience:** Connect insights to team values or mission
- **Rebel audience:** Keep it punchy, maybe lead with the most surprising or provocative takeaway
- **General audience:** Default template works — lead with source, bullet takeaways, close with relevance

## User Examples

When drafting, also check for the user's style file at `memory/draft/styles/knowledge-share.md`. If it exists, use those real examples as the primary voice reference.
