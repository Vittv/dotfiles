import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: micModule
  property bool muted: false
  implicitWidth: 10
  implicitHeight: 20

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
        if (line.includes("source")) checkMic.running = true;
      }
    }
  }

  Component.onCompleted: checkMic.running = true;

  Rectangle {
    anchors.fill: parent
    radius: 4
    color: "transparent"
  }

  Icon {
    anchors.centerIn: parent
    name: muted ? "mic_off" : "mic"
    size: 14
    iconColor: muted ? Colors.red : Colors.text
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      Quickshell.exec(["bash", "-c", "pactl set-source-mute @DEFAULT_SOURCE@ toggle"]);
    }
  }
}
