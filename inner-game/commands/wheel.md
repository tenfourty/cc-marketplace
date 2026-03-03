---
description: Wheel of Life assessment — score all 7 domains, compare trends. 10-15 minutes.
user_invocable: true
---

# Wheel

Coaching voice. Walk through all 7 life domains, score each, identify focus areas.

## Process

### 1. Load Context

- Previous Wheel assessment: most recent in `memory/coaching/wheel-of-life/`
- Read life-domains skill for domain definitions
- Current focus area (for comparison)

### 2. Introduction

First time: "The Wheel of Life is a simple check-in across seven areas of your life. Rate each one 1-10 based on how satisfied you are right now — not how you think you should feel."

Returning: "Let's update your Wheel. Same seven areas — how are things today?"

### 3. Walk Through Domains

For each of the 7 domains, in order:

1. **Health & Energy** — physical health, sleep, nutrition, exercise, energy, vitality
2. **Relationships** — family, friendships, romantic, community
3. **Career & Purpose** — work fulfillment, mission, growth, impact
4. **Finances** — income, savings, debt, freedom, money relationship
5. **Growth & Learning** — education, skills, curiosity, development
6. **Fun & Adventure** — play, creativity, travel, hobbies, joy
7. **Inner Life** — mindfulness, spirituality, self-awareness, meaning

For each:
- Brief description (one sentence)
- "How would you rate [domain] right now? (1-10)"
- One follow-up question based on the score:
  - Score ≤ 4: "What would a half-point improvement look like?"
  - Score 5-7: "What's keeping this from being higher?"
  - Score ≥ 8: "What's working well here?"

### 4. Present Results

Show scores as a table. If previous assessment exists, show comparison:

```
Domain              Now  Prev  Change
Health & Energy      7    6     +1
Relationships        6    6      =
Career & Purpose     8    7     +1
Finances             5    5      =
Growth & Learning    7    8     -1
Fun & Adventure      4    3     +1
Inner Life           6    5     +1
```

Highlight: highest score, lowest score, biggest change (up or down).

### 5. Discuss

- "What stands out to you looking at these numbers?"
- If big gap between highest and lowest: "There's a [N]-point gap between [highest] and [lowest]. What does that tell you?"
- Reference cross-domain connections from life-domains skill

### 6. Bridge to Focus

If no focus area set or current focus seems stale: "Would you like to choose a focus area based on what you're seeing? We can do that now with `/ig:focus`."

Don't push — offer.

### 7. Save Assessment

Write to `memory/coaching/wheel-of-life/YYYY-MM-DD.md`:

```yaml
---
title: "Wheel of Life — [human-readable date]"
date: YYYY-MM-DD
tags: [wheel-of-life, assessment]
---
```

Include score table with notes, comparison to previous (if exists), key observations.

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| No previous assessment | Skip comparison — this is the baseline |
| Life-domains skill missing | Use inline domain descriptions above |
| Write fails | Present results conversationally |
