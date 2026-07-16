import QtQuick
import Quickshell
import "../../../../style/"

Rectangle {
  id: root
  anchors.centerIn: parent
  implicitWidth: clockLabel.implicitWidth + 12
  implicitHeight: 20
  radius: 4
  color: Colors.overlay0
  border.width: 1
  border.color: Colors.palette.surface2

  Text {
    id: clockLabel
    anchors.centerIn: parent
    SystemClock {
      id: clock
      precision: SystemClock.Seconds
    }
    text: Qt.formatDateTime(clock.date, "dd") + "  •  " + Qt.formatDateTime(clock.date, "hh:mm AP")
    color: Colors.text
    font.family: "SF Pro Display"
    font.pixelSize: 13
    font.weight: 500
    horizontalAlignment: Text.AlignHCenter
  }

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
