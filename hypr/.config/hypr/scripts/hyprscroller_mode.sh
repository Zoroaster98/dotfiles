#!/usr/bin/env bash

# File to track the current state
STATE_FILE="$XDG_RUNTIME_DIR/hyprscroller_mode"

if [ -f "$STATE_FILE" ]; then
	# If file exists, we are currently in COL mode -> Switch to ROW
	hyprctl dispatch scroller:setmode row
	rm "$STATE_FILE"
	# Optional: Visual feedback (requires libnotify)
	# notify-send -t 1000 -r 99 "Scroller" "Mode: Row"
else
	# If file doesn't exist, we are in ROW mode -> Switch to COL
	hyprctl dispatch scroller:setmode col
	touch "$STATE_FILE"
	# Optional: Visual feedback
	# notify-send -t 1000 -r 99 "Scroller" "Mode: Column"
fi
