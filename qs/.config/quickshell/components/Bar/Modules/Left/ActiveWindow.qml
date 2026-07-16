import QtQuick
import Quickshell.Hyprland
import "../../../../style/"

Rectangle {
  id: root
  width: Math.min(label.implicitWidth + 8, 200)
  implicitHeight: 20
  radius: 4
  color: Colors.palette.overlay0
  border.width: 1
  border.color: Colors.palette.surface2
  visible: label.text !== ""

  property var toplevel: Hyprland.activeToplevel
  property string activeTitle: toplevel ? toplevel.title : ""

  Text {
    id: label
    anchors.centerIn: parent
    width: parent.width - 8
    text: root.activeTitle
    color: Colors.text
    font.pixelSize: 13
    font.weight: Font.Medium
    font.family: "SF Pro Display"
    elide: Text.ElideRight
    maximumLineCount: 1
  }
}
