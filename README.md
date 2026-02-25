# cc-marketplace

A Claude Code plugin marketplace for personal productivity tools.

## Plugins

| Plugin | Description |
|--------|-------------|
| [chief-of-staff](./chief-of-staff/) | AI Chief of Staff for technology executives — strategic briefings, meeting intelligence, decision support, and proactive oversight |

## Installation

Add this marketplace to Claude Code:

```
claude plugins marketplace add github:tenfourty/cc-marketplace
```

Then install a plugin:

```
claude plugins install chief-of-staff
```

## Dependencies

Plugins in this marketplace rely on the following tools:

- **[kbx](https://github.com/tenfourty/kbx)** — Local knowledge base with hybrid search across meetings, people, projects, and notes
- **[guten-morgen (gm)](https://github.com/tenfourty/guten-morgen)** — Calendar events and cross-source task management (Morgen, Linear, Notion)

These must be installed and configured before using the plugins. See each tool's repository for setup instructions.

## Licence

MIT — see [LICENSE](LICENSE).
