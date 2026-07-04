import QtQuick
import Quickshell
import "../../../../style/"

Text {
  id: root

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  text: Qt.formatDateTime(clock.date, "hh:mm AP") + "  •  " + Qt.formatDateTime(clock.date, "MMM dd").toLowerCase()
  color: Colors.text
  font.family: "SF Pro Display"
  font.letterSpacing: 0.8
  font.pixelSize: 14
  font.weight: 600
  horizontalAlignment: Text.AlignHCenter

  property bool hovered: hoverArea.containsMouse

  MouseArea {
    id: hoverArea
    anchors.fill: parent
    hoverEnabled: true
  }
}
