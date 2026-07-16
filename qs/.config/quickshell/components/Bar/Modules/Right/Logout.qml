import QtQuick
import "../../../../style"

Rectangle {
  id: root
  width: logoutIcon.implicitWidth + 8
  implicitHeight: 20
  radius: 4
  color: Colors.surface
  border.width: 1
  border.color: Colors.palette.surface2

  signal clicked()

  Item {
    id: logoutIcon
    anchors.centerIn: parent
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    Icon {
      id: icon
      name: "power"
      size: 12
      iconColor: Colors.text
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: root.clicked()
    }
  }
}
