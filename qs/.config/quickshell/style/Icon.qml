import QtQuick
import "."

Text {
  id: root

  property string name: ""
  property int size: 16
  property color iconColor: Colors.text

  readonly property var _glyphs: ({
    "volume_up":     "\ue050",
    "volume_down":   "\ue04d",
    "volume_mute":   "\ue04e",
    "volume_off":    "\ue04f",
    "inbox":         "\ue7f4",
    "bolt":          "\uea0b",
    "eco":           "\uea35",
    "balance":       "\ueaf6",
    "power":         "\ue63c",
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
  })

  readonly property var _nerdIcons: (["arch"])

  text: _glyphs[root.name] || "?"
  font.family: root.name in _nerdIcons ? "FiraCode Nerd Font Mono" : "Material Icons"
  font.pixelSize: root.size
  color: root.iconColor
  verticalAlignment: Text.AlignVCenter
  horizontalAlignment: Text.AlignHCenter
}
