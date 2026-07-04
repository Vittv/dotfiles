import QtQuick
import Quickshell
import "../../../../style/"

Text {
  id: root

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  text: Qt.formatDateTime(clock.date, "dd • hh:mm AP")
  color: "#F0F0F0"
  font.family: "SF Compact Display"
  font.pixelSize: 14
  font.weight: 600

  property bool hovered: hoverArea.containsMouse

  MouseArea {
    id: hoverArea
    anchors.fill: parent
    hoverEnabled: true
  }
}
