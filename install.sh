#!/usr/bin/env bash
# Layer omarchy-remix on top of a stock Omarchy install.
# Every file it replaces is backed up next to the original as *.bak.<timestamp>.
#   ./install.sh            copy configs + scripts, enable user services
#   ./install.sh --packages also install the extra packages
#   ./install.sh --dry-run  show what would change
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

DRY=0; PKGS=0
for a in "$@"; do
  case "$a" in
    --dry-run) DRY=1 ;;
    --packages) PKGS=1 ;;
    *) echo "Unknown option: $a" >&2; exit 1 ;;
  esac
done

STAMP=$(date +%s)
run() { if (( DRY )); then echo "  would: $*"; else "$@"; fi; }

place() { # src dest
  local src=$1 dest=$2
  if [[ -e $dest ]] && cmp -s "$src" "$dest"; then return; fi
  echo "-> $dest"
  run mkdir -p "$(dirname "$dest")"
  [[ -e $dest ]] && run cp -a "$dest" "$dest.bak.$STAMP"
  run cp "$src" "$dest"
}

command -v omarchy >/dev/null || { echo "This is meant for Omarchy (omarchy.org)." >&2; exit 1; }

echo "== configs -> ~/.config"
while IFS= read -r -d '' f; do
  place "$f" "$HOME/.config/${f#config/}"
done < <(find config -type f -print0)

echo "== scripts -> ~/.local/bin"
for f in bin/*; do
  place "$f" "$HOME/.local/bin/$(basename "$f")"
  run chmod +x "$HOME/.local/bin/$(basename "$f")"
done

if (( PKGS )); then
  echo "== packages"
  run omarchy pkg add $(grep -v '^#' packages.txt)
  run omarchy pkg aur add $(grep -v '^#' packages-aur.txt)
fi

echo "== user services"
run systemctl --user daemon-reload
for s in download-watch wayscriber; do run systemctl --user enable --now "$s.service" || true; done
echo "   (mount-storage and rclone-gdrive are installed but not enabled: edit them for your disks/remotes first)"

if (( ! DRY )); then
  hyprctl reload >/dev/null 2>&1 && hyprctl configerrors || true
  omarchy restart shell >/dev/null 2>&1 || true
fi
echo "Done."
