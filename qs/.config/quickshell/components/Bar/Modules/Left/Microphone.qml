import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: micModule
  property bool muted: false
  implicitWidth: track.width
  implicitHeight: track.height

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
    id: track
    width: 34
    height: 16
    radius: height / 2
    color: muted ? Colors.surface0 : Colors.palette.lavender

    Behavior on color {
      ColorAnimation { duration: 150 }
    }

  Rectangle {
    id: knob
    width: 16
    height: 16
    radius: width / 2
    color: Colors.base
    anchors.verticalCenter: parent.verticalCenter
    x: muted ? -1 : parent.width - width + 1

    Behavior on x {
      NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
    }

    Icon {
      anchors.centerIn: parent
      name: muted ? "mic_off" : "mic"
      size: 10
      iconColor: muted ? Colors.red : Colors.text
    }
  }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        Quickshell.exec(["bash", "-c", "pactl set-source-mute @DEFAULT_SOURCE@ toggle"]);
      }
    }
  }
}
