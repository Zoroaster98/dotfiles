#!/usr/bin/env bash

# File to track state
LOCK_FILE="/tmp/hypr_transparency_active"
TRANSPARENT_VAL="0.85"

if [ -f "$LOCK_FILE" ]; then
	# -- TOGGLE OFF (Go back to Opaque) --
	hyprctl keyword decoration:active_opacity 1.0
	hyprctl keyword decoration:inactive_opacity 1.0

	# Remove the lock file so next time we know we are opaque
	rm "$LOCK_FILE"
else
	# -- TOGGLE ON (Go Transparent) --
	hyprctl keyword decoration:active_opacity $TRANSPARENT_VAL
	hyprctl keyword decoration:inactive_opacity $TRANSPARENT_VAL

	# Create lock file so next time we know we are transparent
	touch "$LOCK_FILE"
fi
