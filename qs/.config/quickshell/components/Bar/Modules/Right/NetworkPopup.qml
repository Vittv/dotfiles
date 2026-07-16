import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../../../style"
import "../../../Bar"

ClickMenu {
  id: root
  triggerItem: netModule

  implicitWidth: 300
  implicitHeight: 200
  backgroundColor: Colors.base
  radius: 12

  // data
  property string activeIface: ""
  property var rxHistory: []
  property var txHistory: []
  property real rxSpeed: 0
  property real txSpeed: 0
  property real maxSpeed: 1
  property string connectionInfo: ""

  property real prevRx: -1
  property real prevTx: -1

  // find active interface by reading /proc/net/route directly
  // no bash/awk fork needed.
  FileView {
    id: routeFile
    path: "/proc/net/route"
    onLoaded: {
      const lines = text().split("\n")
      for (let i = 1; i < lines.length; i++) {
        const cols = lines[i].trim().split(/\s+/)
        if (cols.length > 1 && cols[1] === "00000000") {
          root.activeIface = cols[0]
          break
        }
      }
    }
  }
  Component.onCompleted: routeFile.reload()

  // poll rx/tx byte counters via FileView instead of a persistent
  // bash "while true; sleep 1; cat ..." loop. No forking at all
  // just a QFile read on a timer.
  FileView {
    id: rxFile
    path: root.activeIface !== "" ? "/sys/class/net/" + root.activeIface + "/statistics/rx_bytes" : ""
  }
  FileView {
    id: txFile
    path: root.activeIface !== "" ? "/sys/class/net/" + root.activeIface + "/statistics/tx_bytes" : ""
  }

  Timer {
    interval: 1000
    running: root.activeIface !== ""
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      rxFile.reload()
      txFile.reload()

      const rx = parseInt(rxFile.text())
      const tx = parseInt(txFile.text())
      if (isNaN(rx) || isNaN(tx)) return

      if (root.prevRx >= 0) {
        root.rxSpeed = Math.max(0, rx - root.prevRx)
        root.txSpeed = Math.max(0, tx - root.prevTx)

        root.rxHistory.push(root.rxSpeed)
        root.txHistory.push(root.txSpeed)
        if (root.rxHistory.length > 30) root.rxHistory.shift()
        if (root.txHistory.length > 30) root.txHistory.shift()

        let m = 1
        for (let i = 0; i < root.rxHistory.length; i++)
          m = Math.max(m, root.rxHistory[i], root.txHistory[i])
        root.maxSpeed = Math.max(m, 1)
        graphCanvas.requestPaint()
      }
      root.prevRx = rx
      root.prevTx = tx
    }
  }

  // connection info -> single process, parsed in JS (no grep/cut/bash)
  Process {
    id: infoProc
    command: ["bash", "-c",
      "nmcli -t -f TYPE,STATE dev status; echo '---'; nmcli -t -f ACTIVE,SSID dev wifi"]
    property bool inWifiSection: false
    property bool typeFound: false
    property string parsedType: ""
    property string parsedSsid: ""
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        if (line === "---") { infoProc.inWifiSection = true; return }
        if (!infoProc.inWifiSection) {
          if (infoProc.typeFound) return
          const parts = line.split(":")
          if (parts[1] === "connected" && (parts[0] === "wifi" || parts[0] === "ethernet")) {
            infoProc.parsedType = parts[0]
            infoProc.typeFound = true
          }
        } else {
          const parts = line.split(":")
          if (parts[0] === "yes") infoProc.parsedSsid = parts[1]
        }
      }
    }
    onExited: (exitCode, exitStatus) => {
      root.connectionInfo = parsedType + "|" + parsedSsid
    }
    running: true
  }

  Process { id: nmProc }

  function fmtSpeed(bps) {
    if (bps >= 1000000) return (bps / 1000000).toFixed(1) + " Mbps"
    if (bps >= 1000) return (bps / 1000).toFixed(0) + " Kbps"
    return (bps / 1000).toFixed(1) + " Kbps"
  }

  ColumnLayout {
    anchors { fill: parent; margins: 12 }
    spacing: 6

    RowLayout {
      Layout.fillWidth: true
      spacing: 6

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 0

        Text {
          text: root.connectionInfo.split("|")[0] === "wifi" ? "WiFi"
              : root.connectionInfo.split("|")[0] === "ethernet" ? "Ethernet"
              : "Disconnected"
          color: Colors.text
          font.family: Fonts.display
          font.pixelSize: 14
          font.weight: 700
        }

        Text {
          text: root.connectionInfo.split("|")[1] || root.activeIface
          color: Colors.subtext
          font.family: Fonts.display
          font.pixelSize: 11
          visible: root.connectionInfo !== ""
        }
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 1

      Text {
        text: "↓ " + root.fmtSpeed(root.rxSpeed)
        color: Colors.accent
        font.family: Fonts.display
        font.pixelSize: 13
        font.weight: 600
      }
      Text {
        text: "↑ " + root.fmtSpeed(root.txSpeed)
        color: Colors.palette.pink
        font.family: Fonts.display
        font.pixelSize: 13
        font.weight: 600
      }
    }

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 80
      radius: 8
      color: Colors.overlay0
      clip: true

      Canvas {
        id: graphCanvas
        anchors.fill: parent
        anchors.margins: 4

        onPaint: {
          var ctx = getContext("2d")
          var w = width
          var h = height
          ctx.clearRect(0, 0, w, h)

          if (root.rxHistory.length < 2) return

          var len = root.rxHistory.length
          var max = root.maxSpeed
          var stepX = w / (len - 1)

          function scale(v) {
            return h - (v / max) * (h - 4) - 2
          }

          ctx.beginPath()
          ctx.moveTo(0, scale(root.txHistory[0]))
          for (var i = 1; i < len; i++)
            ctx.lineTo(i * stepX, scale(root.txHistory[i]))
          ctx.strokeStyle = Colors.palette.pink
          ctx.lineWidth = 2
          ctx.stroke()

          ctx.beginPath()
          ctx.moveTo(0, scale(root.rxHistory[0]))
          for (var i = 1; i < len; i++)
            ctx.lineTo(i * stepX, scale(root.rxHistory[i]))
          ctx.strokeStyle = Colors.accent
          ctx.lineWidth = 2
          ctx.stroke()
        }
      }
    }
  }

  Icon {
    name: "settings"
    size: 14
    iconColor: Colors.palette.overlay1
    anchors { top: parent.top; right: parent.right; margins: 12 }

    MouseArea {
      anchors.fill: parent
      anchors.margins: -4
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        nmProc.command = ["nm-connection-editor"]
        nmProc.running = true
        root.open = false
      }
    }
  }
}
