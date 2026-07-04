import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../../../style"

PopupWindow {
  id: root

  required property var panelWindow
  property bool open: false

  width: 260
  implicitHeight: 232
  color: Colors.base

  grabFocus: true

  anchor {
    window: panelWindow
    rect.x: panelWindow.width + 22
    rect.y: panelWindow.height
    margins.top: 4
  }

  onOpenChanged: visible = open

  onVisibleChanged: {
    if (visible != open) open = visible
  }

  ColumnLayout {
    anchors { fill: parent; margins: 6 }
    spacing: 2

    Repeater {
      model: [
        { label: "Lock",          cmd: "hyprlock" },
        { label: "Logout",        cmd: "loginctl kill-session $XDG_SESSION_ID" },
        { label: "Suspend",       cmd: "systemctl suspend" },
        { label: "Hibernate",     cmd: "systemctl hibernate" },
        { label: "Shutdown",      cmd: "poweroff" },
        { label: "Restart",       cmd: "reboot" },
      ]

      delegate: Rectangle {
        required property var modelData

        Layout.fillWidth: true
        Layout.preferredHeight: 34
        radius: 6
        color: mouse.containsMouse ? Colors.base : "transparent"

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
            root.open = false
          }
        }
      }
    }
  }
}
