#!/usr/bin/env bash
LEVEL="$1"
TITLE="$2"
MSG="$3"
# Fallback to echo if notify-send is missing or if system is SILENCED
if [[ -f "$HOME/.foundry_silent" ]]; then
    echo "[SILENT-LOG] [$LEVEL] $TITLE: $MSG"
elif command -v notify-send >/dev/null 2>&1; then
    notify-send -u "$LEVEL" "$TITLE" "$MSG"
else
    echo "[$LEVEL] $TITLE: $MSG"
fi
