import Quickshell
import QtQuick

// generic hover-activated popup menu, with a slide+fade in/out animation
// and rounded corners.
//
// wire up a `triggerItem` (any Item exposing a `hovered: bool` property,
// the menu opens while either the trigger or the menu content is hovered,
// and closes `closeDelay` ms after both stop being hovered.
//
// anything you put inside a HoverMenu {} block becomes content, e.g.:
//
//   HoverMenu {
//     triggerItem: someIcon
//     implicitWidth: 260
//     implicitHeight: 232
//     backgroundColor: Colors.base
//     radius: 12
//     ColumnLayout { anchors.fill: parent; ... }
//   }
PopupWindow {
  id: root

  required property Item triggerItem
  property int closeDelay: 150    // grace period (ms) before closing
  property int gap: 4             // px gap between trigger and popup

  // where the popup anchors on the trigger, and which way it grows
  property int edgesFlag: Edges.Bottom | Edges.Left
  property int gravityFlag: Edges.Bottom | Edges.Right

  // animation tuning
  property int animDuration: 140
  property int slideDistance: 10

  // appearance - a real Wayland window can't have rounded corners itself,
  // so the window is kept fully transparent and this Rectangle draws the
  // visible rounded "card" inside it.
  property color backgroundColor: "transparent"
  property int radius: 0

  // the window itself must stay transparent for rounding to work -
  // set backgroundColor above instead of `color` on a HoverMenu instance
  color: "transparent"

  default property alias menuContent: hoverArea.data

  property bool open: false
  visible: false   // driven manually below, not a direct binding to `open`,
                   // so the close animation has time to play before we hide

  anchor {
    item: root.triggerItem
    edges: root.edgesFlag
    gravity: root.gravityFlag
    margins.top: root.gap
  }

  onOpenChanged: {
    if (open) {
      closeAnim.stop()
      visible = true
      openAnim.restart()
    } else {
      openAnim.stop()
      closeAnim.restart()
    }
  }

  property bool _triggerHovered: false
  property bool _contentHovered: false

  function _refresh() {
    if (_triggerHovered || _contentHovered) {
      closeTimer.stop()
      open = true
    } else {
      closeTimer.restart()
    }
  }

  Timer {
    id: closeTimer
    interval: root.closeDelay
    onTriggered: root.open = false
  }

  // Listen to the trigger's own hover state instead of overlaying another
  // MouseArea on top of it (which would just steal its hover events).
  Connections {
    target: root.triggerItem
    function onHoveredChanged() {
      root._triggerHovered = root.triggerItem.hovered
      root._refresh()
    }
  }

  Item {
    id: animRoot
    anchors.fill: parent
    opacity: 0
    transform: Translate { id: slideTransform; y: -root.slideDistance }

    Rectangle {
      id: bg
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
      onContainsMouseChanged: {
        root._contentHovered = containsMouse
        root._refresh()
      }
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
}
