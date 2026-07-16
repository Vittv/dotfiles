import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

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
    property string connectionType: "none"
    property bool mudfishOn: false
    property bool popupActive: root.popupActive
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Process {
      id: checkConn
      command: ["nmcli", "-t", "-f", "TYPE,STATE", "device", "status"]
      stdout: SplitParser {
        splitMarker: "\n"
        onRead: (line) => {
          const parts = line.split(":");
          const type = parts[0];
          const state = parts[1];
          if (state !== "connected") return;
          if (type === "wifi") netModule.connectionType = "wifi";
          else if (type === "ethernet") netModule.connectionType = "eth";
        }
      }
      onRunningChanged: {
        if (running) netModule.connectionType = "none";
      }
    }

    Process {
      id: checkMudfish
      command: ["pgrep", "-x", "mudfish"]
      stdout: SplitParser {
        onRead: () => { netModule.mudfishOn = true }
      }
      onExited: (code) => { netModule.mudfishOn = (code === 0) }
      onRunningChanged: {
        if (running) netModule.mudfishOn = false
      }
    }

    Process {
      id: monitor
      command: ["nmcli", "monitor"]
      running: true
      stdout: SplitParser {
        splitMarker: "\n"
        onRead: (line) => {
          checkConn.running = true;
        }
      }
    }

    Timer {
      interval: 5000
      running: true
      repeat: true
      triggeredOnStart: true
      onTriggered: checkMudfish.running = true
    }

    Component.onCompleted: {
      checkConn.running = true
      checkMudfish.running = true
    }

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
