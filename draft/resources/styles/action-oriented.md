---
title: "Action-Oriented Conversation"
category: style
use_when: "Everyday thread replies, quick decisions, unblocking teams, assigning ownership"
related: [building-alignment, motivator-supporter]
source: "Generic communication framework"
---

## Overview

The default style for everyday communication, especially in threads. Concise, direct, and focused on making decisions, solving problems, and unblocking teams. This is how most Slack messages should sound.

## Key Characteristics

- **Direct & purposeful:** Get straight to the point. The message's purpose is immediately clear.
- **Tagging for accountability:** Explicitly tag individuals to assign ownership or ask questions.
- **Decision frameworks:** Empower others with simple frameworks ("Is this a big decision? Is it reversible?").
- **Clear next steps:** When making a decision, outline the subsequent actions and owners.
- **Pragmatic formatting:** Use bolding, lists, quotes to improve clarity — but don't over-format short messages.

## Structure Template

Short messages (1-3 sentences):
```
[Direct statement or question]. [Context if needed]. [Action/next step].
```

Decision messages:
```
[Decision]. [1-2 sentences of reasoning].

Next steps:
• [Owner]: [action]
• [Owner]: [action]
```

Empowerment messages:
```
Is this a big decision? (IMHO no). Is it reversible? (IMHO yes).
[Recommendation]. Go for it!
```

## Illustrative Examples

> **Note:** These are generic templates. Your real examples (loaded from `memory/draft/styles/action-oriented.md` if available) will be used as the primary voice reference when drafting.

### Example A: Empowerment in a Thread

> Is this a big decision? (IMHO no), is it reversible? (IMHO, yes it is)
>
> If nobody objects, go for it!

**Why it works:** Gives a decision framework, shares their assessment, then empowers the team to act.

### Example B: Decisive Problem-Solving

> I just switched our monitoring from the basic plan to the pro tier — we've been hitting the data retention limit every sprint and losing visibility on older incidents. The new plan gives us 90-day retention at a predictable monthly cost.
>
> Next step: I'm negotiating an annual contract for a further discount.

**Why it works:** States what was done, why, and what's next. No permission-seeking — just clear action with reasoning.

### Example C: Technical Suggestion in a Thread

> Some thoughts:
> * We should move verbose logging behind a debug flag — that's a win regardless of the other changes
> * Adding per-service log levels that we can toggle at runtime would let us increase detail when investigating without flooding everything
> * For most of these cases, distributed traces will give us better signal than raw logs anyway

**Why it works:** Structured technical input. Each bullet is a concrete suggestion, not a vague direction.

## Common Mistakes

- Being too tentative ("Maybe we could possibly consider...")
- Forgetting to tag the person who needs to act
- Writing a paragraph when a bullet list would be clearer
- Not stating the decision or recommendation clearly

## PCM Variations

- **Thinker:** Add brief reasoning for each point
- **Imaginer:** Be extra explicit about who does what and by when
- **Rebel:** Keep it punchy, maybe add a light touch
- **Promoter:** Lead with the action, skip the preamble entirely

## User Examples

When drafting, also check for the user's style file at `memory/draft/styles/action-oriented.md`. If it exists, use those real examples as the primary voice reference.
