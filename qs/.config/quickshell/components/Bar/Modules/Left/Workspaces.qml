import QtQuick
import Quickshell.Hyprland
import "../../../../style/"

Row {
  id: root
  spacing: 4

  // jeceived from Bar.qml
  property var targetScreen

  Repeater {
    model: Hyprland.workspaces

    delegate: Rectangle {
      required property var modelData
      property var ws: modelData

      // correct comparison: match the name property of both objects
      visible: ws.active && ws.monitor && ws.monitor.name === root.targetScreen.name
      
      // dynamic width collapse to maintain clean padding/spacing
      width: visible ? 28 : 0
      height: visible ? 22 : 0
      
      radius: 4
      color: Colors.base

      Text {
        anchors.centerIn: parent
        text: ws.id
        color: Colors.text
        font.pixelSize: 13
        font.bold: true
        font.family: "FiraCode Nerd Font"
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: ws.activate()
      }
    }
  }
}
