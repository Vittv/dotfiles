import QtQuick
import "../../../../services"
import "../../../../style"

Rectangle {
  id: root
  width: launcherIcon.implicitWidth + 8
  implicitHeight: 20
  radius: 4
  color: Colors.palette.overlay0
  border.width: 1
  border.color: Colors.palette.surface2

  Icon {
    id: launcherIcon
    anchors.centerIn: parent
    name: "command"
    size: 14
    iconColor: Colors.text
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: GlobalStates.toggle()
  }
}
