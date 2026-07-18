import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import "../../style"
import "../../core"

ClickMenu {
  id: root
  triggerItem: btModule

  implicitWidth: 320
  implicitHeight: 460
  backgroundColor: Theme.base
  radius: 10
  borderWidth: 1
  gap: 0
  borderColor: Theme.surface2

  readonly property bool btEnabled: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.enabled : false
  readonly property var connectedDevices: {
    var result = []
    if (!Bluetooth.devices) return result
    for (var i = 0; i < Bluetooth.devices.count; i++) {
      var d = Bluetooth.devices.values[i]
      if (d.connected) result.push(d)
    }
    return result
  }
  readonly property var pairedDevices: {
    var result = []
    if (!Bluetooth.devices) return result
    for (var i = 0; i < Bluetooth.devices.count; i++) {
      var d = Bluetooth.devices.values[i]
      if (!d.connected && d.paired) result.push(d)
    }
    return result
  }

  onOpenChanged: {
    if (open) {
      // refresh is automatic via reactive bindings
    }
  }

  ColumnLayout {
    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 14 }
    spacing: 12

    // header
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      Text {
        Layout.fillWidth: true
        text: "Bluetooth"
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: 16
        font.weight: Theme.weightBold
        elide: Text.ElideRight
      }

      Rectangle {
        width: powerText.implicitWidth + 14
        height: 28
        radius: 4
        color: powerMouse.containsMouse ? (root.btEnabled ? Theme.red : Theme.accent) : Theme.surface0
        border.width: 1
        border.color: Theme.surfaceBorder

        Text {
          id: powerText
          anchors.centerIn: parent
          text: root.btEnabled ? "On" : "Off"
          color: powerMouse.containsMouse ? Theme.base : (root.btEnabled ? Theme.accent : Theme.text)
          font.family: Theme.fontFamily
          font.pixelSize: 13
          font.weight: Theme.weightNormal
        }

        MouseArea {
          id: powerMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            var adapter = Bluetooth.defaultAdapter
            if (adapter) adapter.enabled = !adapter.enabled
          }
        }
      }
    }

    // CONNECTED
    SectionLabel { text: "CONNECTED" }

    ColumnLayout { Layout.fillWidth: true; spacing: 4

      Repeater {
        model: root.connectedDevices
        delegate: Rectangle {
          required property var modelData
          Layout.fillWidth: true
          Layout.preferredHeight: 42
          radius: 6
          color: Theme.surface0

          RowLayout {
            anchors { left: parent.left; right: parent.right; leftMargin: 10; rightMargin: 10; verticalCenter: parent.verticalCenter }
            spacing: 8

            StatusDot { active: true; dotColor: Theme.accent }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 0

              Text {
                Layout.fillWidth: true
                text: modelData.name || modelData.deviceName || modelData.address
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: 14
                font.weight: Theme.weightNormal
                elide: Text.ElideRight
              }

              Text {
                Layout.fillWidth: true
                text: {
                  var parts = []
                  if (modelData.batteryAvailable) parts.push(Math.round(modelData.battery * 100) + "%")
                  parts.push(modelData.address)
                  return parts.join(" · ")
                }
                color: Theme.subtext
                font.family: Theme.fontFamily
                font.pixelSize: 12
                elide: Text.ElideRight
              }
            }

            Rectangle {
              width: dcText.implicitWidth + 14
              height: 26
              radius: 4
              color: dcMouse.containsMouse ? Theme.red : Theme.surface0
              border.width: 1
              border.color: Theme.surfaceBorder

              Text {
                id: dcText
                anchors.centerIn: parent
                text: "Disconnect"
                color: dcMouse.containsMouse ? Theme.base : Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: 12
                font.weight: Theme.weightNormal
              }

              MouseArea {
                id: dcMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: modelData.disconnect()
              }
            }
          }
        }
      }

      Text {
        visible: root.connectedDevices.length === 0
        text: root.btEnabled ? "No connected devices" : "Bluetooth is off"
        color: Theme.subtextDark
        font.family: Theme.fontFamily
        font.pixelSize: 13
        font.italic: true
      }
    }

    // PAIRED
    SectionLabel { text: "PAIRED" }

    ColumnLayout { Layout.fillWidth: true; spacing: 4

      Repeater {
        model: root.pairedDevices
        delegate: Rectangle {
          required property var modelData
          Layout.fillWidth: true
          Layout.preferredHeight: 42
          radius: 6
          color: pairedMouse.containsMouse ? Theme.surface0 : "transparent"

          RowLayout {
            anchors { left: parent.left; right: parent.right; leftMargin: 10; rightMargin: 10; verticalCenter: parent.verticalCenter }
            spacing: 8

            StatusDot { active: false }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 0

              Text {
                Layout.fillWidth: true
                text: modelData.name || modelData.deviceName || modelData.address
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: 14
                font.weight: Theme.weightNormal
                elide: Text.ElideRight
              }

              Text {
                Layout.fillWidth: true
                text: modelData.address
                color: Theme.subtext
                font.family: Theme.fontFamily
                font.pixelSize: 12
                elide: Text.ElideRight
              }
            }

            Rectangle {
              width: pairBtnText.implicitWidth + 14
              height: 26
              radius: 4
              color: pairBtnMouse.containsMouse ? Theme.accent : Theme.surface0
              border.width: 1
              border.color: Theme.surfaceBorder

              Text {
                id: pairBtnText
                anchors.centerIn: parent
                text: "Connect"
                color: pairBtnMouse.containsMouse ? Theme.base : Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: 12
                font.weight: Theme.weightNormal
              }

              MouseArea {
                id: pairBtnMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: modelData.connect()
              }
            }
          }

          MouseArea {
            id: pairedMouse
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
          }
        }
      }

      Text {
        visible: root.pairedDevices.length === 0
        text: "No paired devices"
        color: Theme.subtextDark
        font.family: Theme.fontFamily
        font.pixelSize: 13
        font.italic: true
      }
    }
  }
}
