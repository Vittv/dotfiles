#!/usr/bin/env bash
set -euo pipefail

# buildnvim - set-and-forget neovim build from source.
#
#   * installs missing build deps (read-only check, sudo only when needed)
#   * removes the pacman neovim so the source build owns /usr/local
#   * fetches latest master and rebuilds ONLY when something changed
#   * installs to /usr/local, which wins over /usr/bin in PATH
#
# usage: buildnvim.sh [--force]   # --force rebuilds even if up to date

BUILD_DIR="${HOME}/build"
SRC_DIR="${BUILD_DIR}/neovim"
DEPS=(base-devel cmake ninja curl git)
PREFIX=/usr/local

log() { printf '%s\n' "[buildnvim] %s" "$*"; }
die() { printf '%s\n' "[buildnvim] ERROR: %s" "$*" >&2; exit 1; }

# build dependencies
missing=()
for pkg in "${DEPS[@]}"; do
  if ! pacman -Q "$pkg" &>/dev/null; then
    missing+=("$pkg")
  fi
done
if (( ${#missing[@]} > 0 )); then
  log "Installing missing build deps: ${missing[*]}"
  sudo pacman -S --needed --noconfirm "${missing[@]}"
else
  log "All build dependencies present"
fi

# drop the pacman package so the source build takes over
if pacman -Q neovim &>/dev/null; then
  log "Removing pacman neovim (source build will take over)"
  sudo pacman -R --noconfirm --nodeps neovim
fi

# clone / update the repo
mkdir -p "${BUILD_DIR}"
if [[ ! -d "${SRC_DIR}/.git" ]]; then
  log "Cloning neovim into ${SRC_DIR}"
  git clone --quiet https://github.com/neovim/neovim.git "${SRC_DIR}"
  just_cloned=true
else
  just_cloned=false
fi

cd "${SRC_DIR}"

needs_build=false
if $just_cloned; then
  needs_build=true
elif [[ "${1:-}" == "--force" ]]; then
  log "Forcing rebuild"
  needs_build=true
else
  log "Fetching latest changes"
  git fetch --prune origin || die "git fetch failed (network?)"
  # hard reset discards any local edits; this is a disposable build checkout.
  git reset --hard --quiet HEAD || die "git reset failed"
  before=$(git rev-parse HEAD)
  git checkout -B master --quiet origin/master || die "git checkout failed"
  after=$(git rev-parse HEAD)

  if [[ "${before}" != "${after}" ]]; then
    log "Updated ${before:0:8} -> ${after:0:8}"
    needs_build=true
  elif [[ ! -x "${PREFIX}/bin/nvim" ]]; then
    log "No installed binary found, building anyway"
    needs_build=true
  else
    log "Already up to date, nothing to build"
  fi
fi

# build & install
if $needs_build; then
  log "Building (this can take a while)"
  make -j"$(nproc)" CMAKE_BUILD_TYPE=Release
  log "Installing to ${PREFIX}"
  sudo make install
  log "Done: $("${PREFIX}/bin/nvim" --version | head -1)"
else
  log "Skipping build"
fi

# uninstall notes -------------------------------------------------------
# sudo cmake --build "${SRC_DIR}/build" --target uninstall
# or manually:
# sudo rm /usr/local/bin/nvim && sudo rm -r /usr/local/share/nvim/
