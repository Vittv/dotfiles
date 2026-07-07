import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: netModule
  property string connectionType: "none"
  signal clicked()
  property bool popupActive: false
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  // one-shot status check: single process, parsed in JS instead of
  // piping through bash | grep | cut | head.
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
      // reset before each check so a stale "wifi"/"eth" doesn't linger
      // if nothing matches.
      if (running) netModule.connectionType = "none";
    }
  }

  // long-lived process that blocks on nmcli's own event stream instead
  // of us polling every 5s. only triggers a status re-check on an
  // actual connectivity change.
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

  // initial check on startup, since monitor only reports future changes.
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
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: netModule.clicked()
  }
}
