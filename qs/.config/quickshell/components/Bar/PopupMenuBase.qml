import Quickshell
import QtQuick

PopupWindow {
  id: root

  required property Item triggerItem
  property int gap: 12

  property int edgesFlag: Edges.Bottom | Edges.Left
  property int gravityFlag: Edges.Bottom | Edges.Right

  property bool centered: false
  property bool centerInWindow: false

  readonly property real _windowWidth: (triggerItem && triggerItem.Window && triggerItem.Window.window)
    ? triggerItem.Window.window.width : 0

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

  property int animDuration: 140
  property int slideDistance: 10

  property color backgroundColor: "transparent"
  property int radius: 0
  color: "transparent"

  default property alias menuContent: hoverArea.data
  readonly property bool contentHovered: hoverArea.containsMouse

  property bool open: false
  visible: false

  anchor {
    item: root.triggerItem
    rect: root._anchorRect
    edges: (root.centered || root.centerInWindow) ? (Edges.Bottom | Edges.Left) : root.edgesFlag
    gravity: (root.centered || root.centerInWindow) ? (Edges.Bottom | Edges.Right) : root.gravityFlag
    margins.bottom: -root.gap
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
      border.width: 0
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
