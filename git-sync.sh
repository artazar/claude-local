CLAUDE_DIR="$HOME/.claude"

_claude_sync_pull() {
  [ -z "$CLAUDE_SYNCED" ] || return
  export CLAUDE_SYNCED=1

  if [ -d "$CLAUDE_DIR/.git" ]; then
    (
      cd "$CLAUDE_DIR" || return
      git fetch origin main --quiet 2>/dev/null
      git merge --ff-only origin/main --quiet 2>/dev/null \
        || echo "[claude-sync] Pull conflict — resolve manually in $CLAUDE_DIR"
    ) &
  fi
}

_claude_sync_push() {
  if [ -d "$CLAUDE_DIR/.git" ]; then
    (
      cd "$CLAUDE_DIR" || return
      if ! git diff --quiet || ! git diff --cached --quiet \
          || [ -n "$(git status --porcelain)" ]; then
        git add -A
        git commit --quiet -m "Auto-sync $(hostname) $(date '+%Y-%m-%d %H:%M:%S')"
        git push origin main --quiet 2>/dev/null \
          || echo "[claude-sync] Push failed — check git remote"
      fi
    )
  fi
}

_claude_sync_pull
trap '_claude_sync_push' EXIT
