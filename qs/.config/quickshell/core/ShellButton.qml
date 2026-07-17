import QtQuick
import "."

Rectangle {
  id: root

  required property string label
  property bool danger: false
  signal activated

  implicitWidth: btnLabel.implicitWidth + 18
  implicitHeight: Theme.buttonHeight
  color: btnMouse.containsMouse
    ? (root.danger ? Theme.red : Theme.blue)
    : Theme.surface2
  radius: Theme.buttonRadius
  opacity: enabled ? 1 : 0.5

  Text {
    id: btnLabel
    anchors.centerIn: parent
    text: root.label
    color: Theme.text
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeTiny
    font.weight: Theme.weightSemibold
  }

  MouseArea {
    id: btnMouse
    anchors.fill: parent
    enabled: root.enabled
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.activated()
  }
}
