import QtQuick
import "../../../../style"

Item {
  id: root
  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  signal clicked()

  Icon {
    id: icon
    name: "logout"
    size: 14
    iconColor: Colors.text
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
