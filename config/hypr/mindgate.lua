-- MindGate: morning journal gate.
--
-- The keyboard lock is tied to the gate WINDOW, not to the app remembering to unlock:
-- while a window with class "mindgate" exists, the empty "mindgate" submap is active and
-- none of your keybinds work. The moment that window is gone (unlocked, crashed, killed),
-- the submap is reset. A 2-second check backs this up, so keys can never stay locked.
--
-- The gate runs under a decoy process name and comes back if killed. If it ever truly hangs,
-- the supervisor's lockout safety (see supervisor.py) lets you in; that day counts as bypassed.

o.window("^mindgate$", {
  fullscreen = true,
  stay_focused = true,
  no_anim = true,
})

-- A submap with only a do-nothing bind = none of your keybinds work while it's active.
-- (A submap with zero binds isn't registered at all, hence the placeholder.)
hl.define_submap("mindgate", function()
  hl.bind("SUPER + CTRL + ALT + F12", hl.dsp.no_op(), { description = "MindGate lock placeholder" })
end)

local function gate_window_exists()
  for _, w in ipairs(hl.get_windows()) do
    if w.class == "mindgate" and w.mapped then
      return true
    end
  end
  return false
end

local function sync_lock()
  local locked = hl.get_current_submap() == "mindgate"
  local gate = gate_window_exists()
  if gate and not locked then
    hl.dispatch(hl.dsp.submap("mindgate"))
  elseif locked and not gate then
    hl.dispatch(hl.dsp.submap("reset"))
  end
end

hl.on("window.open", sync_lock)
hl.on("window.close", sync_lock)
hl.on("window.destroy", sync_lock)

-- Safety net. Disable a timer left over from a previous config load before adding one.
if mindgate_lock_timer then
  pcall(function() mindgate_lock_timer:set_enabled(false) end)
end
mindgate_lock_timer = hl.timer(sync_lock, { timeout = 2000, type = "repeat" })
