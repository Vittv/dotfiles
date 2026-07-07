import QtQuick
import Quickshell.Io
import "../../../../style"

Item {
  id: micModule
  property bool muted: false
  implicitWidth: 12
  implicitHeight: 12

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

  Rectangle {
    anchors.centerIn: parent
    width: 8
    height: 8
    radius: 1.5
    border.width: 2
    color: muted ? Colors.palette.text : "transparent"
    border.color: Colors.text

    Behavior on color { ColorAnimation { duration: 150; easing.type: Easing.OutCubic } }
    Behavior on border.color { ColorAnimation { duration: 150; easing.type: Easing.OutCubic } }
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
