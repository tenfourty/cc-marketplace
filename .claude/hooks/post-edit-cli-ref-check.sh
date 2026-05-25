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
You edited a CoS plugin command/skill/prompt. If it references `kbx`, `gm`, or any external CLI, verify the command syntax matches the current version (`kbx --help` / `gm --help`). Update if drifted.
EOF

exit 0
