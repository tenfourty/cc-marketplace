#!/usr/bin/env bash
set -euo pipefail

# Build a clean release zip of the chief-of-staff plugin.
# Usage: ./scripts/release.sh
# Output: releases/chief-of-staff-<version>.zip

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Read version from plugin.json
VERSION=$(python3 -c "import json; print(json.load(open('$PLUGIN_DIR/.claude-plugin/plugin.json'))['version'])")
NAME="chief-of-staff"
RELEASE_DIR="$PLUGIN_DIR/releases"
ZIP_NAME="${NAME}-${VERSION}.zip"

echo "Building release: $ZIP_NAME"

mkdir -p "$RELEASE_DIR"

# Build zip from the plugin directory, excluding dev/local files
cd "$PLUGIN_DIR"
zip -r "$RELEASE_DIR/$ZIP_NAME" . \
  -x ".git/*" \
  -x ".claude/settings.local.json" \
  -x "docs/plans/*" \
  -x "releases/*" \
  -x "scripts/release.sh" \
  -x ".DS_Store" \
  -x "*/.DS_Store"

echo ""
echo "Release built: releases/$ZIP_NAME"
echo ""
echo "Installation options for the recipient:"
echo ""
echo "  1. Unzip and use directly:"
echo "     unzip $ZIP_NAME -d $NAME"
echo "     claude --plugin-dir ./$NAME"
echo ""
echo "  2. Install to plugin cache:"
echo "     unzip $ZIP_NAME -d ~/.claude/plugins/cache/cc-marketplace/$NAME/$VERSION"
echo "     # Then enable in ~/.claude/settings.json:"
echo "     # \"enabledPlugins\": { \"$NAME@cc-marketplace\": true }"
echo ""
echo "  3. Add as local marketplace:"
echo "     claude plugins marketplace add /path/to/cc-marketplace"
echo "     claude plugins install $NAME"
