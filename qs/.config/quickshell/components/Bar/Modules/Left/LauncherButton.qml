import QtQuick
import "../../../../style"
import "../../../../services/"

Item {
  id: root
  property var targetScreen
  height: 22
  width: background.width

  Rectangle {
    id: background
    height: 22
    radius: 6
    color: hoverArea.containsMouse ? Colors.surface : Colors.overlay0
    width: icon.implicitWidth + 26

    Behavior on color { ColorAnimation { duration: 120 } }
  }

  Text {
    id: icon
    anchors.centerIn: background
    text: "\uf303"
    font.family: "YourNerdFont Nerd Font"
    font.pixelSize: 14
    color: Colors.text
  }

  MouseArea {
    id: hoverArea
    anchors.fill: background
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      var screenName = root.targetScreen ? root.targetScreen.name : ""
      if (GlobalStates.launcherOpen && GlobalStates.launcherScreen === screenName) {
        GlobalStates.launcherOpen = false
      } else {
        GlobalStates.launcherScreen = screenName
        GlobalStates.launcherOpen = true
      }
    }
  }
}
