import QtQuick
import "../../../../style"

Item {
  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  property bool hovered: mouseArea.containsMouse

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
  }
}
