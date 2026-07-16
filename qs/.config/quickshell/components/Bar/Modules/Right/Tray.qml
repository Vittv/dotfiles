import QtQuick
import Quickshell.Services.SystemTray
import "../../../../style"

Rectangle {
  id: root
  width: trayRow.implicitWidth + 8
  implicitHeight: 20
  radius: 4
  color: "transparent"

  Row {
    id: trayRow
    anchors.centerIn: parent
    spacing: 6

    Repeater {
      model: SystemTray.items

      delegate: Item {
        id: trayDelegate
        required property var modelData
        property var trayItem: modelData

        implicitWidth: 14
        implicitHeight: 14

        Image {
          anchors.fill: parent
          source: trayItem.icon
          sourceSize { width: 18; height: 18 }
          fillMode: Image.PreserveAspectFit
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
              trayItem.activate();
            else if (mouse.button === Qt.RightButton && trayItem.hasMenu) {
              var pos = trayDelegate.mapToItem(null, trayDelegate.width, 0);
              trayItem.display(panel, pos.x, pos.y);
            }
          }
        }
      }
    }
  }
}
