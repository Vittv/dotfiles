import QtQuick
import Quickshell.Hyprland

DropdownBase {
  id: root

  HyprlandFocusGrab {
    id: focusGrab
    windows: [root]
    active: root.open
    onCleared: root.open = false
  }

  Connections {
    target: root.triggerItem
    function onClicked() {
      root.open = !root.open
    }
  }
}
