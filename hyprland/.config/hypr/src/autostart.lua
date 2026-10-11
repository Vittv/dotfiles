-- ╔══════════════════════════════════╗
-- ║            𝔸𝕦𝕥𝕠𝕤𝕥𝕒𝕣𝕥             ║
-- ╚══════════════════════════════════╝

-- Chromium/Electron apps pick their display via the Xwayland "primary" output.
-- xrandr --primary is dropped on dpms off/on and monitor hotplug events, so we
-- re-apply DP-1 (144Hz) as primary on every such event, not just at startup.
-- Idempotent: skips the --primary call when DP-1 is already primary.
local function set_xwayland_primary()
  hl.exec_cmd("bash -c 'disp=\"$(DISPLAY=:0 xrandr --query 2>/dev/null)\"; if ! echo \"$disp\" | grep -q \"DP-1\"; then for i in $(seq 1 30); do DISPLAY=:0 xrandr --query 2>/dev/null | grep -q \"DP-1\" && break; sleep 0.5; done; fi; DISPLAY=:0 xrandr --query 2>/dev/null | grep -q \"DP-1.*primary\" || DISPLAY=:0 xrandr --output DP-1 --primary 2>/dev/null'")
end

hl.on("monitor.added", set_xwayland_primary)
hl.on("monitor.removed", set_xwayland_primary)
hl.on("monitor.layout_changed", set_xwayland_primary)
hl.on("config.reloaded", set_xwayland_primary)

hl.on("hyprland.start", function()
  -- hl.exec_cmd("noctalia")
  hl.exec_cmd("waybar")
  hl.exec_cmd("playerctld daemon")
  hl.exec_cmd("dunst")
  hl.exec_cmd("bash -c 'swaybg -i \"$(cat ~/.cache/wallpaper-switcher/current)\" -m fill'")
  hl.exec_cmd("hyprsunset")
  hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
  hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
  hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  set_xwayland_primary()

  hl.timer(function()
    hl.exec("nvibrant 307 307")
  end, {
    type = "oneshot",
    timeout = 3000,
  })
end)
