#!/bin/bash

# Workspace to move windows to
TARGET_WORKSPACE=$1

FOCUSED_WINDOW=$(hyprctl activewindow -j | jq -r '. | .address')
ACTIVE_WORKSPACE_ID=$(hyprctl activewindow -j | jq -r '.workspace.id')
#echo "FW $FOCUSED_WINDOW"
#echo "AW $ACTIVE_WORKSPACE_ID"

UNFOCUSED_WINDOWS=$(hyprctl clients -j | jq -r ".[] | select((.address != \"$FOCUSED_WINDOW\") and (.workspace.id == $ACTIVE_WORKSPACE_ID)).address")
echo "$UNFOCUSED_WINDOWS"
if [ $(echo "$UNFOCUSED_WINDOWS" | wc -w) -eq 0 ]
then
    echo "single window"
    MINIMISED_WINDOWS=$(hyprctl clients -j | jq -r ".[] | select(.tags | any(index(\"background$ACTIVE_WORKSPACE_ID\"))).address")
    for WINDOW in $MINIMISED_WINDOWS; do
        echo "M$WINDOW"
        hyprctl dispatch movetoworkspacesilent "$ACTIVE_WORKSPACE_ID,address:$WINDOW"
        hyprctl dispatch tagwindow -- -background$ACTIVE_WORKSPACE_ID address:$WINDOW
    done
else
    echo "send windows away"
    for WINDOW in $UNFOCUSED_WINDOWS; do
        echo "W$WINDOW"
        echo "$(hyprctl clients -j | jq -r ".[] | select(.address == \"$WINDOW\").class")"
        hyprctl dispatch movetoworkspacesilent "$TARGET_WORKSPACE,address:$WINDOW"
        hyprctl dispatch tagwindow +background$ACTIVE_WORKSPACE_ID address:$WINDOW
    done
fi
