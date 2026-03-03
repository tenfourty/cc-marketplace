---
description: First-run onboarding — establish coaching relationship, initial assessment, preferences. 20-30 minutes.
user_invocable: true
---

# Setup

Coaching voice. One-time onboarding. Runs automatically on first `/ig:boot` if no setup note exists.

## Pre-check

Search kbx for existing setup: `kbx search "inner-game-setup" --tag inner-game-setup --limit 1 --json`

If found: "You've already completed setup. Want to review or update your profile?" Offer to re-run specific sections.

## Process

### 1. Welcome

"Welcome. I'm your coach — here to help you reduce the interference between who you are and who you're capable of being. Let's spend about 20 minutes getting to know each other."

### 2. Who Are You?

- "What should I call you?"
- "In a few sentences, what's your life like right now?"
- "What brought you to coaching? What are you hoping for?"

### 3. Initial Wheel of Life (Quick Version)

Walk through all 7 domains, one at a time. For each:
- Brief description of what the domain covers
- "How would you rate this area of your life right now? (1-10)"
- One follow-up question based on the score

Save scores — this becomes the first Wheel of Life assessment.

### 4. Current Challenge

"What's the one thing that, if it changed, would make the biggest difference in your life right now?"

Explore briefly — this informs the initial focus area suggestion.

### 5. Coaching Preferences

- "How direct do you want me to be? Some people want gentle nudges, others want me to call it like I see it."
- "Morning person or night owl? When do you have the most energy for reflection?"
- "Have you journaled before? What worked or didn't?"

### 6. Save Profile

Create kbx note:
```bash
kbx memory add "Inner Game Setup Profile" \
  --body "[structured profile from conversation]" \
  --tags inner-game-setup,inner-game \
  --pin
```

Save first Wheel of Life assessment to `memory/coaching/wheel-of-life/YYYY-MM-DD.md`.

### 7. Suggest Next Steps

Based on what emerged:
- If they're ready for depth: suggest `/ig:document` to start The Document journey
- If they want to start light: suggest `/ig:morning` for daily ritual
- If one domain is urgent: suggest `/ig:focus` to set a focus area

"There's no rush. We'll go at your pace."

## Graceful Degradation

| Missing | Fallback |
|---------|----------|
| kbx unavailable | Save profile as local file, note that kbx should be configured |
| User wants to skip sections | Let them — capture what they're willing to share |
| User is resistant | Respect it. "We can come back to this anytime." |
