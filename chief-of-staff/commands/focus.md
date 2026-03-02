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
Layout string: `256x70,0,0{178x70,0,0,OPS,77x70,179,0[77x34,179,0,BRIEFER,77x35,179,35,ADVISOR]}`

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
Layout string: `256x70,0,0{77x70,0,0,OPS,178x70,78,0[178x48,78,0,BRIEFER,178x21,78,49,ADVISOR]}`

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
Layout string: `256x70,0,0{77x70,0,0,OPS,178x70,78,0[178x21,78,0,BRIEFER,178x48,78,22,ADVISOR]}`

### `/focus reset` — Default layout (45/55)
```
┌──────────────────┬──────────────────────┐
│                  │  briefer             │
│  ops (45%)       ├──────────────────────┤
│                  │  advisor             │
└──────────────────┴──────────────────────┘
```
Layout string: `256x70,0,0{114x70,0,0,OPS,141x70,115,0[141x34,115,0,BRIEFER,141x35,115,35,ADVISOR]}`

## Process

### 1. Identify the target

Parse the argument. If missing or unrecognised, ask: "Focus on which agent? (ops / briefer / advisor / reset)"

### 2. Discover tmux state

```bash
# Get current session and window
tmux display-message -p '#{session_name}:#{window_index}'

# List panes with IDs and indices
tmux list-panes -t SESSION:WINDOW -F '#{pane_id} #{pane_index} #{pane_top} #{pane_left}'
```

There should be 3 panes. Identify which is ops, briefer, and advisor by checking `pane-border-format`:
```bash
tmux display-message -t %PANE_ID -p '#{pane-border-format}'
```
Match the pane to its agent by looking for "ops", "briefer", or "advisor" in the border format string.

### 3. Select the layout string

Pick the layout string from the Layouts section above based on the target. Replace `OPS`, `BRIEFER`, `ADVISOR` with the actual pane indices from step 2.

### 4. Compute checksum and apply

```bash
python3 -c "
layout = 'LAYOUT_STRING_HERE'
# Replace OPS, BRIEFER, ADVISOR with actual pane indices
# layout = layout.replace('OPS','0').replace('BRIEFER','1').replace('ADVISOR','2')
csum = 0
for c in layout:
    csum = (csum >> 1) + ((csum & 1) << 15)
    csum += ord(c)
print(f'{csum & 0xffff:04x},{layout}')
"
```

Apply:
```bash
tmux select-layout -t SESSION:WINDOW '<checksum>,<layout>'
```

### 5. Confirm

After applying, output a one-line confirmation: "Focused on [target]." or "Layout reset to default."

## Notes

- This command does NOT change pane titles — those remain as set during boot-team.
- All agents can run this command. The tmux layout is a window-level setting, so any pane can change it.
- If the team is not booted (fewer than 3 panes), tell the user: "CoS team not running — /focus requires 3 panes."
