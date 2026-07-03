import QtQuick
import QtQml
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: root

  property string displayText: ""
  property int volumePercent: 0
  property string playerStatus: ""
  property bool isActive: playerStatus === "Playing"

  visible: displayText !== ""

  implicitHeight: 24
  implicitWidth: 180

  Row {
    spacing: 6
    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right

    // scrolling track text
    Item {
      id: textClip
      width: 150
      height: label.implicitHeight
      clip: true
      anchors.verticalCenter: parent.verticalCenter

      Text {
        id: label
        text: root.displayText
        color: Colors.palette.lavender
        font.pixelSize: 13
        font.weight: Font.Bold
        font.family: "SF Compact Display"
        x: 0

        SequentialAnimation on x {
          id: scrollAnim
          running: label.implicitWidth > textClip.width && root.displayText !== ""
          loops: Animation.Infinite

          PauseAnimation { duration: 2000 }
          NumberAnimation {
            from: 0
            to: -(label.implicitWidth - textClip.width + 8)
            duration: Math.max(2000, label.implicitWidth * 12)
            easing.type: Easing.Linear
          }
          PauseAnimation { duration: 2000 }
          NumberAnimation {
            from: -(label.implicitWidth - textClip.width + 8)
            to: 0
            duration: 0
          }
        }
      }
    }

    // equalizer bars
    Item {
      id: eq
      width: 27
      height: 16
      anchors.verticalCenter: parent.verticalCenter

      Repeater {
        id: eqRepeater
        model: 5

        Rectangle {
          width: 3
          radius: 1.5
          color: Colors.accent
          anchors.bottom: eq.bottom
          x: index * 5

          property real barHeight: 3 + Math.random() * 13
          height: root.isActive ? barHeight : 3

          Behavior on height {
            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
          }
        }
      }

      Timer {
        interval: 150
        repeat: true
        running: root.isActive
        onTriggered: {
          for (var i = 0; i < eqRepeater.count; i++) {
            var bar = eqRepeater.itemAt(i);
            if (bar) bar.barHeight = 3 + Math.random() * 13;
          }
        }
      }
    }
  }

  Process {
    id: pollProcess
    command: ["bash", "-c", "$HOME/.config/quickshell/src/spotify/spotify.sh"]
    running: true
    stdout: SplitParser {
      onRead: (line) => {
        try {
          let json = JSON.parse(line);
          root.displayText = json.text || "";
          root.playerStatus = json.status || "";
          let match = json.text.match(/(\d+)%/);
          root.volumePercent = match ? parseInt(match[1]) : 0;
        } catch(e) {
          root.displayText = line.trim();
        }
      }
    }
  }

  Timer {
    interval: 1500
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: pollProcess.running = true
  }

  Process { id: nextProcess; command: ["bash", "-c", "$HOME/.config/quickshell/src/spotify/spotify-ctl.sh next"] }
  Process { id: prevProcess; command: ["bash", "-c", "$HOME/.config/quickshell/src/spotify/spotify-ctl.sh previous"] }
  Process { id: playPauseProcess; command: ["bash", "-c", "$HOME/.config/quickshell/src/spotify/spotify-ctl.sh play-pause"] }
  Process { id: volUpProcess; command: ["bash", "-c", "$HOME/.config/quickshell/src/spotify/spotify-ctl.sh volume 0.05+"] }
  Process { id: volDownProcess; command: ["bash", "-c", "$HOME/.config/quickshell/src/spotify/spotify-ctl.sh volume 0.05-"] }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    onClicked: (mouse) => {
      if (mouse.button === Qt.LeftButton) nextProcess.running = true;
      else if (mouse.button === Qt.RightButton) prevProcess.running = true;
      else if (mouse.button === Qt.MiddleButton) playPauseProcess.running = true;
      pollProcess.running = true;
    }

    onWheel: (wheel) => {
      if (wheel.angleDelta.y > 0) volUpProcess.running = true;
      else volDownProcess.running = true;
    }
  }
}
