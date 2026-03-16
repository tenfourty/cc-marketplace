---
description: >
  Inbox triage across any messaging platform. Walks through items one-by-one,
  proposes actions, drafts replies, enriches kbx contacts, and captures tasks.
  Applies GTD inbox processing: two-minute rule, one-touch, capture-to-task-manager.
user_invocable: true
---

# Inbox Sweep

Triage any inbox and enrich your contact knowledge base in one pass. The core
loop: for each item, read the messages, recall what you know about the people
involved, propose an action, enrich their profiles, move on.

## Voice

**Staff voice.** Efficient, structured, action-oriented. Present each item as a
compact triage card — summary, recommended action, proposed enrichment — and wait
for confirmation before proceeding.

---

## Step 1: Check Available Sources

Read the **CoS Configuration** pinned note (from `kbx context` output) and check
the `## Connected Sources` section. Inbox sweep can work with any combination of:

| Category | What it provides |
|----------|-----------------|
| messaging | Personal messaging (WhatsApp, Signal, Telegram, iMessage via aggregator) |
| chat | Work messaging (team channels, DMs, threads) |
| email | Email inbox (threads, sent mail) |

Also required:
- **kbx** — always required (entity lookup, enrichment, search)
- **Task backend** — for capturing actions (see task-backend skill)

If the user asks to sweep a source that isn't connected, tell them which category
is needed and suggest running `/setup` to add it. If no messaging, chat, or email
source is connected at all, stop: "No inbox sources connected. Run `/setup` to
connect messaging, chat, or email."

## Step 2: First-Run Preferences

On the first sweep, ask three questions. Store answers in the CoS Configuration
note (append a `## Sweep Preferences` section) so they persist across sessions.

1. **Which inbox?** "Which inbox do you want to sweep — messaging, email, work
   chat, or all of them?"
2. **Pinning preferences:** "Besides immediate family, are there people you'd like
   pinned in your agent context — close friends, your boss, direct reports?"
3. **Task handling:** "When I find something actionable, should I create tasks
   automatically, or just flag them for you?"

On subsequent runs, read existing preferences from the config note. Offer to
change them only if the user asks.

## Step 3: Check Stale Contacts

Run `kbx entity stale --days 30 --type person --json`. Note any pinned or
high-value contacts (family, close friends) that appear stale. You'll weave
nudges into the sweep if they come up, or surface them at the end if they don't.

## Step 4: Load Inbox Items

Load the inbox for each selected source using the connected tools:

- **Messaging:** list recent chats with unread or recent activity
- **Email:** search inbox for recent/unread threads
- **Chat:** read nominated channels or recent DMs

Present: "Found N items across [sources]. Starting sweep."

---

## GTD Principles

Apply these throughout:

**Two-minute rule.** If a reply takes less than two minutes, draft it immediately.
Don't defer quick items.

**One-touch.** Handle each item exactly once. Don't skip to come back later.
Decide now: do it, delegate it, defer it (as a task), or archive it.

**Capture, don't remember.** Anything that needs follow-up becomes a task — not a
mental note, not a kbx fact. Facts are for timeless knowledge; tasks are for
actions.

---

## The Sweep Loop

Process each item one at a time. Triage and enrichment happen together — while the
messages are in context, that's the best time to extract facts.

### Step 5: Read and Recall

- **Read recent messages** from the conversation using the connected source's tools.
  The default page is usually enough; paginate if the conversation is mid-thread.
- **Look up the person in kbx** using `kbx person find "Name" --json`. If they
  exist, you have their facts, metadata, and relationship context. Use this to
  inform your triage recommendation and any reply you draft.

### Step 6: Propose an Action

Assess the conversation and propose one of:

| Action | When |
|--------|------|
| **Archive** | Conversation is complete, nothing actionable |
| **Quick reply then archive** | Short reply warranted (two-minute rule). You'll draft it. |
| **Reply then archive** | Longer reply needed. Suggest `/draft:draft` for full voice machinery. |
| **Defer** | Needs follow-up but not right now. You'll create a task. |
| **Delegate** | Someone else should handle this. You'll create a task or draft a forwarding message. |
| **Keep** | Must stay visible (e.g., waiting on an imminent response). Use sparingly. |

Present a compact triage card:

```
**[Person Name]** — [platform] — [last activity]
[1-2 sentence summary of what the conversation is about]

→ Recommended: [action] — [brief reason]
→ Enrichment: [proposed facts/metadata, or "profile up to date"]
```

Wait for the user to confirm or override before proceeding.

### Step 7: Draft Reply (If Applicable)

**Quick replies (two-minute rule):** Draft inline. Follow these guidelines:

- **Study the user's voice on that specific platform and with that specific person.**
  Read at least 10-15 of their sent messages. People write very differently to
  their mum vs a colleague vs a friend, and differently on WhatsApp vs email vs
  Slack.
- **Platform tone calibration:**
  - *Messaging apps (WhatsApp, Signal, etc.):* shortest, most casual. Often no
    greeting, no sign-off, abbreviations, emoji. Multiple short messages rather
    than one long one.
  - *Work chat (Slack, Teams):* casual but more structured. Threads, reactions,
    mentions. Company culture matters — read the room.
  - *Email:* most structured. But personal emails to friends can be as casual as
    messaging. Let the thread tone guide you.
- **Match the language** of the conversation. If messages are in French, reply in
  French.
