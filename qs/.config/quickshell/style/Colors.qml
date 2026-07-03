pragma Singleton
import QtQuick

QtObject {
  id: root

  readonly property QtObject palette: QtObject {
    readonly property color base: "#171719"
    readonly property color mantle: "#131313"
    readonly property color crust: "#11111b"
    readonly property color surface0: "#2c2c3e"
    readonly property color surface1: "#333738"
    readonly property color surface2: "#405065"
    readonly property color text: "#cdcdcd"
    readonly property color subtext1: "#b4d4cf"
    readonly property color subtext0: "#90a0b5"
    readonly property color overlay2: "#878787"
    readonly property color overlay1: "#606079"
    readonly property color overlay0: "#252530"
    readonly property color rosewater: "#efefdc"
    readonly property color flamingo: "#f7d498"
    readonly property color pink: "#bb9dbd"
    readonly property color mauve: "#b0a0d0"
    readonly property color red: "#d8647e"
    readonly property color maroon: "#c48482"
    readonly property color peach: "#e0a363"
    readonly property color yellow: "#f3be7c"
    readonly property color green: "#7fa563"
    readonly property color teal: "#b4d4cf"
    readonly property color sky: "#9bb4bc"
    readonly property color sapphire: "#6e94b2"
    readonly property color blue: "#7e98e8"
    readonly property color lavender: "#aeaed1"
  }

  // semantic aliases - change these to re-theme everything at once
  readonly property color base: palette.base
  readonly property color surface: palette.surface0
  readonly property color surfaceAlt: palette.surface1
  readonly property color surface0: palette.surface0
  readonly property color overlay0: palette.overlay0
  readonly property color text: palette.text
  readonly property color subtext: palette.subtext0
  readonly property color accent: palette.blue
  readonly property color red: palette.red
  readonly property color yellow: palette.yellow
  readonly property color green: palette.green
}
