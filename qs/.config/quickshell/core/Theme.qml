pragma Singleton
import QtQuick
import "../style"

QtObject {
  // palette
  readonly property color base: "#171719"
  readonly property color surface0: "#252530"
  readonly property color surface1: "#333738"
  readonly property color surface2: "#4a4a52"
  readonly property color surfaceBorder: "#4a4a52"
  readonly property color moduleBorder: "#525266"
  readonly property color text: "#cdcdcd"
  readonly property color subtext: "#90a0b5"
  readonly property color subtextDark: "#4a5568"
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

  // semantic aliases
  readonly property color accent: blue

  // fonts
  readonly property string fontFamily: Fonts.display
  readonly property string compFamily: Fonts.compact
  readonly property string monoFamily: Fonts.mono

  // font sizes
  readonly property int fontSizeLarge: 14
  readonly property int fontSizeNormal: 13
  readonly property int fontSizeSmall: 12
  readonly property int fontSizeTiny: 11
  readonly property int fontSizeHeading: 36

  // font weights
  readonly property int weightNormal: 500
  readonly property int weightSemibold: 600
  readonly property int weightBold: 700

  // bar
  readonly property int barHeight: 28
  readonly property int moduleHeight: 20
  readonly property int moduleRadius: 4
  readonly property int moduleBorderWidth: 1

  // pill
  readonly property int pillHeight: 26
  readonly property int pillRadius: 6
  readonly property int pillPadding: 8

  // dropdown
  readonly property int dropdownRadius: 12
  readonly property int dropdownMargin: 18
  readonly property int dropdownSpacing: 12

  // button
  readonly property int buttonHeight: 28
  readonly property int buttonRadius: 6

  // spacing
  readonly property int spacing: 8
  readonly property int spacingSmall: 4
  readonly property int spacingTight: 2

  // animation
  readonly property int animFast: 120
  readonly property int animNormal: 180
}
