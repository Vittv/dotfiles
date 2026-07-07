import QtQuick
import Quickshell
import "../../../../style/"
Text {
  id: root
  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
  text: Qt.formatDateTime(clock.date, "dd") + "  •  " + Qt.formatDateTime(clock.date, "hh:mm AP") 
  color: Colors.text
  font.family: "SF Compact Display"
  font.pixelSize: 14
  font.weight: 600
  horizontalAlignment: Text.AlignHCenter
  property bool hovered: hoverArea.containsMouse
  signal clicked()
  MouseArea {
    id: hoverArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
