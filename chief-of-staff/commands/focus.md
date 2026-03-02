---
description: Resize tmux panes to spotlight a specific agent. Usage: /focus [ops|briefer|advisor|reset]
user_invocable: true
args: target
---

# Focus

Adjust the tmux layout to spotlight a specific agent's pane. Works from any agent in the cos-team.

**Input:** One of `ops`, `briefer`, `advisor`, or `reset`.

## Layouts

### `/focus ops` — Spotlight ops (70/30)
```
┌────────────────────────────┬───────────┐
│                            │ briefer   │
│         ops (70%)          ├───────────┤
│                            │ advisor   │
└────────────────────────────┴───────────┘
```
ops_width = 70%, briefer_height = 50%

### `/focus briefer` — Spotlight briefer (30/70, briefer 70% height)
```
┌───────────┬────────────────────────────┐
│           │                            │
│           │     briefer (70%)          │
│ ops (30%) │                            │
│           ├────────────────────────────┤
│           │     advisor (30%)          │
└───────────┴────────────────────────────┘
```
ops_width = 30%, briefer_height = 70%

### `/focus advisor` — Spotlight advisor (30/70, advisor 70% height)
```
┌───────────┬────────────────────────────┐
│           │     briefer (30%)          │
│ ops (30%) ├────────────────────────────┤
│           │                            │
│           │     advisor (70%)          │
│           │                            │
└───────────┴────────────────────────────┘
```
ops_width = 30%, briefer_height = 30%

### `/focus reset` — Default layout (45/55)
```
┌──────────────────┬──────────────────────┐
│                  │  briefer             │
│  ops (45%)       ├──────────────────────┤
│                  │  advisor             │
└──────────────────┴──────────────────────┘
```
ops_width = 45%, briefer_height = 50%

## Process

### 1. Identify the target

Parse the argument. If missing or unrecognised, ask: "Focus on which agent? (ops / briefer / advisor / reset)"

### 2. Discover tmux state

```bash
# Get current session and window
tmux display-message -p '#{session_name}:#{window_index}'

# List panes with IDs
tmux list-panes -t SESSION:WINDOW -F '#{pane_id}'
```

There should be 3 panes. Identify which is ops, briefer, and advisor by checking `pane-border-format`:
```bash
tmux display-message -t %PANE_ID -p '#{pane-border-format}'
```
Match the pane to its agent by looking for "ops", "briefer", or "advisor" in the border format string.

### 3. Get window dimensions and compute target sizes

```bash
tmux display-message -p '#{window_width} #{window_height}'
```

Use the proportions from the Layouts section to compute pixel sizes:

| Layout | ops_width | briefer_height |
|--------|-----------|----------------|
| ops | 70% of window_width | 50% of window_height |
| briefer | 30% of window_width | 70% of window_height |
| advisor | 30% of window_width | 30% of window_height |
| reset | 45% of window_width | 50% of window_height |

### 4. Resize panes

Two `resize-pane` commands are all that's needed:

```bash
# Set ops width (adjusts the left/right column boundary)
tmux resize-pane -t %OPS_PANE_ID -x OPS_WIDTH

# Set briefer height (adjusts the top/bottom split in the right column)
tmux resize-pane -t %BRIEFER_PANE_ID -y BRIEFER_HEIGHT
```

Replace `%OPS_PANE_ID` and `%BRIEFER_PANE_ID` with the actual pane IDs from step 2. Replace `OPS_WIDTH` and `BRIEFER_HEIGHT` with the computed pixel values from step 3.

### 5. Confirm

After applying, output a one-line confirmation: "Focused on [target]." or "Layout reset to default."

## Notes

- This command does NOT change pane titles — those remain as set during boot-team.
- All agents can run this command. The tmux layout is a window-level setting, so any pane can change it.
- If the team is not booted (fewer than 3 panes), tell the user: "CoS team not running — /focus requires 3 panes."
