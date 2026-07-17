import QtQuick
import Quickshell
import "../../style"
import "../../core"

ModulePill {
  id: root
  anchors.centerIn: parent
  implicitWidth: clockLabel.implicitWidth + 12

  Text {
    id: clockLabel
    anchors.centerIn: parent
    SystemClock {
      id: clock
      precision: SystemClock.Seconds
    }
    text: Qt.formatDateTime(clock.date, "dd") + "  •  " + Qt.formatDateTime(clock.date, "hh:mm AP")
    color: Theme.text
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeNormal
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
