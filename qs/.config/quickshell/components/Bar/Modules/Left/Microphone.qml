import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: micModule
  property bool muted: false
  implicitWidth: 14
  implicitHeight: 18

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

  Item {
    anchors.centerIn: parent
    width: 10; height: 10

    Rectangle {
      anchors.fill: parent
      radius: 2
      color: "transparent"
      border.width: 2
      border.color: Colors.text
      Behavior on border.color { ColorAnimation { duration: 100 } }
    }

    Rectangle {
      anchors.fill: parent
      radius: 2
      color: Colors.text
      opacity: muted ? 1 : 0
      Behavior on opacity { NumberAnimation { duration: 100 } }
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