- **When in doubt: shorter, more casual.** The most common feedback is "sounds like
  an AI" — which usually means too formal, too long, too many qualifiers.

**Longer replies:** Suggest `/draft:draft` which has full voice-identity and
audience-adaptation machinery. Don't duplicate that plugin's work.

Show the draft. Wait for approval before sending.

### Step 8: Enrich the Contact

While the messages are in context, enrich the person's kbx profile. Apply the
**Dedup Before Writing** protocol (see information-management skill) for all writes.

#### Creating New Entities (1:1 Conversations)

If the person doesn't exist in kbx, create them and add metadata:

- **Platform identifiers:** chat ID, network (whatsapp, signal, slack, etc.)
- **Category:** `family`, `close-friend`, `personal`, `professional`, `acquaintance`
- **Relationship:** specific if family (Partner, Mother, Brother, Son, etc.)
- **Language:** primary language of the conversation (en, fr, etc.)
- **Preferred platform:** where this person is most easily reached

If they already exist, add platform metadata only if not already present. Don't
overwrite existing metadata from other contexts.

#### Extracting Timeless Facts

The test: would this still be true and useful in 6 months?

**Good facts (timeless):**
- Relationship to user and family ("Wife Rosemary, goes by Rose")
- Where they live, nationality, profession
- Shared interests and recurring topics ("Watch Six Nations together")
- Key people in their life ("Son Sacha plays rugby in Jacou", "Boss Hans")
- Birthdays and significant dates
- Communication style per platform ("French on WhatsApp, English on Slack")

**Not facts — don't persist:**
- Temporary states ("Broke his finger last week")
- Upcoming events ("Birthday party this Saturday")
- Pending actions ("Jeremy still needs to reach out to Thomas") → these are tasks
- Specific scores, election results, weather, current events

**Relationship graph.** When someone mentions another person ("my boss Hans", "my
wife Rose"), note the connection. If the mentioned person exists in kbx, add the
cross-reference on their entity too.

**Always propose facts to the user before persisting.** Present them alongside the
triage card (Step 6). The user knows their contacts better than you do. This is
not optional.

**Consolidate.** Each person should have clean, comprehensive facts — not
overlapping fragments. Read existing facts first (dedup protocol) and propose
updates to existing facts rather than adding duplicates.

#### Group Conversations

- **Existing kbx entities:** enrich based on what they said, same rules as above
- **Unknown participants:** don't create entities by default. If someone appears
  across multiple group conversations or the user interacts with them meaningfully,
  propose: "I've seen [name] in several conversations — add them to your contacts?"
- **Triage the group as a unit** — archive, keep, or reply to the group

### Step 9: Pin (If Applicable)

- **Always pin:** immediate family (partner, parents, children, siblings)
- **Pin per user preferences** (from Step 2): close friends, boss, direct reports,
  whoever the user specified
- **Don't pin:** acquaintances, low-frequency contacts, most professional contacts

### Step 10: Capture Actions as Tasks

If the sweep reveals something the user needs to do, capture it as a task — not a
fact. Use the task-backend skill's commitment routing table:

| Accountability | Destination |
|---------------|-------------|
| User personally accountable | Task (active or right-now) |
| User following up on someone | Task (waiting-on) |
| Delegated to someone | Person/project entity Open Items |

Set due dates when there's an obvious deadline. Link to kbx projects when
applicable (see task-backend skill for project linking rules).

If no task backend is configured, collect all flagged actions and present them as
a list at the end of the sweep.

### Step 11: Stale Contact Nudges

If a chat's last message was months ago, or if a person flagged as stale (Step 3)
comes up during the sweep, nudge: "You haven't spoken to [name] since [month] —
send a quick check-in, or just archive?"

Especially valuable for pinned/family/close-friend contacts who have gone quiet.
For acquaintances, note it and move on.

### Step 12: Archive or Keep, Then Next

Execute the confirmed action and proceed to the next item.

---

## After the Sweep

Present a summary:

```
## Sweep Summary

**Items processed:** N (archived: X, replied: Y, deferred: Z, kept: W)
**Contacts enriched:** [who was created/updated, key facts added]
**Tasks created:** [list with status and area]
**Stale contacts:** [any pinned/important contacts from Step 3 that didn't come
up — ask if the user wants to reach out]
```

---

## Handling Corrections

When the user corrects a fact:
1. Look up the entity: `kbx person find "Name" --json`
2. Read the entity file: `kbx view <path> --plain`
3. Use the Edit tool to fix the fact in the entity file
4. Check if the same incorrect information appears on related entities (e.g., a
   birthday referenced on a family member's entity too)

If you hit a tool limitation, tell the user directly rather than inventing
workarounds.

---

## Subsequent Runs

This command is designed to be re-run regularly:

- People already in kbx don't need re-creation — but new facts from recent
  conversations can still be proposed
- Focus on items with new/unread messages since the last sweep
- Existing facts and pinned contacts make reply drafting better each time
- Preferences from the first run are stored in the CoS Configuration note
- Run `kbx entity stale` at the start of each sweep to catch contacts needing
  attention

---

## Graceful Degradation

| Missing source | Behaviour |
|----------------|-----------|
| No messaging source | Skip messaging inbox, note it |
| No chat source | Skip work chat inbox, note it |
| No email source | Skip email inbox, note it |
| No task backend | Collect actions as a list instead of creating tasks |
| No kbx | Cannot run — kbx is required |

Always deliver whatever sweep is possible with available sources. Tell the user
what you couldn't check and why.
