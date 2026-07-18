pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string connectionType: "none"
  property bool mudfishOn: false

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
        if (type === "wifi") root.connectionType = "wifi";
        else if (type === "ethernet") root.connectionType = "eth";
      }
    }
    onRunningChanged: {
      if (running) root.connectionType = "none";
    }
  }

  Process {
    id: checkMudfish
    command: ["pgrep", "-x", "mudrun-headless"]
    stdout: SplitParser {
      onRead: () => { root.mudfishOn = true }
    }
    onExited: (code) => { root.mudfishOn = (code === 0) }
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
}
