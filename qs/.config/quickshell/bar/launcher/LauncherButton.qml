import QtQuick
import "../../services"
import "../../style"
import "../../core"

ModulePill {
  id: root
  width: launcherIcon.implicitWidth + 8

  Icon {
    id: launcherIcon
    anchors.centerIn: parent
    name: "command"
    size: 14
    iconColor: Theme.text
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: GlobalStates.toggle()
  }
}
