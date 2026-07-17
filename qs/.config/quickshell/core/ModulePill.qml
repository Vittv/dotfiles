import QtQuick
import "."

Rectangle {
  id: root

  default property alias content: body.data

  property bool active: false

  implicitWidth: body.implicitWidth + Theme.pillPadding * 2
  implicitHeight: Theme.moduleHeight
  radius: Theme.moduleRadius
  color: active ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.12) : Theme.overlay
  border.width: Theme.moduleBorderWidth
  border.color: Theme.surfaceBorder

  Item {
    id: body
    anchors.centerIn: parent
    width: parent.width
    height: parent.height
  }
}
