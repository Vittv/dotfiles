pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Wayland

Singleton {
  id: root

  property var _anchors: ({})

  function forScreen(screen) {
    return screen ? root._anchors[screen.name] : null
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: anchorWin
      required property var modelData
      screen: modelData

      anchors { top: true; left: true; right: true; bottom: true }
      exclusiveZone: 0
      color: "transparent"
      WlrLayershell.layer: WlrLayer.Background
      mask: Region {}

      Component.onCompleted: root._anchors[modelData.name] = anchorWin
    }
  }
}
