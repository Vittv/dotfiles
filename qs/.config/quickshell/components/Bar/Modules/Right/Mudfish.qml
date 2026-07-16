import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: root
  property bool running: false
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: statusProc.running = true
  }

  Process {
    id: statusProc
    command: ["bash", "-c", "$HOME/.config/quickshell/src/mudfish/mudfish-status.sh"]
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => { root.running = line.includes("ON") }
    }
  }

  Row {
    id: row
    spacing: 4
    Icon {
      name: "computer"
      size: 14
      iconColor: root.running ? Colors.palette.blue : Colors.text
    }
  }

  Process { id: actionProc }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: (mouse) => {
      if (mouse.button === Qt.RightButton) {
        actionProc.command = ["bash", "-c", "$HOME/.config/quickshell/src/mudfish/mudfish-stop.sh"]
      } else {
        actionProc.command = ["bash", "-c", "$HOME/.config/quickshell/src/mudfish/mudfish-start.sh"]
      }
      actionProc.running = true
    }
  }
}
