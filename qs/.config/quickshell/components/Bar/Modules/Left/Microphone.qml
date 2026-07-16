import QtQuick
import Quickshell.Io
import "../../../../style"

Rectangle {
  id: root
  width: micModule.implicitWidth + 8
  implicitHeight: 20
  radius: 4
  color: Colors.palette.overlay0
  border.width: 1
  border.color: Colors.palette.surface2
  Behavior on color { ColorAnimation { duration: 120 } }

  property bool muted: micModule.muted

  Item {
    id: micModule
    anchors.centerIn: parent
    property bool muted: false
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    function checkMute() { checkMic.running = true }

    Process {
      id: checkMic
      command: ["bash", "-c", "pactl get-source-mute @DEFAULT_SOURCE@ | grep -q yes && echo muted || echo unmuted"]
      stdout: SplitParser {
        splitMarker: "\n"
        onRead: (line) => { micModule.muted = line.trim() === "muted" }
      }
    }

    Process {
      id: subscribeProc
      command: ["pactl", "subscribe"]
      running: true
      stdout: SplitParser {
        splitMarker: "\n"
        onRead: (line) => { if (line.includes("source")) checkMic.running = true }
      }
    }

    Component.onCompleted: checkMic.running = true;

    Icon {
      id: icon
      anchors.centerIn: parent
      name: micModule.muted ? "mic_off" : "mic"
      size: 14
      iconColor: micModule.muted ? Colors.palette.maroon : Colors.yellow
    }

    Process {
      id: toggleProc
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        toggleProc.command = ["bash", "-c", "pactl set-source-mute @DEFAULT_SOURCE@ toggle"];
        toggleProc.running = true;
        checkMic.running = true;
      }
    }
  }
}
