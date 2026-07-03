import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../../../style"

PanelWindow {
  id: root

  required property var panelWindow
  property bool hoveredAncestor: false

  width: 260
  implicitHeight: 232
  color: "transparent"

  screen: panelWindow.screen
  exclusionMode: ExclusionMode.Ignore
  anchors { right: true; top: true }
  margins.top: 30

  property bool _effectiveOpen: false

  onHoveredAncestorChanged: updateState()

  function updateState() {
    if (hoveredAncestor || (container.height > 0 && hoverHandler.hovered)) {
      closeTimer.stop()
      _effectiveOpen = true
    } else if (!closeTimer.running) {
      closeTimer.start()
    }
  }

  Timer {
    id: closeTimer
    interval: 150
    onTriggered: _effectiveOpen = false
  }

  Rectangle {
    id: container
    anchors { top: parent.top; left: parent.left; right: parent.right }
    clip: true
    color: Colors.base
    radius: 6

    height: _effectiveOpen ? parent.height : 0

    Behavior on height {
      NumberAnimation {
        duration: 250
        easing.type: Easing.OutQuart
      }
    }

    HoverHandler {
      id: hoverHandler
      onHoveredChanged: root.updateState()
    }

    ColumnLayout {
      anchors { left: parent.left; right: parent.right; top: parent.top }
      anchors.margins: 6
      spacing: 2

      Repeater {
        model: [
          { label: "Power Off",     cmd: "poweroff" },
          { label: "Restart",       cmd: "reboot" },
          { label: "Lock",          cmd: "hyprlock" },
          { label: "Logout",        cmd: "loginctl kill-session $XDG_SESSION_ID" },
          { label: "Suspend",       cmd: "systemctl suspend" },
          { label: "Hibernate",     cmd: "systemctl hibernate" },
        ]
        delegate: Rectangle {
          required property var modelData

          Layout.fillWidth: true
          Layout.preferredHeight: 34
          radius: 6
          color: "transparent"

          Text {
            anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
            text: modelData.label
            color: mouse.containsMouse ? Colors.accent : Colors.text
            font.family: Fonts.display
            font.weight: 500
            font.pixelSize: 14
          }

          MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
              Qt.createQmlObject(
                'import Quickshell.Io; Process { command: ["sh", "-c", ' + JSON.stringify(modelData.cmd) + '] }',
                root
              ).startDetached()
              root._effectiveOpen = false
            }
          }
        }
      }
    }
  }
}
