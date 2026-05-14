-- ╔══════════════════════════════════╗
-- ║             𝕂𝕖𝕪𝕓𝕚𝕟𝕕𝕤             ║
-- ╚══════════════════════════════════╝

local mainMod = "SUPER"

-- apps
hl.bind(mainMod .. " + RETURN",    hl.dsp.exec_cmd(Terminal))
hl.bind(mainMod .. " + W",         hl.dsp.window.close())
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(FileManager))
hl.bind(mainMod .. " + A",         hl.dsp.exec_cmd(Browser))
hl.bind(mainMod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space",     hl.dsp.exec_cmd("~/.local/bin/dev.sh"))
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo())
hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd("pkill waybar && sleep 0.1 && waybar & disown"))
hl.bind(mainMod .. " + N",         hl.dsp.exec_cmd("~/.local/bin/wallswitch.sh"))
hl.bind("ALT + space",             hl.dsp.exec_cmd(Menu))
hl.bind("Control_R",               hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle && pkill -RTMIN+8 waybar"))

-- screenshots
hl.bind("PRINT",                   hl.dsp.exec_cmd("grimblast --notify --freeze copysave area"))
hl.bind("SHIFT + PRINT",           hl.dsp.exec_cmd("grimblast --notify --freeze copysave output"))

-- power / misc
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("~/.local/bin/powermenu.sh"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("bash -c 'COLOR=$(hyprpicker -a) && notify-send \"Hyprpicker 🎨\" \"<b>$COLOR</b> copied to clipboard\"'"))

-- focus
hl.bind(mainMod .. " + H",         hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J",         hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K",         hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L",         hl.dsp.focus({ direction = "right" }))

-- move windows
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- resize
hl.bind(mainMod .. " + CTRL + H",  hl.dsp.window.resize({ x = -50, y = 0   }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J",  hl.dsp.window.resize({ x = 0,   y = 50  }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K",  hl.dsp.window.resize({ x = 0,   y = -50 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L",  hl.dsp.window.resize({ x = 50,  y = 0   }), { repeating = true })

-- workspaces
hl.bind(mainMod .. " + 1",         hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2",         hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3",         hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4",         hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5",         hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6",         hl.dsp.focus({ workspace = 6 }))

-- move to workspace
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))

-- scrolling layout
hl.bind(mainMod .. " + period",             hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + comma",              hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + semicolon",          hl.dsp.layout("colresize 0.7"))
hl.bind(mainMod .. " + SHIFT + semicolon",  hl.dsp.layout("colresize 0.5"))
hl.bind(mainMod .. " + SHIFT + period",     hl.dsp.layout("colresize 1.0"))

-- special workspace
hl.bind(mainMod .. " + S",         hl.dsp.focus({ workspace = "special:magic" }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- mouse drag
hl.bind(mainMod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- media
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
