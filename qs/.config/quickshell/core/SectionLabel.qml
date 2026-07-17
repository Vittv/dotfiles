import QtQuick
import QtQuick.Layouts
import "."

RowLayout {
  id: root

  required property string text

  spacing: Theme.spacing

  Rectangle {
    width: 3
    height: 12
    radius: 1.5
    color: Theme.accent
  }

  Text {
    text: root.text
    color: Theme.textMuted
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeSmall
    font.letterSpacing: 1.2
    font.weight: 600
  }
}
