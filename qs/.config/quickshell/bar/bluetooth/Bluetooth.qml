import QtQuick
import Quickshell
import Quickshell.Bluetooth
import "../../style"
import "../../core"

ModulePill {
  id: root
  width: btRow.implicitWidth + 8

  property bool dropdownActive: false
  signal clicked()

  readonly property bool btEnabled: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.enabled : false
  readonly property int deviceCount: Bluetooth.devices ? Bluetooth.devices.count : 0
  readonly property bool hasConnection: deviceCount > 0

  Row {
    id: btRow
    anchors.centerIn: parent
    spacing: Theme.spacingSmall

    Icon {
      name: "bluetooth"
      size: 10
      iconColor: Theme.accent
      anchors.verticalCenter: parent.verticalCenter
    }

    Text {
      text: "BT"
      color: Theme.text
        font.family: Theme.monoFamily
      font.pixelSize: 12
      font.weight: Theme.weightSemibold
      font.letterSpacing: 1.2
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
