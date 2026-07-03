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
  font.family: "SF Pro Display"
  font.pixelSize: 15
  font.weight: Font.Medium
}
