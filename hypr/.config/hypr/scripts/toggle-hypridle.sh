#!/usr/bin/env bash

# Check if hypridle is running
if pgrep -x "hypridle" >/dev/null; then
	pkill -x hypridle
	notify-send -a "Hypridle" "💤 Hypridle disabled"
else
	hypridle &
	notify-send -a "Hypridle" "⚡ Hypridle enabled"
fi
