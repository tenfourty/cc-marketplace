# Life Domains

Seven life domains for assessment, focus selection, and balanced growth. Based on the Wheel of Life (Paul J. Meyer, 1960), adapted for coaching.

## The 7 Domains

| # | Domain | Covers |
|---|--------|--------|
| 1 | **Health & Energy** | Physical health, sleep, nutrition, exercise, energy, stress, vitality |
| 2 | **Relationships** | Family, friendships, romantic, community, social connection |
| 3 | **Career & Purpose** | Work fulfillment, mission alignment, professional growth, impact |
| 4 | **Finances** | Income, savings, investments, debt, financial freedom, money relationship |
| 5 | **Growth & Learning** | Education, skills, curiosity, reading, mental models, development |
| 6 | **Fun & Adventure** | Play, creativity, travel, hobbies, spontaneity, joy |
| 7 | **Inner Life** | Mindfulness, spirituality, self-awareness, emotional intelligence, meaning |

Read `resources/domains/<domain-name>.md` for deep-dive coaching questions, patterns, and exercises per domain.

## Wheel of Life Assessment

**Scoring:** 1-10 per domain. Walk through each domain: brief description, ask for score, ask one follow-up question. Present the scale before scoring begins:

| 1-2 | Crisis or deep neglect. |
| 3-4 | Struggling. Needs real attention. |
| 5 | Getting by, nothing special. |
| 6-7 | Good. Solid, room to grow. |
| 8-9 | Thriving, genuinely fulfilled. |
| 10 | Peak — couldn't ask for more. Rare. |

Don't overthink it. First number that comes to mind is usually right.

**Storage:** `memory/coaching/wheel-of-life/YYYY-MM-DD.md` with YAML frontmatter:

```markdown
---
title: "Wheel of Life — 3 March 2026"
date: 2026-03-03
tags: [wheel-of-life, assessment]
---

| Domain | Score | Note |
|--------|-------|------|
| Health & Energy | 7 | Good sleep, need more exercise |
| Relationships | 6 | Strong family, missing friends |
| Career & Purpose | 8 | Aligned but overworked |
| Finances | 5 | Stable income, no savings plan |
| Growth & Learning | 7 | Reading lots, want to learn Spanish |
| Fun & Adventure | 4 | All work, no play |
| Inner Life | 6 | Meditation sporadic |
```

**Trend tracking:** Compare to previous assessments. Highlight biggest changes (up or down). Surface domains that have been low for multiple assessments.

**Frequency:** Initial assessment during `/inner-game:setup`. Then quarterly, or when selecting a new focus area.

## Focus Area Selection

After a Wheel assessment, help choose one primary focus area (+ optional secondary).

**Selection criteria:**
1. Lowest score alone isn't enough — ask "which area has the most energy for change?"
2. Consider cross-domain leverage (Health affects everything)
3. Consider Document alignment — which domain connects most to identity declarations?
4. Consider current life context — don't pick Finances during a relationship crisis

**Duration:** 4-8 weeks. Review at each `/inner-game:review`.

**Storage:** Pinned kbx note tagged `focus-area, inner-game`. Replace previous focus area note on change.

## Cross-Domain Connections

No domain exists in isolation. Surface these when relevant:

| If This Domain Is Low | Also Check |
|----------------------|------------|
| Health & Energy | Everything — energy is the foundation |
| Relationships | Inner Life (self-relationship first), Fun (shared activities) |
| Career & Purpose | Inner Life (meaning), Growth (skills gap) |
| Finances | Career (income source), Inner Life (money beliefs) |
| Growth & Learning | Career (application), Fun (curiosity as play) |
| Fun & Adventure | Relationships (shared joy), Health (recovery/play) |
| Inner Life | Health (mind-body), Relationships (connection quality) |
