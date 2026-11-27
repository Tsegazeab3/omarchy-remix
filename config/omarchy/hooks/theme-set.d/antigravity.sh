#!/bin/bash
# ==============================================================================
# Omarchy Hook: theme-set
# Sync Omarchy theme mode (dark/light) to Antigravity CLI and UI settings
# ==============================================================================

CURRENT_THEME_PATH="$HOME/.local/state/omarchy/current/theme"
COLORS_TOML="$CURRENT_THEME_PATH/colors.toml"

MODE="dark"
if [[ -f $COLORS_TOML ]]; then
  MODE=$(omarchy-theme-color --file "$COLORS_TOML" mode 2>/dev/null || echo "dark")
fi

[[ $MODE != "light" ]] && MODE="dark"

UI_THEME="Default Dark"
[[ $MODE == "light" ]] && UI_THEME="Default Light"

# 1. Update Antigravity CLI colorScheme (~/.gemini/antigravity-cli/settings.json)
AGY_CLI_SETTINGS="$HOME/.gemini/antigravity-cli/settings.json"
if [[ -f $AGY_CLI_SETTINGS ]]; then
  tmp=$(mktemp)
  if jq --arg mode "$MODE" '.colorScheme = $mode' "$AGY_CLI_SETTINGS" >"$tmp" 2>/dev/null; then
    mv "$tmp" "$AGY_CLI_SETTINGS"
  else
    rm -f "$tmp"
  fi
fi

# 2. Update Antigravity Desktop UI theme (~/.gemini/settings.json)
AGY_SETTINGS="$HOME/.gemini/settings.json"
if [[ -f $AGY_SETTINGS ]]; then
  tmp=$(mktemp)
  if jq --arg theme "$UI_THEME" '.ui.theme = $theme' "$AGY_SETTINGS" >"$tmp" 2>/dev/null; then
    mv "$tmp" "$AGY_SETTINGS"
  else
    rm -f "$tmp"
  fi
fi
