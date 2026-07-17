import QtQuick
import Quickshell
import "../../style"
import "../../services"
import "../../core"

ModulePill {
  id: root
  width: netModule.implicitWidth + 16

  property bool dropdownActive: false
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
      spacing: Theme.spacingSmall

      Text {
        text: "NET"
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: 10
        font.weight: 600
        font.letterSpacing: 1.2
        anchors.verticalCenter: parent.verticalCenter
      }

      Icon {
        name: netModule.connectionType === "none" ? "wifi" : netModule.connectionType
        size: 14
        iconColor: netModule.mudfishOn
        ? Theme.accent
        : netModule.connectionType === "none"
        ? Theme.danger
        : Theme.success
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
