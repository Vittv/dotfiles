import QtQuick
import "."

Rectangle {
  default property alias content: body.data

  property bool active: false

  implicitWidth: body.implicitWidth + Theme.pillPadding * 2
  implicitHeight: Theme.moduleHeight
  radius: Theme.moduleRadius
  color: active ? Qt.rgba(Theme.blue.r, Theme.blue.g, Theme.blue.b, 0.12) : Theme.surface0
  border.width: Theme.moduleBorderWidth
  border.color: Theme.moduleBorder

  Item {
    id: body
    anchors.centerIn: parent
    width: parent.width
    height: parent.height
  }
}
