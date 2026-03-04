# Connected Tools

## Primary Tools

### kbx — Knowledge Base CLI

People context, PCM profiles, and topic research.

```bash
# Look up a person (PCM profile, role, team)
kbx person find "Name" --json

# Search for topic context
kbx search "deployment process" --json --limit 5

# Fast keyword search
kbx search "incident postmortem" --fast --json --limit 5
```

## Slack MCP (claude.ai Integration)

Message delivery and context gathering.

- `slack_send_message` — send drafted message to a channel or DM
- `slack_send_message_draft` — send as draft for user review in Slack
- `slack_search_public` — search for recent messages about a topic
- `slack_read_channel` — read recent messages from a channel
- `slack_read_thread` — read a thread for context
- `slack_search_users` — look up user IDs for @mentions

## Gmail MCP (claude.ai Integration)

Optional email delivery.

- `gmail_create_draft` — create email draft in Gmail
- `gmail_search_messages` — search for prior email threads on a topic

## Graceful Degradation

| Missing Tool | Fallback |
|-------------|----------|
| kbx unavailable | Draft without PCM adaptation; skip topic research |
| Slack MCP unavailable | Present message as copy-paste text only |
| Gmail MCP unavailable | Present email as formatted text for manual send |
| PCM profile not found | Draft without audience adaptation; note it |
