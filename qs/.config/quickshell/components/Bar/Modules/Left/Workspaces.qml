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
  Timer {
    interval: 100
    running: root.focusedId < 0
    repeat: true
    onTriggered: root.refresh()
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (event.name === "workspacev2" || event.name === "focusedmon")
        root.refresh()
    }
  }

  Rectangle {
    id: background
    height: 22
    radius: 6
    color: Colors.overlay0
    width: label.implicitWidth + 16
  }

  Text {
    id: label
    anchors.centerIn: background
    text: root.focusedId > 0 ? root.focusedId : ""
    font { family: "FiraCode Nerd Font"; pixelSize: 12 }
    font.weight: 700
    color: Colors.text
  }
}
