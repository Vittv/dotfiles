pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string activePlayerName: ""
  property string playerStatus: ""
  property string trackInfo: ""
  property int volumePercent: 0
  property bool isActive: playerStatus === "Playing"
  property string displayText: trackInfo !== "" ? ("󰓇  " + volumePercent + "% " + trackInfo) : ""

  function looksLikeSpotify(name, url) {
    const s = (name + url).toLowerCase()
    return s.indexOf("spotify") !== -1
  }

  Timer {
    id: playerAliveTimer
    interval: 1000
    running: root.activePlayerName !== ""
    repeat: true
    onTriggered: aliveProc.running = true
  }

  Process {
    id: aliveProc
    command: ["bash", "-c", "playerctl -l 2>/dev/null | grep -qxF '" + root.activePlayerName + "' && echo alive || echo dead"]
    stdout: SplitParser {
      onRead: (line) => {
        if (line === "dead") {
          root.activePlayerName = ""
          root.trackInfo = ""
          root.playerStatus = ""
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
}
