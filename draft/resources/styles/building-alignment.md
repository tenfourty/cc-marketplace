---
title: "Building Alignment"
category: style
use_when: "Soliciting feedback, building consensus, introducing processes, admitting uncertainty, asking for help"
related: [strategic-announcement, action-oriented]
source: "Generic communication framework"
---

## Overview

For soliciting feedback, building consensus, coordinating cross-functionally, introducing new processes, and admitting uncertainty. Collaborative, principle-driven, and shows intellectual humility. The key signal: you want people to push back.

## Key Characteristics

- **Explicit request for input:** Make it clear you want feedback and participation.
- **Context-setting:** Explain how the initiative came about and why it matters.
- **Collaborative framing:** Credit others who contributed. Position as facilitator, not dictator.
- **Principle-first approach:** Lead with principles and frameworks before details.
- **Clear action items:** Specific asks with owners and deadlines.
- **Testing mindset:** Frame new initiatives as experiments or "testing phases" to reduce resistance.
- **Intellectual humility:** Not afraid to say "I don't understand", "correct me if I'm wrong", or ask clarifying questions.
- **Asking for help:** Explicitly request assistance, making it easy for people to contribute.

## Structure Template

For proposals/RFCs:
```
[Channel], [Emoji] [Title — what this is about]

Hi folks, I wanted to share something that [collaborators] and I have been working on.

[How this started — give credit, show it's collaborative]

:page_facing_up: We put together <link|[Document title]> :point_left: Please review!

[1-2 sentences on the principle or approach]

[What you're asking for: "We would love your feedback" / "If we have broad agreement..."]

[Credit collaborators again + connect to bigger picture]
```

For asking volunteers:
```
[Channel], [Emoji] [What you need — with personality]

Hi folks! We need help [specific task] on [real environments].

**Quick test (time estimate):**
[Step-by-step instructions]

:thread: Please reply in the thread with:
[Structured format for responses]

[Why this matters + what you'll do with the data]
```

## Illustrative Examples

> **Note:** These are generic templates. Your real examples (loaded from `memory/draft/styles/building-alignment.md` if available) will be used as the primary voice reference when drafting.

### Example A: Soliciting Feedback on a New Process

> #engineering, :mega: RFC: How We Handle On-Call Rotations
>
> Hi folks, <@Name A>, <@Name B>, and I have been working on a proposal for restructuring on-call.
>
> The conversation started when the team flagged that on-call felt uneven and stressful. Rather than jumping to a schedule change, we stepped back and asked: what principles should guide on-call?
>
> :page_facing_up: We put together <link|On-Call Principles RFC> :point_left: Please review!
>
> We want to agree on the principles first — if we're aligned on those, the specific rotation design follows naturally.
>
> We'd love your feedback. If we have broad agreement by Friday, we'll move this into a two-sprint trial.

**Why it works:** Credits collaborators. Principle-first framing. Explicit feedback request. "Trial" language reduces resistance.

### Example B: Asking for Volunteers

> #backend, :wrench: Load Test Volunteers Needed — 15 minutes of your time
>
> We're stress-testing the new caching layer and need real-world query patterns from different services.
>
> **What to do (15 min):**
> ```
> 1. Pull the latest from main
> 2. Run: make load-profile > profile.json
> 3. Upload profile.json to #backend thread
> ```
>
> :thread: Please reply with:
> * Service name
> * Avg query count from the profile output
> * Anything unexpected in the results
>
> I'll aggregate the profiles to build a realistic load simulation. Thanks in advance! :pray:

**Why it works:** Clear time commitment. Copy-pasteable instructions. Structured response format. Explains what you'll do with the data.

### Example C: Requesting Team Participation

> :sunrise: Good morning folks!
>
> Two quick asks as you start your day:
>
> * :ballot_box_with_check: Fill in the retrospective survey (5 min — link in thread)
> * :ballot_box_with_check: Update your sprint board before standup
>
> Best to knock them out now — each takes a few minutes and then they're off your plate.
>
> Why bother? Because the retro results directly shape what we change next sprint. Your input matters.

**Why it works:** Friendly morning framing. Clear tasks with time estimates. Explains why it matters. Low commitment stated upfront.

## Common Mistakes

- Presenting a decision as a question ("What do you think about this thing I've already decided?")
- Not providing enough context for people to give meaningful feedback
- Forgetting to credit collaborators
- Being too abstract — give people concrete things to respond to
- Not following up after asking for feedback

## PCM Variations

- **Thinker:** Provide data and structured analysis alongside the proposal
- **Persister:** Frame as values-aligned, ask for their expert opinion
- **Harmoniser:** Make participation feel safe, emphasise no wrong answers
- **Rebel:** Keep it fun, low-pressure, maybe gamify the ask

## User Examples

When drafting, also check for the user's style file at `memory/draft/styles/building-alignment.md`. If it exists, use those real examples as the primary voice reference.
