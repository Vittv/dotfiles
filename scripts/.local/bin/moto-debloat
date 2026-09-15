#!/usr/bin/env bash
# moto-debloat.sh - re-apply Moto E20 debloat via ADB (idempotent)
#
# re-removes the 21 bloat packages previously uninstalled from the Moto E20
# (carrier + Facebook + Google extras). safe to re-run: already-absent
# packages are skipped and only reported.
#
# deliberately NOT handled here:
#   - cache clearing (so the user can keep their logins saved)
#   - com.sprd.omacp / com.google.android.partnersetup (kept installed)
#
# targets the Moto E20 by model so it can never touch other devices.
set -euo pipefail

readonly MOTO_MODEL="moto_e20"

readonly BLOAT_PKGS=(
  # Facebook (3)
  com.facebook.system
  com.facebook.appmanager
  com.facebook.services
  # Motorola carrier/demo bloat (8)
  com.motorola.brapps
  com.motorola.paks
  com.motorola.motocare
  com.motorola.motocit
  com.motorola.help
  com.motorola.demo
  com.motorola.genie
  com.motorola.timeweatherwidget
  # Google extras (10)
  com.google.android.apps.docs
  com.google.android.apps.tachyon
  com.google.android.apps.searchlite
  com.google.android.videos
  com.google.android.apps.youtube.music
  com.google.android.apps.wellbeing
  com.google.android.apps.maps
  com.google.android.youtube
  com.google.android.play.games
  com.google.android.apps.assistant
)

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"

usage() {
  cat <<'EOF'
Usage: moto-debloat.sh [-s SERIAL] [-n] [-c] [-h]

Re-removes the 21 bloat packages from the Moto E20 over ADB.

Options:
  -s SERIAL  Target a specific ADB serial instead of auto-detect
  -n         Dry run: show what would be removed, change nothing
  -c         Check only: report current status, change nothing
  -h         Show this help

Exit status: 0 when no bloat remains, 1 otherwise.
EOF
}

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

# find_serial [requested] - print matching device serials, one per line
find_serial() {
  local requested="${1:-}"
  adb devices -l 2>/dev/null | awk -v req="$requested" -v model="$MOTO_MODEL" '
    $2 == "device" {
      if (req != "" && $1 == req) { print $1 }
      else if (req == "" && index($0, "model:" model) > 0) { print $1 }
    }'
}

# device_packages - current package list for the target, stripped of CRs
device_packages() {
  adb -s "$SERIAL" shell pm list packages | tr -d '\r'
}

# remove_pkg <pkg> - uninstall one package, idempotent
remove_pkg() {
  local pkg="$1"

  if ! grep -qxF "package:$pkg" <<<"$PKGS"; then
    printf "${GREEN}skip${NC}   %s (already removed)\n" "$pkg"
    ((skipped += 1))
    return
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf "${YELLOW}would${NC}  %s\n" "$pkg"
    ((would_remove += 1))
    return
  fi

  local out
  out="$(adb -s "$SERIAL" shell pm uninstall --user 0 "$pkg" 2>&1 || true)"
  case "$out" in
    Success)
      printf "${GREEN}remove${NC} %s\n" "$pkg"
      ((removed += 1))
      ;;
    *"not installed"*)
      printf "${GREEN}skip${NC}   %s (already removed)\n" "$pkg"
      ((skipped += 1))
      ;;
    *)
      printf "${RED}fail${NC}   %s: %s\n" "$pkg" "$out"
      ((failed += 1))
      ;;
  esac
}

main() {
  local SERIAL=""
  local DRY_RUN=0
  local CHECK_ONLY=0
  local removed=0 skipped=0 failed=0 would_remove=0 still_installed=0

  while getopts "s:nch" opt; do
    case "$opt" in
      s) SERIAL="$OPTARG" ;;
      n) DRY_RUN=1 ;;
      c) CHECK_ONLY=1 ;;
      h) usage; exit 0 ;;
      *) usage >&2; exit 1 ;;
    esac
  done

  command -v adb >/dev/null 2>&1 || die "adb not found. Install android-tools and re-run."

  local candidates
  candidates="$(find_serial "$SERIAL")"
  if [[ -z "$candidates" ]]; then
    die "Moto E20 not connected. Plug it in (USB debugging on) and re-run."
  fi
  SERIAL="$(printf '%s\n' "$candidates" | head -n1)"
  local count
  count="$(printf '%s\n' "$candidates" | sed '/^$/d' | wc -l)"
  [[ "$count" -gt 1 ]] && die "Multiple Moto E20 devices connected; pick one with -s."

  printf 'Device: %s\n' "$SERIAL"

  if [[ "$CHECK_ONLY" -eq 1 ]]; then
    PKGS="$(device_packages)"
    for pkg in "${BLOAT_PKGS[@]}"; do
      if grep -qxF "package:$pkg" <<<"$PKGS"; then
        printf "${RED}installed${NC} %s\n" "$pkg"
        ((still_installed += 1))
      else
        printf "${GREEN}absent${NC}   %s\n" "$pkg"
      fi
    done
    [[ "$still_installed" -eq 0 ]] && printf 'All %d bloat packages absent.\n' "${#BLOAT_PKGS[@]}"
    return "$([[ "$still_installed" -eq 0 ]] && echo 0 || echo 1)"
  fi

  PKGS="$(device_packages)"
  for pkg in "${BLOAT_PKGS[@]}"; do
    remove_pkg "$pkg"
  done

  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf 'Dry run: %d would be removed, %d already absent, %d failed.\n' \
      "$would_remove" "$skipped" "$failed"
    return 0
  fi

  PKGS="$(device_packages)"
  for pkg in "${BLOAT_PKGS[@]}"; do
    grep -qxF "package:$pkg" <<<"$PKGS" && ((still_installed += 1))
  done

  printf 'Removed: %d  Already absent: %d  Failed: %d  Still installed: %d\n' \
    "$removed" "$skipped" "$failed" "$still_installed"

  [[ "$still_installed" -eq 0 && "$failed" -eq 0 ]] || return 1
}

main "$@"
