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

-- hyprland-run float placement
hl.window_rule({
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move  = "20 monitor_h-120",
  float = true,
})

-- tile steam
hl.window_rule({
  name  = "tile-steam",
  match = {
    class = "steam",
    title = "^(Steam|Friends List|.* - Steam)$",
  },
  tile  = true,
})

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

-- launch Discord on workspace 5
hl.window_rule {
  name = "discord-set-workspace",
  match = {class = "discord.*"},
  workspace = 5,
  no_initial_focus = true,
}

-- launch FFXIV and XIVLauncher on workspace 1
hl.window_rule {
  name = "ffxiv-set-workspace",
  match = {class = "ffxiv_dx11.exe"},
  workspace = 1,
  no_initial_focus = true
}

hl.window_rule {
  name = "xivlauncher-set-workspace",
  match = {class = "XIVLauncher.Core"},
  workspace = 1,
  no_initial_focus = true
}

hl.window_rule {
  name = "steam-games-set-workspace",
  match = {class = "steam.*"},
  workspace = 1,
  no_initial_focus = true,
}

-- layer rules
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
