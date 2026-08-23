#!/usr/bin/env bash

cache="${XDG_RUNTIME_DIR:-/tmp}/herdr-waybar.status"
yellow='#f3be7c'
blue='#7e98e8'
red='#d8647e'
green='#7fa563'

now=$(date +%s)
mtime=$(stat -c %Y "$cache" 2>/dev/null) || mtime=0
if (( now - mtime >= 3 )); then
	if output=$(herdr workspace list 2>/dev/null); then
		jq -r '[.result.workspaces[0].agent_status // "idle",
		        ([.result.workspaces[] | "\(.number):\(.label)"] | join(", "))][]
		       ' <<<"$output" >"$cache.new" 2>/dev/null \
			&& mv "$cache.new" "$cache"
	else
		rm -f "$cache"
	fi
fi

{
	read -r status
	read -r workspaces
} <"$cache" 2>/dev/null || exit 0
[[ -n $workspaces ]] || exit 0

case "$status" in
	working)
		(( now % 2 )) && color=$yellow || color=$blue
		;;
	blocked) color=$red ;;
	*)       color=$green ;;
esac

text="<span color='$color'>▪</span> herdr: $workspaces"
printf '{"text":"%s","tooltip":"Agent: %s\\nWorkspaces: %s","class":"herdr-%s","markup":"pango"}\n' \
	"$text" "$status" "$workspaces" "$status"
