# cc-marketplace — LLM Context

Claude Code plugin marketplace for personal productivity tools. Three plugins:

| Plugin | Purpose |
|--------|---------|
| `chief-of-staff/` | AI Chief of Staff — briefings, meeting intel, decisions. See [`chief-of-staff/CLAUDE.md`](chief-of-staff/CLAUDE.md) for the per-plugin contract. |
| `draft/` | Voice-aware Slack/email drafting. |
| `inner-game/` | Personal coaching + journaling. |

## External Dependencies (consumer-side)

Plugins call out to two project CLIs:

- **`kbx`** (knowledge base) — `tenfourty/kbx`. Source of truth for people, projects, meetings, notes, decisions.
- **`gm`** (calendar + tasks) — `tenfourty/guten-morgen`. Calendar events and Morgen tasks.

Plugins are **consumers** — they reference these CLIs in command bodies, skill instructions, and unattended prompts. When the producer CLIs change command syntax, plugin docs can silently drift.

## Claude Code Hooks

`.claude/settings.json` configures one PostToolUse hook:

- **`post-edit-cli-ref-check.sh`** — fires after `Edit`/`Write`/`MultiEdit` on plugin content paths (`*/commands/*.md`, `*/skills/*/SKILL.md`, `*/scripts/prompts/*.md`). Emits a reminder to re-verify any `kbx` / `gm` command syntax against the current `--help` output before considering the edit done. Consumer-side mirror of the kbx `check-agent-playbook.sh` and gm equivalent.

The hook reads stdin JSON for `tool_input.file_path` and matches with a bash `case` glob. Silent (`exit 0`, no stdout) for non-matching paths.

## Release

`release-please` owns versioning per-plugin via conventional commits. Do **not** manually bump `plugin.json` or `marketplace.json` versions — push a `fix:` / `feat:` / `chore:` commit and the release PR will auto-open, auto-merge, and publish.

## Privacy

cc-marketplace is **public**. Plugin files must contain zero PII — no real names, no internal team names, no company-specific details. Personal voice profiles, examples, and identity content live in the consumer's private `memory/` directory (loaded at runtime via kbx), never in the plugin.
