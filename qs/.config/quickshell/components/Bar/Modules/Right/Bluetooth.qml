import QtQuick
import Quickshell.Bluetooth
import "../../../../style"

Item {
  id: root
  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  readonly property bool connected: Bluetooth.defaultAdapter
    ? Bluetooth.defaultAdapter.devices.count > 0
    : false

  Icon {
    id: icon
    name: "bluetooth"
    size: 16
    iconColor:  Colors.text
  }
}
