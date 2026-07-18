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
      spacing: Theme.spacingTight

      Text {
        text: netModule.mudfishOn ? "MUD" : "NET"
        color: Theme.text
        font.family: Theme.monoFamily
        font.pixelSize: 12
        font.weight: Theme.weightSemibold
        font.letterSpacing: 1.2
        anchors.verticalCenter: parent.verticalCenter
      }

      Icon {
        name: netModule.connectionType === "none" ? "network_off" : "network"
        size: 8
        iconColor: netModule.connectionType === "none"
        ? Theme.red
        : Theme.green
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
