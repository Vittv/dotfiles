import QtQuick
import Quickshell.Hyprland
import "../../../../style/"
Item {
  id: root
  property var targetScreen
  height: 22
  width: background.width

  // Single source of truth for "which workspace is actually focused right now,"
  // instead of each item's own per-monitor "active" flag.
  readonly property int focusedId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1

  Rectangle {
    id: background
    height: 22
    radius: 6
    color: Colors.overlay0
    width: contentRow.width + 12
  }
  Rectangle {
    id: highlight
    width: 36
    height: 18
    radius: 6
    color: Colors.text
    y: (root.height - height) / 2
    Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
  }
  Row {
    id: contentRow
    anchors.centerIn: background
    spacing: 2
    Repeater {
      model: Hyprland.workspaces
      delegate: Item {
        required property var modelData
        property var ws: modelData
        width: 36
        height: 18

        // Recomputed whenever root.focusedId changes, so exactly one item
        // flips true and the previous one flips false, every time.
        readonly property bool isActive: ws.id === root.focusedId

        onIsActiveChanged: {
          if (isActive) highlight.x = mapToItem(root, 0, 0).x
        }
        Component.onCompleted: {
          if (isActive) highlight.x = mapToItem(root, 0, 0).x
        }
        Text {
          anchors.centerIn: parent
          text: ws.id
          font { family: "FiraCode Nerd Font"; pixelSize: 12 }
          font.weight: 500
          color: isActive ? Colors.base : Colors.text
        }
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: ws.activate()
        }
      }
    }
  }
}
