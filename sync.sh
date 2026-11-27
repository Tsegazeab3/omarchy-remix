#!/usr/bin/env bash
# Pull live changes from ~/.config and ~/.local/bin into this repo, then commit and push.
# Only files already in the repo are synced. Run by the omarchy-remix-sync user timer.
#   ./sync.sh            sync, commit, push
#   ./sync.sh --dry-run  show what would change
set -uo pipefail
REPO="$(dirname "$(readlink -f "$0")")"
cd "$REPO" || exit 1
DRY=0; [[ ${1:-} == --dry-run ]] && DRY=1

note() { notify-send -a "omarchy-remix" "$@" 2>/dev/null || echo "$*"; }

# Remove personal/secret bits from a copied file, in place.
sanitize() { # file name-in-repo
  sed -i -E \
    -e "s|/home/$USER/|\$HOME/|g" \
    -e 's|os\.environ\.get\("OPENROUTER_API_KEY", "[^"]*"\)|os.environ.get("OPENROUTER_API_KEY") or sys.exit("Set OPENROUTER_API_KEY first.")|' \
    -e 's|(desc:[^"]*) [A-Z0-9]{8,}"|\1"|' \
    "$1"
  # systemd units need %h, not $HOME
  [[ $2 == *.service ]] && sed -i 's|\$HOME/|%h/|g' "$1"
  # Python can't expand $HOME in strings
  head -1 "$1" | grep -q python && sed -i -E 's|"\$HOME/([^"]*)"|os.path.expanduser("~/\1")|g' "$1"
  return 0
}

tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
while IFS= read -r f; do
  case "$f" in
    config/*) live="$HOME/.config/${f#config/}" ;;
    bin/*)    live="$HOME/.local/bin/${f#bin/}" ;;
    *) continue ;;
  esac
  [[ -f $live ]] || continue
  cp "$live" "$tmp/x"; sanitize "$tmp/x" "$f"
  if ! cmp -s "$tmp/x" "$f"; then
    echo "changed: $f"
    (( DRY )) || cp "$tmp/x" "$f"
  fi
done < <(git ls-files config bin)

(( DRY )) && exit 0
[[ -z $(git status --porcelain) ]] && exit 0

# Never publish something that looks like a credential.
if git diff | grep -qE '^\+.*(sk-or-v1-[0-9a-f]{20}|sk-ant-|gh[pousr]_[A-Za-z0-9]{20}|AIza[0-9A-Za-z_-]{30}|-----BEGIN [A-Z ]*PRIVATE KEY)'; then
  git checkout -- . 
  note "omarchy-remix sync stopped" "A change looked like a secret, so nothing was committed."
  exit 1
fi

files=$(git status --porcelain | awk '{print $2}' | xargs -n1 basename | sort -u | head -5 | paste -sd, -)
git add -A
git commit -q -m "Sync: $files" && git push -q 2>/dev/null || note "omarchy-remix" "Committed locally, push failed (offline?)"
