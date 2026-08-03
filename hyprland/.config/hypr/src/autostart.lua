-- ╔══════════════════════════════════╗
-- ║            𝔸𝕦𝕥𝕠𝕤𝕥𝕒𝕣𝕥             ║
-- ╚══════════════════════════════════╝

hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("dunst")
  hl.exec_cmd("bash -c 'swaybg -i \"$(cat ~/.cache/wallpaper-switcher/current)\" -m fill'")
  hl.exec_cmd("hyprsunset")
  hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
  hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
  hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  hl.exec_cmd("bash -c 'for i in $(seq 1 20); do DISPLAY=:0 xrandr --output DP-1 --primary 2>/dev/null && break; sleep 0.5; done'")

  hl.timer(function()
    hl.exec("nvibrant 307 307")
  end, {
    type = "oneshot",
    timeout = 3000,
  })
end)
