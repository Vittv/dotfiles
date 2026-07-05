import QtQuick

// click-activated popup menu. click the trigger to open, click it again to
// close.
//
// requires `triggerItem` to expose a `clicked()` signal (see Clock.qml).
PopupMenuBase {
  id: root

  Connections {
    target: root.triggerItem
    function onClicked() {
      root.open = !root.open
    }
  }
}
