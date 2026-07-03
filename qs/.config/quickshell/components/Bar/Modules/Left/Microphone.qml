import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: micModule
  property bool muted: false
  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  function checkMute() {
    checkMic.running = true;
  }

  Process {
    id: checkMic
    command: ["bash", "-c", "pactl get-source-mute @DEFAULT_SOURCE@ | grep -q yes && echo muted || echo unmuted"]
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        micModule.muted = line.trim() === "muted";
      }
    }
  }

  Process {
    id: subscribeProc
    command: ["pactl", "subscribe"]
    running: true
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        if (line.includes("source")) {
          checkMic.running = true;
        }
      }
    }
  }

  Component.onCompleted: checkMic.running = true;

  Icon {
    id: icon
    name: micModule.muted ? "mic_off" : "mic"
    size: 12
    iconColor: micModule.muted ? Colors.red : Colors.text
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      Quickshell.exec(["bash", "-c", "pactl set-source-mute @DEFAULT_SOURCE@ toggle"]);
    }
  }
}
