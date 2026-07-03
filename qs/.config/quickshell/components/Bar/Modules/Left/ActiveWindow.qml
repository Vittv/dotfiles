import QtQuick
import Quickshell.Hyprland
import "../../../../style/"

Item {
  id: root
  implicitHeight: 24
  width: 100
  property int maxWidth: 200

  readonly property var toplevel: Hyprland.activeToplevel
  property string displayText: toplevel ? toplevel.title : ""

  Text {
    id: label
    anchors {
      left: parent.left; leftMargin: 6
      verticalCenter: parent.verticalCenter
    }
    text: root.displayText || "Desktop"
    color: Colors.text
    font.pixelSize: 14
    font.family: "SF Compact Display"
    font.weight: Bold
    elide: Text.ElideRight
    width: parent.width - 12
  }
}
