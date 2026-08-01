-- ╔══════════════════════════════════╗
-- ║              ℝ𝕦𝕝𝕖𝕤               ║
-- ╚══════════════════════════════════╝

-- window rules
-- ignore maximize requests from all apps
hl.window_rule({
  name           = "suppress-maximize-events",
  match          = { class = ".*" },
  suppress_event = "maximize",
})

-- fix some dragging issues with XWayland
hl.window_rule({
  name       = "fix-xwayland-drags",
  match      = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },
  no_focus   = true,
})

-- disable gaps and borders when there is only one tiled window
-- hl.workspace_rule({
--   workspace = "w[tv1]",
--   gaps_out = 0,
--   gaps_in = 0,
--   border_size = 1
-- })

-- ensure floating windows retain a border for clear visibility
hl.window_rule({
  match = { float = 1 },
  -- border_size = 2
})

-- hyprland-run float placement
hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move  = "20 monitor_h-120",
  float = true,
})

-- tile steam
-- hl.window_rule({
--   name  = "tile-steam",
--   match = {
--     class = "steam",
--     title = "^(Steam|Friends List|.* - Steam)$",
--   },
--   tile  = true,
-- })

-- tile minecraft
hl.window_rule({
  name  = "tile-minecraft",
  match = { class = "Minecraft.*" },
  tile  = true,
})

-- fix fallout 76
hl.window_rule({
  name  = "fix-fallout76",
  match = { class = "steam_app_1151340" },
  float = true,
  size  = { 1920, 1080 },
  move  = { 0, 0 },
})

hl.window_rule({
  match = { class = "steam", title = "Steam" },
  workspace = "4",
  no_initial_focus = true,
})

hl.window_rule({
  match = { class = "steam", title = "Friends List" },
  workspace = "4",
  no_initial_focus = true,
})

-- layer rules
-- only rofi gets the spring popin; everything else stays on the global fade
hl.layer_rule({
  name         = "waybar_default",
  match        = { namespace = "waybar" },
  blur         = true,
  ignore_alpha = 0.2,
})

hl.layer_rule({
  name         = "rofi_default",
  match        = { namespace = "rofi" },
  blur         = true,
  ignore_alpha = 0.2,
  animation    = "popin 85%",
})

hl.layer_rule({
  name         = "swaync_control-center",
  match        = { namespace = "swaync-control-center" },
  blur         = true,
  ignore_alpha = 0.4,
})

hl.layer_rule({
  name         = "swaync_notification",
  match        = { namespace = "swaync-notification-window" },
  blur         = true,
  ignore_alpha = 0.4,
})
