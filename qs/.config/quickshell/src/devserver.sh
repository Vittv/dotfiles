#!/usr/bin/env bash
servers=''

if ss -tlnp 2>/dev/null | grep -q ':5173 '; then servers='vite:5173'; fi
if ss -tlnp 2>/dev/null | grep -q ':4173 '; then [[ -n "$servers" ]] && servers="$servers, " || servers=''; servers="${servers}vite:4173"; fi
if ss -tlnp 2>/dev/null | grep -q ':8080 '; then [[ -n "$servers" ]] && servers="$servers, " || servers=''; servers="${servers}webpack:8080"; fi
if ss -tlnp 2>/dev/null | grep -q ':3000 '; then [[ -n "$servers" ]] && servers="$servers, " || servers=''; servers="${servers}dev:3000"; fi
if ss -tlnp 2>/dev/null | grep -q ':8081 '; then [[ -n "$servers" ]] && servers="$servers, " || servers=''; servers="${servers}dev:8081"; fi

if [[ -n "$servers" ]]; then
  echo "{\"text\": \"$servers\", \"class\": \"server-active\", \"tooltip\": \"Running dev servers: $servers\"}"
else
  echo "{\"text\": \"\", \"class\": \"\", \"tooltip\": \"\"}"
fi
