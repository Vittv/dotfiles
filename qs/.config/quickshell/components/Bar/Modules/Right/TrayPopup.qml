import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../../style"

PopupWindow {
  id: root

  property var menuHandle: null
  property Item anchorItem: null

  implicitWidth: 220
  color: "transparent"
  grabFocus: true

  anchor {
    item: root.anchorItem
    rect.x: 0
    rect.y: 0
    edges: Edges.Bottom | Edges.Right
    gravity: Edges.Bottom | Edges.Left
  }

  function show(handle, item) {
    root.menuHandle = handle
    root.anchorItem = item
    opener.menu = handle
    root.open = true
  }

  QsMenuOpener {
    id: opener
  }

  Rectangle {
    anchors.fill: parent
    color: Colors.base
    radius: 10

    ColumnLayout {
      anchors { fill: parent; margins: 6 }
      spacing: 2

      Repeater {
        model: opener.children

        delegate: Item {
          id: menuItem
          required property QtObject modelData
          readonly property bool isSeparator: modelData.isSeparator === true || modelData.text === ""
          readonly property bool hasSubmenu: modelData.hasChildren === true

          Layout.fillWidth: true
          Layout.preferredHeight: isSeparator ? 8 : 32

          Rectangle {
            anchors.fill: parent
            radius: 6
            color: mouse.containsMouse ? Colors.surface : "transparent"
            visible: !isSeparator
            Behavior on color { ColorAnimation { duration: 80 } }
          }

          Rectangle {
            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
            height: 1
            color: Colors.palette.surface2
            visible: isSeparator
          }

          Text {
            anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
            text: modelData.text || ""
            color: Colors.text
            font.family: Fonts.display
            font.pixelSize: 13
            elide: Text.ElideRight
            visible: !isSeparator
          }

          MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            visible: !isSeparator
            onClicked: {
              if (hasSubmenu) {
                // submenu navigation
              } else {
                modelData.triggered()
                root.open = false
              }
            }
          }
        }
      }
    }
  }
}
