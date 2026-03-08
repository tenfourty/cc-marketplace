#!/bin/bash
# cos-focus.sh — Resize tmux panes to spotlight a CoS team agent.
#
# Usage:
#   bash chief-of-staff/scripts/cos-focus.sh <agent|reset>
#   agent: ops | briefer | advisor
#   reset: restore default 45/55 layout
#
# Layout (2-column: ops left, briefer/advisor stacked right):
#
# /focus ops (70/30):
# ┌────────────────────────────┬───────────┐
# │                            │ briefer   │
# │         ops (70%)          ├───────────┤
# │                            │ advisor   │
# └────────────────────────────┴───────────┘
#
# /focus briefer (30/70, briefer 70% height):
# ┌───────────┬────────────────────────────┐
# │           │     briefer (70%)          │
# │ ops (30%) ├────────────────────────────┤
# │           │     advisor (30%)          │
# └───────────┴────────────────────────────┘
#
# /focus advisor (30/70, advisor 70% height):
# ┌───────────┬────────────────────────────┐
# │           │     briefer (30%)          │
# │ ops (30%) ├────────────────────────────┤
# │           │     advisor (70%)          │
# └───────────┴────────────────────────────┘
#
# /focus reset (45/55, default):
# ┌──────────────────┬──────────────────────┐
# │                  │  briefer (50%)       │
# │  ops (45%)       ├──────────────────────┤
# │                  │  advisor (50%)       │
# └──────────────────┴──────────────────────┘

set -euo pipefail

# --- Auto-detect window by finding the one with an "ops" pane ---
WINDOW=""
for win in $(tmux list-windows -a -F '#{session_name}:#{window_index}'); do
    for pane_id in $(tmux list-panes -t "$win" -F '#{pane_id}' 2>/dev/null); do
        fmt=$(tmux show-options -p -t "$pane_id" -v pane-border-format 2>/dev/null || true)
        if echo "$fmt" | grep -q '"ops"'; then
            WINDOW="$win"
            break 2
        fi
    done
done

if [ -z "$WINDOW" ]; then
    echo "ERROR: Could not find a tmux window with an 'ops' pane. Is the CoS team booted?" >&2
    exit 1
fi

# --- Get window dimensions dynamically ---
WIN_WIDTH=$(tmux display-message -t "$WINDOW" -p '#{window_width}')
WIN_HEIGHT=$(tmux display-message -t "$WINDOW" -p '#{window_height}')

# --- Discover panes by their border-format labels ---
discover_pane() {
    local label="$1"
    for pane_id in $(tmux list-panes -t "$WINDOW" -F '#{pane_id}'); do
        local fmt
        fmt=$(tmux show-options -p -t "$pane_id" -v pane-border-format 2>/dev/null || true)
        if echo "$fmt" | grep -q "\"$label\""; then
            echo "$pane_id"
            return
        fi
    done
}

OPS=$(discover_pane "ops")
BRIEFER=$(discover_pane "briefer")
ADVISOR=$(discover_pane "advisor")

# Validate all panes found
for name in OPS BRIEFER ADVISOR; do
    if [ -z "${!name}" ]; then
        echo "ERROR: Could not find pane for $name. Are pane border-formats set?" >&2
        exit 1
    fi
done

# --- Get pane indices (needed for layout strings) ---
pane_index() {
    tmux display-message -t "$1" -p '#{pane_index}'
}

idx_ops=$(pane_index "$OPS")
idx_briefer=$(pane_index "$BRIEFER")
idx_advisor=$(pane_index "$ADVISOR")

# --- Compute tmux layout checksum ---
layout_checksum() {
    python3 -c "
layout = '''$1'''
csum = 0
for c in layout:
    csum = (csum >> 1) + ((csum & 1) << 15)
    csum += ord(c)
print(f'{csum & 0xffff:04x},{layout}')
"
}

# --- Parse argument ---
target="${1:-}"

if [ -z "$target" ]; then
    echo "Usage: $0 <ops|briefer|advisor|reset>"
    exit 1
fi

# --- Build and apply layout ---
W=$WIN_WIDTH
H=$WIN_HEIGHT

case "$target" in
    ops)
        # ops: 70% width, briefer/advisor stacked 30% (50/50 height)
        ops_w=$((W * 70 / 100))
        right_w=$((W - ops_w - 1))  # -1 for border
        top_h=$((H / 2))
        bot_h=$((H - top_h - 1))    # -1 for border
        right_x=$((ops_w + 1))
        bot_y=$((top_h + 1))

        layout="${W}x${H},0,0{${ops_w}x${H},0,0,${idx_ops},${right_w}x${H},${right_x},0[${right_w}x${top_h},${right_x},0,${idx_briefer},${right_w}x${bot_h},${right_x},${bot_y},${idx_advisor}]}"
        result=$(layout_checksum "$layout")
        tmux select-layout -t "$WINDOW" "$result"
        tmux select-pane -t "$OPS"
        echo "Focused on ops (${W}x${H})."
        ;;

    briefer)
        # ops: 30% width, briefer: 70% height, advisor: 30% height
        ops_w=$((W * 30 / 100))
        right_w=$((W - ops_w - 1))
        briefer_h=$((H * 70 / 100))
        advisor_h=$((H - briefer_h - 1))
        right_x=$((ops_w + 1))
        advisor_y=$((briefer_h + 1))

        layout="${W}x${H},0,0{${ops_w}x${H},0,0,${idx_ops},${right_w}x${H},${right_x},0[${right_w}x${briefer_h},${right_x},0,${idx_briefer},${right_w}x${advisor_h},${right_x},${advisor_y},${idx_advisor}]}"
        result=$(layout_checksum "$layout")
        tmux select-layout -t "$WINDOW" "$result"
        tmux select-pane -t "$BRIEFER"
        echo "Focused on briefer (${W}x${H})."
        ;;

    advisor)
        # ops: 30% width, briefer: 30% height, advisor: 70% height
        ops_w=$((W * 30 / 100))
        right_w=$((W - ops_w - 1))
        briefer_h=$((H * 30 / 100))
        advisor_h=$((H - briefer_h - 1))
        right_x=$((ops_w + 1))
        advisor_y=$((briefer_h + 1))

        layout="${W}x${H},0,0{${ops_w}x${H},0,0,${idx_ops},${right_w}x${H},${right_x},0[${right_w}x${briefer_h},${right_x},0,${idx_briefer},${right_w}x${advisor_h},${right_x},${advisor_y},${idx_advisor}]}"
        result=$(layout_checksum "$layout")
        tmux select-layout -t "$WINDOW" "$result"
        tmux select-pane -t "$ADVISOR"
        echo "Focused on advisor (${W}x${H})."
        ;;

    reset)
        # ops: 45% width, briefer/advisor stacked 55% (50/50 height)
        ops_w=$((W * 45 / 100))
        right_w=$((W - ops_w - 1))
        top_h=$((H / 2))
        bot_h=$((H - top_h - 1))
        right_x=$((ops_w + 1))
        bot_y=$((top_h + 1))

        layout="${W}x${H},0,0{${ops_w}x${H},0,0,${idx_ops},${right_w}x${H},${right_x},0[${right_w}x${top_h},${right_x},0,${idx_briefer},${right_w}x${bot_h},${right_x},${bot_y},${idx_advisor}]}"
        result=$(layout_checksum "$layout")
        tmux select-layout -t "$WINDOW" "$result"
        echo "Layout reset to default (${W}x${H})."
        ;;

    *)
        echo "Unknown target: $target"
        echo "Options: ops | briefer | advisor | reset"
        exit 1
        ;;
esac
