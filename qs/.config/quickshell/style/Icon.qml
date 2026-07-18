import QtQuick
import "."
import "../core"

Text {
  id: root

  property string name: ""
  property int size: 16
  property color iconColor: Theme.text

  readonly property var _glyphs: ({
    "volume_up":     "\ue050",
    "volume_down":   "\ue04d",
    "volume_mute":   "\ue04e",
    "volume_off":    "\ue04f",
    "inbox":         "\ueb74",
    "bolt":          "\uea0b",
    "eco":           "\uea35",
    "balance":       "\ueaf6",
    "power":         "\ue8ac",
    "settings":      "\ue8b8",
    "wifi":          "\ue63e",
    "eth":           "\uefe6",
    "computer":      "\ue30c",
    "bluetooth":     "\ue1a7",
    "battery_full":  "\ue1a5",
    "cpu":           "\ue322",
    "gpu":           "\ue9e4",
    "mic":           "\ue029",
    "mic_off":       "\ue02b",
    "logout":        "\ue9ba",
    "chevron_left":  "\ue5cb",
    "chevron_right": "\ue5cc",
    "lock":          "\ue897",
    "sleep":         "\uf037",
    "hibernate":     "\uef44",
    "restart":       "\ue5d5",
    "command":       "\ueae7",
    "network":       "󰤨",
    "network_off":   "󰤭"
  })

  readonly property var _nerdIcons: (["arch", "network", "network_off"])

  text: _glyphs[root.name] || "?"
  font.family: root.name in _nerdIcons ? "FiraCode Nerd Font Mono" : "Material Icons"
  font.pixelSize: root.size
  font.weight: Theme.weightNormal
  color: root.iconColor
  verticalAlignment: Text.AlignVCenter
  horizontalAlignment: Text.AlignHCenter
}
