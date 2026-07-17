pragma Singleton
import QtQuick
import "../style"

QtObject {
  // colors
  readonly property color bg: Colors.base
  readonly property color overlay: Colors.overlay0
  readonly property color surface: Colors.surface0
  readonly property color surfaceAlt: Colors.palette.surface1
  readonly property color surfaceBorder: Colors.palette.surface2
  readonly property color text: Colors.text
  readonly property color textMuted: Colors.subtext
  readonly property color accent: Colors.palette.blue
  readonly property color danger: Colors.palette.red
  readonly property color success: Colors.palette.green

  // fonts
  readonly property string fontFamily: Fonts.display
  readonly property string monoFamily: Fonts.mono

  // font sizes
  readonly property int fontSizeLarge: 14
  readonly property int fontSizeNormal: 13
  readonly property int fontSizeSmall: 12
  readonly property int fontSizeTiny: 11
  readonly property int fontSizeHeading: 36

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
