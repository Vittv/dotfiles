-- ╔══════════════════════════════════╗
-- ║            𝔸𝕡𝕡𝕖𝕒𝕣𝕒𝕟𝕔𝕖            ║
-- ╚══════════════════════════════════╝

local Colors = require("schemes.vague.colors")

-- general
hl.config({
  general = {
    gaps_in          = 3,
    gaps_out         = 6,
    border_size      = 2,
    resize_on_border = false,
    allow_tearing    = false,
    layout           = "dwindle",
    col = {
      active_border   = Colors.text,
      inactive_border = "rgba(999999aa)",
    },
  },
})

-- decoration
hl.config({
  decoration = {
    rounding         = 4,
    rounding_power   = 2,

    active_opacity   = 1.0,
    inactive_opacity = 1.0,

    shadow = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = "rgba(1a1a1aee)",
    },

    blur = {
      enabled           = true,
      size              = 4,
      passes            = 2,
      new_optimizations = true,
      vibrancy          = 0.1696,
      popups            = true,
    },
  },
})

-- curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })
hl.curve("workspaceCurve", { type = "bezier", points = { {0.45, 0},    {0.1, 1}  } })
hl.curve("spring",         { type = "bezier", points = { {0.34, 1.56},  {0.64, 1}  } })

-- animations
hl.animation({
  leaf    = "global",
  enabled = true,
  speed   = 10,
  bezier  = "default",
})
hl.animation({
  leaf    = "border",
  enabled = true,
  speed   = 5.39,
  bezier  = "easeOutQuint",
})
hl.animation({
  leaf    = "windows",
  enabled = true,
  speed   = 4.79,
  bezier  = "easeOutQuint",
})
hl.animation({
  leaf    = "windowsIn",
  enabled = true,
  speed   = 4.1,
  bezier  = "easeOutQuint",
  style   = "popin 87%",
})
hl.animation({
  leaf    = "windowsOut",
  enabled = true,
  speed   = 1.49,
  bezier  = "linear",
  style   = "popin 87%",
})
hl.animation({
  leaf    = "fadeIn",
  enabled = true,
  speed   = 1.73,
  bezier  = "almostLinear",
})
hl.animation({
  leaf    = "fadeOut",
  enabled = true,
  speed   = 1.46,
  bezier  = "almostLinear",
})
hl.animation({
  leaf    = "fade",
  enabled = true,
  speed   = 3.03,
  bezier  = "quick",
})
hl.animation({
  leaf    = "layers",
  enabled = true,
  speed   = 3.81,
  bezier  = "easeOutQuint",
})
hl.animation({
  leaf    = "layersIn",
  enabled = true,
  speed   = 2.5,
  bezier  = "spring",
  style   = "fade",
})
hl.animation({
  leaf    = "layersOut",
  enabled = true,
  speed   = 4,
  bezier  = "spring",
  style   = "fade",
})
hl.animation({
  leaf    = "fadeLayersIn",
  enabled = true,
  speed   = 1.79,
  bezier  = "almostLinear",
})
hl.animation({
  leaf    = "fadeLayersOut",
  enabled = true,
  speed   = 1.39,
  bezier  = "almostLinear",
})
hl.animation({
  leaf    = "workspaces",
  enabled = true,
  speed   = 2.00,
  bezier  = "easeOutQuint",
  style   = "slidefadevert 75%",
})
hl.animation({
  leaf    = "workspacesIn",
  enabled = true,
  speed   = 2.00,
  bezier  = "easeOutQuint",
  style   = "slidefadevert 75%",
})
hl.animation({
  leaf    = "workspacesOut",
  enabled = true,
  speed   = 2.00,
  bezier  = "easeOutQuint",
  style   = "slidefadevert 75%",
})
hl.animation({
  leaf    = "zoomFactor",
  enabled = true,
  speed   = 7,
  bezier  = "quick",
})

-- render (kitty color fix)
hl.config({
  render = {
    cm_enabled = false,
    cm_auto_hdr = false,
  },
})

-- dwindle
hl.config({
  dwindle = {
    preserve_split     = true,
    force_split        = 2,
    precise_mouse_move = true,
  },
})

-- scrolling
hl.config({
  scrolling = {
    column_width             = 0.5,
    direction                = "right",
    follow_focus             = true,
    focus_fit_method         = 1,
    fullscreen_on_one_column = true,
  },
})

-- master
hl.config({
  master = {
    new_status = "master",
  },
})

-- misc
hl.config({
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo   = true,
  },
})
