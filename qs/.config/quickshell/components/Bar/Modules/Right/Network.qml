import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: netModule
  property string connectionType: "none"  // "wifi", "lan", or "none"
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: checkConn.running = true
  }

  Process {
    id: checkConn
    command: ["bash", "-c", "nmcli -t -f TYPE,STATE device status 2>/dev/null | grep ':connected$' | cut -d: -f1 | head -1"]
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        let t = line.trim();
        if (t === "wifi") netModule.connectionType = "wifi";
        else if (t === "ethernet") netModule.connectionType = "eth";
        else netModule.connectionType = "none";
      }
    }
  }

  Row {
    id: row
    spacing: 4
    Icon {
      name: netModule.connectionType === "none" ? "wifi" : netModule.connectionType
      size: 16
      iconColor: netModule.connectionType !== "none" ? Colors.text : Colors.surfaceAlt
    }
  }

  MouseArea {
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      Quickshell.exec("nm-connection-editor");
    }
  }
}
