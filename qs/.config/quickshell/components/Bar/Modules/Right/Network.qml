import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"
import "../../../../services/"

Rectangle {
  id: root
  width: netModule.implicitWidth + 16
  implicitHeight: 20
  radius: 4
  color: Colors.overlay0
  border.width: 1
  border.color: Colors.palette.surface2

  property bool popupActive: false
  signal clicked()

  Item {
    id: netModule
    anchors.centerIn: parent
    property string connectionType: NetworkService.connectionType
    property bool mudfishOn: NetworkService.mudfishOn
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
      id: row
      spacing: 4

      Text {
        text: "NET"
        color: Colors.text
        font.family: Fonts.display
        font.pixelSize: 10
        font.weight: 600
        font.letterSpacing: 1.2
        anchors.verticalCenter: parent.verticalCenter
      }

      Icon {
        name: netModule.connectionType === "none" ? "wifi" : netModule.connectionType
        size: 14
        iconColor: netModule.mudfishOn
          ? Colors.palette.blue
          : netModule.connectionType === "none"
          ? Colors.red
          : Colors.green
        anchors.verticalCenter: parent.verticalCenter
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: root.clicked()
    }
  }
}
