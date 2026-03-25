#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/soul667/hsnips.git"
MODE=""

usage() {
  cat <<'EOF'
Usage:
  setup_hsnips.sh --mode <windows-source|wsl-link>

Modes:
  windows-source  Clone repo to Windows Documents, create WSL symlinks
  wsl-link        Create WSL symlinks to existing Windows repo

Examples:
  setup_hsnips.sh --mode windows-source
EOF
}

log() { printf '[hsnips-setup] %s\n' "$*"; }
die() { printf '[hsnips-setup] ERROR: %s\n' "$*" >&2; exit 1; }

WIN_REPO="/mnt/c/Users/$(cmd.exe /C 'echo %USERNAME%' 2>/dev/null | tr -d '\r')/Documents/hsnips-repo"

setup_windows_source() {
  # 1. Clone to Windows Documents
  if [ -d "$WIN_REPO/.git" ]; then
    log "Updating Windows repo: $WIN_REPO"
    git -C "$WIN_REPO" pull
  else
    log "Cloning to Windows: $WIN_REPO"
    rm -rf "$WIN_REPO"
    mkdir -p "$(dirname "$WIN_REPO")"
    git clone "$REPO_URL" "$WIN_REPO"
  fi
  
  # 2. Create WSL symlink
  WSL_TARGET="$HOME/.config/Code/User/globalStorage/draivin.hsnips/hsnips"
  mkdir -p "$(dirname "$WSL_TARGET")"
  rm -rf "$WSL_TARGET"
  ln -s "$WIN_REPO" "$WSL_TARGET"
  log "WSL symlink: $WSL_TARGET -> $WIN_REPO"
  
  # 3. Create Windows Junctions for editors
  create_windows_junctions
  
  log "Done! Source: $WIN_REPO"
}

create_windows_junctions() {
  log "Creating Windows junctions..."
  
  # Code path
  CODE_PATH="/mnt/c/Users/$(cmd.exe /C 'echo %USERNAME%' 2>/dev/null | tr -d '\r')/AppData/Roaming/Code/User/globalStorage/draivin.hsnips/hsnips"
  rm -rf "$CODE_PATH"
  mkdir -p "$(dirname "$CODE_PATH")"
  powershell.exe -Command "New-Item -ItemType Junction -Path 'C:\Users\$(\$env:USERNAME)\AppData\Roaming\Code\User\globalStorage\draivin.hsnips\hsnips' -Target 'C:\Users\$(\$env:USERNAME)\Documents\hsnips-repo'" 2>/dev/null || true
  
  # Antigravity path (if exists)
  AG_PATH="/mnt/c/Users/$(cmd.exe /C 'echo %USERNAME%' 2>/dev/null | tr -d '\r')/AppData/Roaming/Antigravity/User/globalStorage/draivin.hsnips/hsnips"
  if [ -d "$(dirname "$AG_PATH")" ]; then
    rm -rf "$AG_PATH"
    mkdir -p "$(dirname "$AG_PATH")"
    powershell.exe -Command "New-Item -ItemType Junction -Path 'C:\Users\$(\$env:USERNAME)\AppData\Roaming\Antigravity\User\globalStorage\draivin.hsnips\hsnips' -Target 'C:\Users\$(\$env:USERNAME)\Documents\hsnips-repo'" 2>/dev/null || true
  fi
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --mode) MODE="${2:-}"; shift 2 ;;
    --repo) REPO_URL="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown argument: $1" ;;
  esac
done

[ -n "$MODE" ] || die "--mode is required"

case "$MODE" in
  windows-source) setup_windows_source ;;
  *) die "Unsupported mode: $MODE" ;;
esac
