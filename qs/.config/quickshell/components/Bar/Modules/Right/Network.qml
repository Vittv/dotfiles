import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

Rectangle {
  id: root
  width: netModule.implicitWidth + 8
  implicitHeight: 20
  radius: 4
  color: Colors.surface
  border.width: 1
  border.color: Colors.palette.surface2

  property string connectionType: netModule.connectionType
  signal clicked()
  property bool popupActive: netModule.popupActive

  Item {
    id: netModule
    anchors.centerIn: parent
    property string connectionType: "none"
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

    Component.onCompleted: checkConn.running = true

    Row {
      id: row
      spacing: 4
      Icon {
        name: netModule.connectionType === "none" ? "wifi" : netModule.connectionType
        size: 14
        iconColor: netModule.popupActive ? Colors.accent : (netModule.connectionType === "none" ? Colors.red : Colors.text)
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
