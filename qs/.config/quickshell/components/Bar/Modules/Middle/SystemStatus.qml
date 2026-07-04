import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: root
  height: 22
  width: background.width

  property real cpuTemp: 0
  property real cpuUsage: 0
  property real gpuTemp: 0
  property real gpuUsage: 0

  component RingGauge: Canvas {
    property real fraction: 0
    property color ringColor: Colors.accent
    property color trackColor: "#33ffffff"
    width: 16
    height: 16
    onFractionChanged: requestPaint()
    onRingColorChanged: requestPaint()
    onPaint: {
      var ctx = getContext("2d")
      ctx.reset()
      var cx = width / 2
      var cy = height / 2
      var r = Math.min(width, height) / 2 - 2

      ctx.beginPath()
      ctx.arc(cx, cy, r, 0, Math.PI * 2)
      ctx.strokeStyle = trackColor
      ctx.lineWidth = 2.5
      ctx.stroke()

      var startAngle = -Math.PI / 2
      var endAngle = startAngle + Math.max(0, Math.min(1, fraction)) * Math.PI * 2
      ctx.beginPath()
      ctx.arc(cx, cy, r, startAngle, endAngle)
      ctx.strokeStyle = ringColor
      ctx.lineWidth = 2.5
      ctx.lineCap = "round"
      ctx.stroke()
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      cpuProc.running = true
      gpuProc.running = true
    }
  }

  Process {
    id: cpuProc
    command: ["bash", "-c", "t=$(/usr/bin/sensors | awk '/Tctl:/ {gsub(/[+°C]/, \"\", \$2); print int(\$2)}'); u=$(vmstat 1 2 | tail -1 | awk '{print 100-\$15}'); echo $t,$u"]
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        let clean = line.trim()
        if (clean.length > 0) {
          let parts = clean.split(",")
          if (parts.length === 2) {
            root.cpuTemp = parseFloat(parts[0]) || 0
            root.cpuUsage = parseFloat(parts[1]) || 0
          }
        }
      }
    }
  }

  Process {
    id: gpuProc
    command: ["nvidia-smi", "--query-gpu=temperature.gpu,utilization.gpu", "--format=csv,noheader,nounits"]
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        let clean = line.trim()
        if (clean.length > 0) {
          let parts = clean.split(",")
          if (parts.length === 2) {
            root.gpuTemp = parseFloat(parts[0]) || 0
            root.gpuUsage = parseFloat(parts[1]) || 0
          }
        }
      }
    }
  }

  Rectangle {
    id: background
    height: 22
    radius: 6
    color: Colors.overlay0
    width: contentRow.width + 12
  }

  Row {
    id: contentRow
    anchors.centerIn: background
    spacing: 6

    Row {
      spacing: 4
      anchors.verticalCenter: parent.verticalCenter
      RingGauge {
        anchors.verticalCenter: parent.verticalCenter
        fraction: root.cpuUsage / 100
        ringColor: Colors.palette.blue
      }
      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: Math.round(root.cpuTemp) + "°"
        font { family: "FiraCode Nerd Font"; pixelSize: 12 }
        font.weight: 700
        color: Colors.text
      }
    }

    Rectangle {
      width: 1
      height: 12
      anchors.verticalCenter: parent.verticalCenter
      color: Colors.subtext
      opacity: 0.3
    }

    Row {
      spacing: 4
      anchors.verticalCenter: parent.verticalCenter
      RingGauge {
        anchors.verticalCenter: parent.verticalCenter
        fraction: root.gpuUsage / 100
        ringColor: Colors.palette.pink
      }
      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: Math.round(root.gpuTemp) + "°"
        font { family: "FiraCode Nerd Font"; pixelSize: 12 }
        font.weight: 700
        color: Colors.text
      }
    }
  }
}
