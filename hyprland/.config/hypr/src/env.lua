-- ╔══════════════════════════════════╗
-- ║      𝔼𝕟𝕧𝕚𝕣𝕠𝕟𝕞𝕖𝕟𝕥 𝕍𝕒𝕣𝕚𝕒𝕓𝕝𝕖𝕤       ║
-- ╚══════════════════════════════════╝

-- cursor
-- hl.env("XCURSOR_THEME", "Adwaita")
-- hl.env("XCURSOR_THEME", "mactahoe")
hl.env("XCURSOR_THEME", "MacOS-Tahoe-Cursor")
hl.env("XCURSOR_SIZE",  "26")

hl.config({
  cursor = {
    no_hardware_cursors = false,
  },
})

-- Qt and GTK
hl.env("GDK_BACKEND",        "wayland,x11,*")
hl.env("XDG_DATA_DIRS",      "/var/lib/flatpak/exports/share:/home/vitt/.local/share/flatpak/exports/share:/usr/local/share:/usr/share")
hl.env("QT_QPA_PLATFORM",    "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT6CT_PLATFORM_THEME", "qt6ct")

-- electron
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- screenshots
hl.env("XDG_SCREENSHOTS_DIR", os.getenv("HOME") .. "/Pictures/pictures/Screenshots")
