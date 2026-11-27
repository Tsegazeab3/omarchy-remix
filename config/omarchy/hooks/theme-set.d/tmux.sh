#!/bin/bash
# ==============================================================================
# Omarchy Hook: theme-set
# Reloads tmux configuration when Omarchy theme changes
# ==============================================================================

if tmux has-session 2>/dev/null; then
  tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null || true
fi
