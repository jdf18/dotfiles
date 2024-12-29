#!/bin/bash

primary_monitor="eDP-1"
secondary_monitor="HDMI-A-1"

options="Mirror\nExtend Left\nExtend Right\nPrimary Only\nSecondary Only"

chosen=$(echo -e "$options" | wofi --dmenu --prompt "Display Configuration")

case "$chosen" in 
	"Mirror")
		hyprctl keyword monitor "$primary_monitor, preferred, 0x0, 1"
		hyprctl keyword monitor "$secondary_monitor, preferred, auto, 1, mirror, $primary_monitor"
		;;
	"Extend Left")
		hyprctl keyword monitor "$primary_monitor, preferred, 0x0, 1"
		hyprctl keyword monitor "$secondary_monitor, preferred, auto-left, 1"
		;;
	"Extend Right")
		hyprctl keyword monitor "$primary_monitor, preferred, 0x0, 1"
		hyprctl keyword monitor "$secondary_monitor, preferred, auto-right, 1"
		;;
	"Primary Only")
		hyprctl keyword monitor "$primary_monitor, preferred, 0x0, 1"
		hyprctl keyword monitor "$secondary_monitor, disable"
		;;
	"Secondary Only")
		hyprctl keyword monitor "$primary_monitor, disable"
		hyprctl keyword monitor "$secondary_monitor, preferred, auto, 1"
		;;
	"Reset")
		hyprctl reload
		;;
	*)
		echo "Invalid operation" >&2
esac

bash ~/.config/hypr/scripts/restart_waybar.sh
