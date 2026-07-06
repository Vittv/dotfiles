import QtQuick
import Quickshell.Hyprland
import "../../../../style/"

Item {
  id: root
  property var targetScreen
  height: 22
  width: background.width

  property int focusedId: -1

  function refresh() {
    var m = targetScreen ? Hyprland.monitorFor(targetScreen) : null
    root.focusedId = m && m.activeWorkspace ? m.activeWorkspace.id : -1
  }

  Component.onCompleted: refresh()

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (event.name === "workspacev2" || event.name === "focusedmon")
        root.refresh()
    }
  }

  onFocusedIdChanged: {
    for (var i = 0; i < contentRow.children.length; i++) {
      var child = contentRow.children[i]
      if (child.ws && child.ws.id === focusedId) {
        highlight.x = child.mapToItem(root, 0, 0).x
        break
      }
    }
  }

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

        readonly property bool isActive: ws.id === root.focusedId

        onXChanged: {
          if (isActive) highlight.x = mapToItem(root, 0, 0).x
        }
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
