-- ╔══════════════════════════════════╗
-- ║               𝕀𝕟𝕡𝕦𝕥              ║
-- ╚══════════════════════════════════╝

hl.config({
  input = {
    kb_layout    = "br",
    kb_variant   = "abnt2",
    kb_model     = "",
    kb_options   = "",
    kb_rules     = "",
    repeat_rate  = 50,
    repeat_delay = 250,
    follow_mouse = 2,
    sensitivity  = -0.2, -- -1.0 - 1.0, 0 means no modification.
    touchpad = {
      natural_scroll = false,
    },
  },
})

-- gestures
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace"
})
