#!/usr/bin/env bash

# File: ~/.config/hypr/scripts/scratchpad_manager.sh

# 1. Get details of the currently active window in JSON format
active_window=$(hyprctl activewindow -j)

# Extract the window's unique address and current workspace ID/Name
# We use the address as a unique key for the temporary file
win_address=$(echo "$active_window" | jq -r '.address')
ws_id=$(echo "$active_window" | jq -r '.workspace.id')
ws_name=$(echo "$active_window" | jq -r '.workspace.name')

# Define a temporary file path unique to this window
mem_file="/tmp/hypr_scratch_${win_address}"

# 2. Logic Controller
# Check if the current workspace name starts with "special:"
if [[ "$ws_name" == special:* ]]; then
	# --- RESTORE LOGIC ---

	if [ -f "$mem_file" ]; then
		# Read the stored workspace ID
		target_ws=$(cat "$mem_file")

		# Move the window back to the stored workspace
		# We use 'movetoworkspace' (not silent) to follow the window back
		hyprctl dispatch movetoworkspace "$target_ws"

		# Clean up the memory file
		rm "$mem_file"
	else
		# Fallback: If no memory file exists, move to current active workspace
		# or a default workspace (e.g., 1)
		hyprctl dispatch movetoworkspace "m+0"
	fi

else
	# --- MINIMIZE LOGIC ---

	# Save the current Workspace ID to the memory file
	echo "$ws_id" >"$mem_file"

	# Move the window silently to the special workspace
	# You can name the special workspace whatever you want (here: 'minimized')
	hyprctl dispatch movetoworkspacesilent "special:minimized"
fi
