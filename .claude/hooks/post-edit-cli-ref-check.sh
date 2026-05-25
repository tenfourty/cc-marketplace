#!/bin/bash
# PostToolUse hook: when a plugin command/skill/prompt is edited, remind the
# agent to re-verify any external CLI references (kbx, gm, etc.) against the
# current --help output. cc-marketplace plugins are consumers — their docs
# can drift silently when the producer CLIs change.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

case "$FILE_PATH" in
  */commands/*.md|*/skills/*/SKILL.md|*/scripts/prompts/*.md) ;;
  *) exit 0 ;;
esac

cat <<'EOF'
You edited a CoS plugin command/skill/prompt. Verify any `kbx` / `gm` CLI references against the current `--help` (the LLM contract). For `gm` event-vs-task filtering, cross-check the `## Scoping axes` section in `gm --help` — events and tasks scope on independent axes (`--group` only narrows events). Update if drifted.
EOF

exit 0
