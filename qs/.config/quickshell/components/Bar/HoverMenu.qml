import QtQuick

// Hover-activated popup menu. Opens while either the trigger or the menu
// content is hovered, closes `closeDelay` ms after both stop being hovered.
//
// Requires `triggerItem` to expose a `hovered: bool` property (Logout.qml,
// Volume.qml, Clock.qml already do this).
PopupMenuBase {
  id: root

  property int closeDelay: 150

  property bool _triggerHovered: false

  function _refresh() {
    if (_triggerHovered || contentHovered) {
      closeTimer.stop()
      open = true
    } else {
      closeTimer.restart()
    }
  }

  onContentHoveredChanged: _refresh()

  Timer {
    id: closeTimer
    interval: root.closeDelay
    onTriggered: root.open = false
  }

  Connections {
    target: root.triggerItem
    function onHoveredChanged() {
      root._triggerHovered = root.triggerItem.hovered
      root._refresh()
    }
  }
}
