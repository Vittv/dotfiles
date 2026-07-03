import QtQuick
import "../../../../style"

Item {
  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  signal clicked()
  property bool hovered: mouseArea.containsMouse

  Icon {
    id: icon
    name: "logout"
    size: 16
    iconColor: Colors.text
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: parent.clicked()
  }
}
