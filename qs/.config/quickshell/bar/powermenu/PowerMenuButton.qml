import QtQuick
import "../../style"
import "../../core"

ModulePill {
  id: root
  width: powerIcon.implicitWidth + 8

  signal clicked()

  Item {
    id: powerIcon
    anchors.centerIn: parent
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    Icon {
      id: icon
      name: "power"
      size: 12
      iconColor: Theme.red
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: root.clicked()
    }
  }
}
