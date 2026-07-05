import Quickshell
import QtQuick

// shared foundation for popup menus: anchor positioning relative to a
// trigger item, slide+fade open/close animation, and a rounded background
// (the window itself stays transparent - see HoverMenu.qml's header comment
// for why). this type doesn't decide *how* the menu opens - that's left to
// whatever wraps it. See HoverMenu.qml (hover-triggered) and
// ClickMenu.qml (click-triggered).
PopupWindow {
  id: root

  required property Item triggerItem
  property int gap: 4   // px gap between trigger and popup

  // where the popup anchors on the trigger, and which way it grows
  property int edgesFlag: Edges.Bottom | Edges.Left
  property int gravityFlag: Edges.Bottom | Edges.Right

  // set true to center the popup horizontally under the trigger instead of
  // left-aligning it - useful when the popup is much wider than the trigger
  property bool centered: false

  property bool centerInWindow: false

  readonly property real _windowWidth: (triggerItem && triggerItem.Window && triggerItem.Window.window)
    ? triggerItem.Window.window.width : 0

  // computed fresh right when the popup opens (not a live binding) - a
  // binding through mapToItem() wouldn't be re-evaluated when the trigger's
  // position changes, since QML can't see inside the method call to know
  // it should track that dependency, so it could go stale and center on a
  // wrong, cached position.
  property real _centerOffsetX: 0

  function _recomputeCenterOffset() {
    if (!triggerItem) { _centerOffsetX = 0; return }
    var itemX = triggerItem.mapToItem(null, 0, 0).x
    _centerOffsetX = (_windowWidth - width) / 2 - itemX
  }

  readonly property rect _anchorRect: {
    if (centerInWindow) {
      return Qt.rect(_centerOffsetX, 0, width, triggerItem.height)
    } else if (centered) {
      return Qt.rect((triggerItem.width - width) / 2, 0, width, triggerItem.height)
    } else {
      return Qt.rect(0, 0, triggerItem.width, triggerItem.height)
    }
  }

  // animation tuning
  property int animDuration: 140
  property int slideDistance: 10

  // appearance - window stays transparent, this Rectangle draws the
  // visible rounded "card"
  property color backgroundColor: "transparent"
  property int radius: 0
  color: "transparent"

  default property alias menuContent: hoverArea.data
  readonly property bool contentHovered: hoverArea.containsMouse

  property bool open: false
  visible: false   // driven manually, not bound directly to `open`, so the
  grabFocus: true    // close animation has time to play before we hide

  anchor {
    item: root.triggerItem
    rect: root._anchorRect
    edges: (root.centered || root.centerInWindow) ? (Edges.Bottom | Edges.Left) : root.edgesFlag
    gravity: (root.centered || root.centerInWindow) ? (Edges.Bottom | Edges.Right) : root.gravityFlag
    margins.top: root.gap
  }

  onOpenChanged: {
    if (triggerItem && triggerItem.hasOwnProperty("popupActive"))
      triggerItem.popupActive = open
    if (open) {
      if (centerInWindow) _recomputeCenterOffset()
      closeAnim.stop()
      visible = true
      openAnim.restart()
    } else {
      openAnim.stop()
      closeAnim.restart()
    }
  }

  onVisibleChanged: {
    if (!visible && open) {
      openAnim.stop()
      closeAnim.stop()
      open = false
    }
  }

  Item {
    id: animRoot
    anchors.fill: parent
    opacity: 0
    transform: Translate { id: slideTransform; y: -root.slideDistance }

    Rectangle {
      anchors.fill: parent
      radius: root.radius
      color: root.backgroundColor
      antialiasing: true
      border.width: 0   // avoids QTBUG-137166 (transparent rect + border)
    }

    MouseArea {
      id: hoverArea
      anchors.fill: parent
      hoverEnabled: true
    }
  }

  ParallelAnimation {
    id: openAnim
    NumberAnimation { target: animRoot; property: "opacity"; to: 1; duration: root.animDuration; easing.type: Easing.OutCubic }
    NumberAnimation { target: slideTransform; property: "y"; to: 0; duration: root.animDuration; easing.type: Easing.OutCubic }
  }

  SequentialAnimation {
    id: closeAnim
    ParallelAnimation {
      NumberAnimation { target: animRoot; property: "opacity"; to: 0; duration: root.animDuration; easing.type: Easing.InCubic }
      NumberAnimation { target: slideTransform; property: "y"; to: -root.slideDistance; duration: root.animDuration; easing.type: Easing.InCubic }
    }
    ScriptAction { script: root.visible = false }
  }
  Shortcut {
    sequence: "Escape"
    enabled: root.open
    onActivated: root.open = false
  }
}
