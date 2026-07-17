import QtQuick
import Quickshell.Io
import "../../style"
import "../../core"

ModulePill {
  id: root
  width: micModule.implicitWidth + 8

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
      iconColor: micModule.muted ? Theme.maroon : Theme.yellow
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
