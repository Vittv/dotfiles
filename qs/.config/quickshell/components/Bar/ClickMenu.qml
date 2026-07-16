import QtQuick
import Quickshell.Hyprland

// click-activated popup menu. click the trigger to open, click it again to
// close.
//
// requires `triggerItem` to expose a `clicked()` signal (see Clock.qml).
PopupMenuBase {
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
