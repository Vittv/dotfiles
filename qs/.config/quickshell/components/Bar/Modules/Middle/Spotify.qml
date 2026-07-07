import QtQuick
import QtQml
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: root
  property string trackInfo: ""
  property string playerStatus: ""
  property int volumePercent: 0
  property bool isActive: playerStatus === "Playing"
  property string activePlayerName: ""

  // reactive binding instead of a frozen string -> recomputes
  // automatically whenever trackInfo OR volumePercent changes,
  // from whichever stream (metadata or volume) updated last.
  property string displayText: trackInfo !== "" ? ("󰓇  " + volumePercent + "% " + trackInfo) : ""

  visible: displayText !== ""
  implicitHeight: 24
  implicitWidth: 180
  width: implicitWidth
  height: implicitHeight

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
          PauseAnimation { duration: 800 }
          // smooth scroll back instead of an instant snap.
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

  // one-shot initial fetch on startup so volume/track aren't stuck
  // at their zero-value defaults until the first change event fires.
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
        if (lineNum === 0) root.activePlayerName = line
        else if (lineNum === 1) root.playerStatus = line
        else if (lineNum === 2) root.trackInfo = line
        else if (lineNum === 3) root.volumePercent = Math.round(parseFloat(line) * 100) || 0
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

        if (root.looksLikeSpotify(name, url)) {
          root.activePlayerName = name
          root.playerStatus = status
          root.trackInfo = info
        } else if (name === root.activePlayerName) {
          root.activePlayerName = ""
          root.trackInfo = ""
          root.playerStatus = ""
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
        if (name === root.activePlayerName) {
          root.volumePercent = Math.round(parseFloat(vol) * 100)
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
