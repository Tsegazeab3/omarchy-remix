-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Rebind Super + Tab to cycle monitors and warp mouse
-- (Previously bound to 'Next workspace' and 'Previous workspace')
hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")
o.bind("SUPER + TAB", "Focus on next monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("SUPER + SHIFT + TAB", "Focus on previous monitor", hl.dsp.focus({ monitor = "-1" }))

-- Fuzzy window switcher (unbind default Quake console from grave)
hl.unbind("SUPER + grave")
hl.unbind("SUPER + GRAVE")
o.bind("SUPER + grave", "Window switcher", "omarchy-window-switcher")

-- Quake console (default agent / agy) moved to Super + comma (replaces notification action)
o.rebind("SUPER + comma", "Toggle Quake console", hl.dsp.workspace.toggle_special("qconsole"))

-- Unbind defaults on J, K, and L
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")

-- Vim-style pane navigation (Super + H/J/K/L)
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- Swap windows with Super + Shift + H/J/K/L
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- Move displaced actions to physical Windows key (which sends ALT)
o.bind("ALT + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("ALT + K", "Keybindings", "omarchy-menu-keybindings")
o.bind("ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("ALT + T", "Toggle Materialgram", "toggle-telegram")
o.bind("ALT + SHIFT + T", "Toggle Samsung Tab", "tab-toggle")
o.bind("ALT + D", "Toggle Screen Drawing", "wayscriber --daemon-toggle")
o.bind("SUPER + D", "Toggle Screen Drawing", "wayscriber --daemon-toggle")

-- Wayland Keyboard Pointer (P for Pointer, O for Drag)
o.bind("ALT + P", "Keyboard mouse pointer", "hypr-kbptr")
o.bind("ALT + O", "Keyboard mouse drag", "hypr-kbptr -d")

-- Unbind default Super + Space (which was triggered by Alt + Space)
hl.unbind("SUPER + SPACE")
-- Toggle keyboard layout (English / Amharic) with Space + Alt/Win
o.bind("SUPER + SPACE", "Switch keyboard layout", "hyprctl switchxkblayout current next")
o.bind("ALT + SPACE", "Switch keyboard layout", "hyprctl switchxkblayout current next")

-- Tap physical Windows key alone to toggle Omarchy menu
o.bind("ALT + Alt_L", "Omarchy menu", "omarchy-menu toggle", { release = true })
o.bind("ALT + Alt_R", "Omarchy menu", "omarchy-menu toggle", { release = true })

-- Local AI Scratchpad (SUPER + A)
o.bind("SUPER + A", "AI Scratchpad", "omarchy-launch-or-focus-tui --app-id=org.omarchy.ai-scratchpad ai-scratchpad")
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "AI File Editor", "omarchy-launch-or-focus-tui --app-id=org.omarchy.agy-scratchpad $HOME/.local/bin/super-fast-order")


-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Quick Order Scratchpad
o.bind("SUPER + Q", "Quick Order", "omarchy-launch-or-focus-tui --app-id=org.omarchy.agy-quick-order agy-quick-order")

-- Unbind Google Maps from SUPER + SHIFT + S
hl.unbind("SUPER + SHIFT + S")

-- Bind SUPER + SHIFT + S to move the current window to the scratchpad
o.bind("SUPER + SHIFT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- flea --default: begin. Written by `flea --default`; `flea --default off` removes the block whole.
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", { launch = 'flea --gui' })
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { launch = 'flea --gui "$(omarchy-cmd-terminal-cwd)"' })
-- flea --default: end.

-- flea --picker: begin. Written by `flea --picker`; `flea --picker off` removes the block whole.
o.window("com.thisisgm.flea.picker", { tag = "+floating-window" })
-- flea --picker: end.

-- Dictation keys from before Alt + Space and Right Alt became the defaults.
-- Remove these lines to give the keys back to applications.
if o.dictation_installed and o.dictation_installed() then
  o.bind("SUPER + CTRL + X", "Toggle dictation", "omarchy-dictation toggle")
  o.bind_hold("F9", "Start dictation (push-to-talk)", "omarchy-dictation start", "Stop dictation (push-to-talk)", "omarchy-dictation stop")
end

-- Lid close: run through lid-close-handler so `lid-close-toggle` can make it do nothing.
-- (Replaces the default omarchy-system-lid-close binding.)
o.rebind("switch:on:Lid Switch", nil, "lid-close-handler", { locked = true })
o.rebind("switch:on:Apple SMC power/lid events", nil, "lid-close-handler", { locked = true })
