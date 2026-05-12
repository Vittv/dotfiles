-- ╔══════════════════════════════════╗
-- ║             ℍ𝕪𝕡𝕣𝕝𝕒𝕟𝕕             ║
-- ╚══════════════════════════════════╝

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/colors/?.lua"
require("src/env")
require("src/monitors")
require("src/input")
require("src/apps")
require("src/appearance")
require("src/autostart")
require("src/rules")
require("src/workspaces")
require("src/binds")
