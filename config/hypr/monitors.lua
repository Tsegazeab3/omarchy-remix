-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1.25

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.env("AQ_NO_MODIFIERS", "1")

-- Internal laptop display
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = omarchy_monitor_scale })

-- External Samsung monitor (matched by description and all DP ports)
hl.monitor({ output = "desc:Samsung Electric Company S24F350", mode = "1920x1080@60", position = "auto-right", scale = 1 })
hl.monitor({ output = "DP-1", mode = "1920x1080@60", position = "auto-right", scale = 1 })
hl.monitor({ output = "DP-2", mode = "1920x1080@60", position = "auto-right", scale = 1 })
hl.monitor({ output = "DP-3", mode = "1920x1080@60", position = "auto-right", scale = 1 })
hl.monitor({ output = "DP-4", mode = "1920x1080@60", position = "auto-right", scale = 1 })

-- External Dell U2718Q: 1440p@60 flickers over the current HDMI adapter (bandwidth limit); keep 1080p@60
hl.monitor({ output = "desc:Dell Inc. DELL U2718Q", mode = "1920x1080@60", position = "auto-right", scale = 1 })

-- Fallback for any other monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

