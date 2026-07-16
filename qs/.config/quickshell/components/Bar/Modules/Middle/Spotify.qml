import QtQuick
import QtQml
import Quickshell
import Quickshell.Io
import "../../../../style"

Rectangle {
  id: root
  width: spotifyContent.implicitWidth + 8
  implicitHeight: 20
  radius: 4
  color: Colors.palette.overlay0
  border.width: 1
  border.color: Colors.palette.surface2
  visible: spotifyContent.displayText !== ""

  Item {
    id: spotifyContent
    anchors.centerIn: parent
    property string trackInfo: ""
    property string playerStatus: ""
    property int volumePercent: 0
    property bool isActive: playerStatus === "Playing"
    property string activePlayerName: ""
    property string displayText: trackInfo !== "" ? ("󰓇  " + volumePercent + "% " + trackInfo) : ""
    implicitHeight: 24
    implicitWidth: 180

    function looksLikeSpotify(name, url) {
      const s = (name + url).toLowerCase()
      return s.indexOf("spotify") !== -1
    }

    Row {
      spacing: 6
      anchors.verticalCenter: parent.verticalCenter
      anchors.right: parent.right
      Item {
        id: textClip
        width: 150
        height: label.implicitHeight
        clip: true
        anchors.verticalCenter: parent.verticalCenter
        Text {
          id: label
          text: spotifyContent.displayText
          color: Colors.palette.text
          font.pixelSize: 13
          font.weight: Font.Medium
          font.family: "SF Pro Display"
          x: 0
          SequentialAnimation on x {
            id: scrollAnim
            running: label.implicitWidth > textClip.width && spotifyContent.displayText !== ""
            loops: Animation.Infinite
            PauseAnimation { duration: 2000 }
            NumberAnimation {
              from: 0
              to: -(label.implicitWidth - textClip.width + 8)
              duration: Math.max(2000, label.implicitWidth * 12)
              easing.type: Easing.Linear
            }
            PauseAnimation { duration: 800 }
            NumberAnimation {
              from: -(label.implicitWidth - textClip.width + 8)
              to: 0
              duration: Math.max(1500, label.implicitWidth * 8)
              easing.type: Easing.Linear
            }
          }
        }
      }
    }

    Process {
      id: initProcess
      command: ["bash", "-c",
        "player=$(playerctl -l 2>/dev/null | while read p; do " +
        "  info=$(playerctl -p \"$p\" metadata xesam:url mpris:trackid 2>/dev/null); " +
        "  echo \"$info\" | grep -qi spotify && echo \"$p\" && break; " +
        "done); " +
        "[ -z \"$player\" ] && exit 1; " +
        "echo \"$player\"; " +
        "playerctl -p \"$player\" status; " +
        "playerctl -p \"$player\" metadata --format '{{ title }} - {{ artist }}'; " +
        "playerctl -p \"$player\" volume"]
      running: true
      stdout: SplitParser {
        property int lineNum: 0
        onRead: (line) => {
          if (lineNum === 0) spotifyContent.activePlayerName = line
          else if (lineNum === 1) spotifyContent.playerStatus = line
          else if (lineNum === 2) spotifyContent.trackInfo = line
          else if (lineNum === 3) spotifyContent.volumePercent = Math.round(parseFloat(line) * 100) || 0
          lineNum++
        }
      }
    }

    Process {
      id: followMeta
      command: ["playerctl", "-a", "--follow", "metadata",
        "--format", "{{playerName}}\t{{status}}\t{{xesam:url}}\t{{title}} - {{artist}}"]
      running: true
      stdout: SplitParser {
        onRead: (line) => {
          const parts = line.split("\t")
          if (parts.length < 4) return
          const [name, status, url, info] = parts

          if (spotifyContent.looksLikeSpotify(name, url)) {
            spotifyContent.activePlayerName = name
            spotifyContent.playerStatus = status
            spotifyContent.trackInfo = info
          } else if (name === spotifyContent.activePlayerName) {
            spotifyContent.activePlayerName = ""
            spotifyContent.trackInfo = ""
            spotifyContent.playerStatus = ""
          }
        }
      }
    }

    Process {
      id: followVol
      command: ["playerctl", "-a", "--follow", "volume",
        "--format", "{{playerName}}\t{{volume}}"]
      running: true
      stdout: SplitParser {
        onRead: (line) => {
          const parts = line.split("\t")
          if (parts.length < 2) return
          const [name, vol] = parts
          if (name === spotifyContent.activePlayerName) {
            spotifyContent.volumePercent = Math.round(parseFloat(vol) * 100)
          }
        }
      }
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
      }
      onWheel: (wheel) => {
        if (wheel.angleDelta.y > 0) volUpProcess.running = true;
        else volDownProcess.running = true;
      }
    }
  }
}
