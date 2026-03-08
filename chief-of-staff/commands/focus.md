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

### 2. Run the focus script

The layout is applied atomically by a shell script using tmux custom layout strings with checksums. Run it:

```bash
bash /Users/jeremy.brown/dev/cc-marketplace/chief-of-staff/scripts/cos-focus.sh <target>
```

The script auto-detects the CoS team window by scanning for panes with `"ops"` in their `pane-border-format`, discovers all three panes, computes proportional dimensions from the current window size, and applies the layout atomically via `select-layout`.

### 3. Report the result

The script outputs a one-line confirmation. Relay it to the user. If the script exits with an error (e.g., team not booted, panes not found), relay the error message.

## Notes

- This command does NOT change pane titles — those remain as set during boot-team.
- All agents can run this command. The tmux layout is a window-level setting, so any pane can change it.
- If the team is not booted (fewer than 3 panes), tell the user: "CoS team not running — /focus requires 3 panes."
