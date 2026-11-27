-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")
require("hypr.mindgate")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- Materialgram floating window rules
o.window("(org.telegram.desktop|io.github.kukuruzka165.materialgram|materialgram)", {
  float = true,
  size = "1050 750",
  center = true,
  focus_on_activate = true,
})

-- Local AI Scratchpad floating window rules
o.window("org.omarchy.ai-scratchpad", {
  float = true,
  size = "960 650",
  center = true,
  focus_on_activate = true,
})



o.window("org.omarchy.agy-scratchpad", {
  float = true,
  size = "960 650",
  center = true,
  focus_on_activate = true,
})

o.window("org.omarchy.aider-scratchpad", {
  float = true,
  size = "960 650",
  center = true,
  focus_on_activate = true,
})

o.window("org.omarchy.agy-quick-order", {
  float = true,
  size = "800 250",
  center = true,
  focus_on_activate = true,
})

-- Samsung Tab Keyboard capture window
o.window({ title = "^Samsung-Tab-Keyboard$" }, {
  float = true,
  size = "260 120",
  center = true,
  focus_on_activate = true,
})
