import QtQuick
import "../../../../style/"

Canvas {
  id: gauge
  property real value: 0        // current temp
  property real maxValue: 100   // temp treated as "full circle"
  property color fillColor: "#4A90E2"
  property color trackColor: Colors.palette.overlay1
  width: 18
  height: 18

  readonly property real fraction: Math.max(0, Math.min(1, value / maxValue))

  onValueChanged: requestPaint()
  onWidthChanged: requestPaint()
  onHeightChanged: requestPaint()

  onPaint: {
    var ctx = getContext("2d")
    ctx.reset()
    var cx = width / 2
    var cy = height / 2
    var r = Math.min(width, height) / 2 - 1

    // background track — full faint circle
    ctx.beginPath()
    ctx.arc(cx, cy, r, 0, Math.PI * 2)
    ctx.fillStyle = trackColor
    ctx.fill()

    // filled pie slice representing value/maxValue, starting at 12 o'clock
    var startAngle = -Math.PI / 2
    var endAngle = startAngle + gauge.fraction * Math.PI * 2
    ctx.beginPath()
    ctx.moveTo(cx, cy)
    ctx.arc(cx, cy, r, startAngle, endAngle)
    ctx.closePath()
    ctx.fillStyle = gauge.fillColor
    ctx.fill()
  }
}
