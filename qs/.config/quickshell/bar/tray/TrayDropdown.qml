import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import "../../style"
import "../../core"

DropdownBase {
  id: root

  property var trayItemMenuHandle: null

  implicitWidth: 220
  implicitHeight: {
    var h = 0;
    var item = stackView.currentItem;
    if (item) h = item.implicitHeight;
    return h + 12 + 6;
  }

  backgroundColor: Colors.base
  radius: 6
  borderWidth: 1
  borderColor: Colors.palette.surface2

  HyprlandFocusGrab {
    windows: [root]
    active: root.open
    onCleared: root.open = false
  }

  function show(handle, item, x, y) {
    root.trayItemMenuHandle = handle
    root.triggerItem = item
    root.anchor.item = item
    root.anchor.rect = Qt.rect(x, y, 0, 0)
    stackView.clear()
    stackView.push(menuComponent, { handle: handle })
    root.open = true
  }

  function close() {
    root.open = false
    stackView.clear()
  }

  anchor {
    item: root.triggerItem
    rect: Qt.rect(0, 0, 0, 0)
    edges: Edges.Bottom | Edges.Right
    gravity: Edges.Bottom | Edges.Left
  }

  StackView {
    id: stackView
    anchors { fill: parent; leftMargin: 3; rightMargin: 3; topMargin: 8; bottomMargin: 8 }

    pushEnter: Transition {
      NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 100 }
    }
    pushExit: Transition {
      NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 100 }
    }
    popEnter: Transition {
      NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 100 }
    }
    popExit: Transition {
      NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 100 }
    }
  }

  Component {
    id: menuComponent
    ColumnLayout {
      id: submenu
      required property QsMenuHandle handle

      QsMenuOpener {
        id: menuOpener
        menu: submenu.handle
      }

      spacing: 4

      Repeater {
        model: menuOpener.children

        delegate: Item {
          id: menuItem
          required property QtObject modelData
          readonly property bool isSeparator: modelData.isSeparator === true || modelData.text === ""
          readonly property bool hasSubmenu: modelData.hasChildren === true

          Layout.fillWidth: true
          Layout.preferredHeight: isSeparator ? 4 : 26

          Rectangle {
            anchors.fill: parent
            radius: 4
            color: itemMouse.containsMouse ? Colors.surface : "transparent"
            visible: !isSeparator
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
            font.weight: 500
            font.pixelSize: 16
            elide: Text.ElideRight
            visible: !isSeparator
          }

          MouseArea {
            id: itemMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            visible: !isSeparator
            onClicked: {
              if (hasSubmenu) {
                stackView.push(menuComponent, { handle: modelData })
              } else {
                modelData.triggered()
                root.close()
              }
            }
          }
        }
      }
    }
  }
}
