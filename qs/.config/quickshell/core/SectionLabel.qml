import QtQuick
import QtQuick.Layouts
import "."

RowLayout {
  id: root

  required property string text

  spacing: 0

  Text {
    text: root.text
    color: Theme.subtext
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeNormal
    font.weight: Theme.weightNormal
  }
}
