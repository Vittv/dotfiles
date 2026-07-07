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

  property string tctlPath: ""
  property real prevIdle: -1
  property real prevTotal: -1

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

  // one-time discovery of the hwmon file for "Tctl" (AMD CPU temp label)
  // this is the only fork we ever do for CPU temp; after this we just read a file.
  Process {
    id: tctlFind
    command: ["bash", "-c",
      "for f in /sys/class/hwmon/hwmon*/temp*_label; do " +
      "  if [ \"$(cat \"$f\" 2>/dev/null)\" = \"Tctl\" ]; then " +
      "    echo \"${f%_label}_input\"; break; " +
      "  fi; " +
      "done"]
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        const p = line.trim()
        if (p.length > 0) root.tctlPath = p
      }
    }
    running: true
  }

  FileView {
    id: tctlFile
    path: root.tctlPath !== "" ? root.tctlPath : ""
  }

  FileView {
    id: procStat
    path: "/proc/stat"
  }

  // polls two plain files
  Timer {
    interval: 3000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      // CPU temp: hwmon reports millidegrees
      if (root.tctlPath !== "") {
        tctlFile.reload()
        const raw = parseFloat(tctlFile.text())
        if (!isNaN(raw)) root.cpuTemp = raw / 1000
      }

      // CPU usage: delta of /proc/stat's aggregate "cpu" line
      procStat.reload()
      const firstLine = procStat.text().split("\n")[0]
      const fields = firstLine.trim().split(/\s+/).slice(1).map(Number)
      // user nice system idle iowait irq softirq steal
      const idle = fields[3] + fields[4]
      const total = fields.reduce((a, b) => a + b, 0)

      if (root.prevTotal >= 0) {
        const deltaIdle = idle - root.prevIdle
        const deltaTotal = total - root.prevTotal
        if (deltaTotal > 0) {
          root.cpuUsage = Math.max(0, Math.min(100, 100 * (1 - deltaIdle / deltaTotal)))
        }
      }
      root.prevIdle = idle
      root.prevTotal = total
    }
  }

  // GPU: one persistent nvidia-smi in loop mode instead of re-spawning
  // (and re-initializing NVML) every tick.
  Process {
    id: gpuProc
    command: ["nvidia-smi", "--query-gpu=temperature.gpu,utilization.gpu",
              "--format=csv,noheader,nounits", "--loop=3"]
    running: true
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
