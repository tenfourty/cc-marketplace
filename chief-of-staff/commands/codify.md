---
description: Distil universal principles, strategies, and best practices from your meetings on any topic. Designed for sharing with new hires, the community, or for re-examining your own beliefs.
user_invocable: true
args: topic
---

# Codify

You are extracting timeless, shareable knowledge from the executive's meetings and conversations. The goal is to distil universal principles that any startup could apply — stripping out identifying details while preserving strategic value.

Use the **staff voice**: structured, clear, authoritative. The output should read like a polished handbook section, not meeting notes.

## Process

### 1. Get the Topic

If no topic is provided, ask:

> "Which topic or idea would you like distilled? Examples: GTM strategy, marketing, recruitment, engineering culture, fundraising, product-market fit, pricing, or any area of focus for startups."

Wait for the answer before proceeding.

### 2. Deep Search

This is a knowledge extraction task — cast the widest possible net.

**Generate search terms:** From the user's topic, generate 8-12 related search terms and semantic variants. For example, if the topic is "GTM strategy":
- "go to market"
- "sales motion"
- "first customers"
- "distribution"
- "launch strategy"
- "pricing"
- "market entry"
- "customer acquisition"
- "channel strategy"
- "product-market fit"
- "ideal customer profile"
- "first 10 customers"

**Search kbx with all terms:**
- `kbx search "term" --json --full-chunks --limit 10` for each semantic variant (embeddings / semantic search)
- `kbx search "term" --fast --json --full-chunks` for keyword matches
- If early results surface specific sub-themes or terminology not in the initial list, generate additional search terms and search for those too
- Iterate until coverage feels thorough — don't stop at the first round

**Read results in parallel:** From the search results, identify the 10-15 most relevant entries. Spawn background sub-agents to extract knowledge in parallel — one agent per 3-4 documents.

- `model: "haiku"` and `run_in_background: true`
- Do NOT pass `team_name` — these are anonymous workers, not team members
- **Source preference:** When search results include multiple file types for the same meeting, prefer `.transcript.md` (richest detail) over `.notes.md` or `.ai-summary.md`
- Pass the `content` field from `--full-chunks` search results directly to each agent — no need for follow-up `kbx view` calls. If a document needs deeper context beyond the matching chunks, the agent can use `kbx view <path> --plain` for the full file.
- Prompt each agent with: the chunk content, the topic being codified, and the extraction targets (principles, strategies, anti-patterns, decision frameworks)
- Ask each agent to return: extracted principles, actionable insights, notable quotes, and which meetings/contexts they came from
- Look for meetings where this topic was discussed substantively, not just mentioned in passing

Collect results from all background agents before proceeding to Step 3. Pay attention to insights from different people — the same topic discussed in different contexts yields richer principles.

**Supplementary sources:**
- Slack MCP for related discussions and informal takes
- Notion MCP for any existing documents on the topic

### 3. Synthesise

From all the gathered material, extract:

- **General principles and frameworks** that apply broadly
- **Actionable strategies and tactics** without company-specific context
- **Universal patterns and best practices**
- **Foundational beliefs and philosophies**
- **Common mistakes and anti-patterns**
- **Decision frameworks** specific to this domain

Focus on what's universal. If the same insight appears across multiple conversations with different people, it's likely a genuine principle worth capturing.

### 4. Anonymise

**Exclude and do not reference:**
- Specific company names, founder names, or individuals
- Details about active fundraising rounds or fundraising status
- Company-specific financial metrics or valuation information
- Proprietary strategies tied to individual companies

Present all insights as standalone principles. Replace specifics with archetypes: "one B2B SaaS company" instead of naming them, "a Series A startup" instead of identifying them.

### 5. Present

Structure the output as a shareable handbook section:

```
## [Topic]: Principles and Best Practices

### Core Beliefs
[2-4 foundational philosophies that underpin the best approaches to this topic]

### Key Principles
[5-8 universal principles, each with a short heading and 2-3 sentences of explanation]

### Strategies That Work
[Actionable approaches, ordered from most fundamental to most advanced]

### Common Mistakes
[Anti-patterns and pitfalls observed across multiple contexts]

### Decision Framework
[How to think about key decisions in this domain — when to do X vs Y]

### Further Reading
[If relevant: books, frameworks, or concepts referenced in the meetings]
```

### 6. Offer Next Steps

- "Want me to publish this to Notion?" (use Notion MCP to create a page)
- "Want me to go deeper on any of these principles?"
- "Should I codify another topic?"
