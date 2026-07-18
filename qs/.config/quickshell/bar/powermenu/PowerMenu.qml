import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../style"
import "../../core"

ClickMenu {
  id: root

  implicitWidth: 200
  implicitHeight: contentColumn.implicitHeight + 24
  backgroundColor: Theme.base
  radius: 8
  borderWidth: 1
  gap: 0
  borderColor: Theme.surface2

  property int selectedIndex: -1

  Process { id: actionProc }

  function executeSelected() {
    if (selectedIndex < 0 || selectedIndex >= 6) return
    var cmds = ["poweroff", "reboot", "hyprlock", "loginctl kill-session $XDG_SESSION_ID", "systemctl suspend", "systemctl hibernate"]
    actionProc.command = ["sh", "-c", cmds[selectedIndex]]
    actionProc.startDetached()
    root.open = false
  }

  ColumnLayout {
    id: contentColumn
    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 8 }
    spacing: 2
    focus: root.open
    Keys.onPressed: (event) => {
      if (event.key === Qt.Key_Down) {
        selectedIndex = Math.min(selectedIndex + 1, 5)
        event.accepted = true
      } else if (event.key === Qt.Key_Up) {
        selectedIndex = Math.max(selectedIndex - 1, 0)
        event.accepted = true
      } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
        executeSelected()
        event.accepted = true
      }
    }

    Repeater {
      model: [
        { icon: "power",     label: "Power Off",  cmd: "poweroff",                    danger: true },
        { icon: "restart",   label: "Restart",    cmd: "reboot",                      danger: true },
        { icon: "lock",      label: "Lock",       cmd: "hyprlock" },
        { icon: "logout",    label: "Logout",     cmd: "loginctl kill-session $XDG_SESSION_ID" },
        { icon: "sleep",     label: "Suspend",    cmd: "systemctl suspend" },
        { icon: "hibernate", label: "Hibernate",  cmd: "systemctl hibernate" },
      ]

      delegate: Rectangle {
        required property var modelData
        required property int index
        Layout.fillWidth: true
        Layout.preferredHeight: 32
        radius: 6
        color: (ma.containsMouse || root.selectedIndex === index) ? Theme.surface0 : "transparent"

        RowLayout {
          anchors { left: parent.left; right: parent.right; leftMargin: 10; rightMargin: 10; verticalCenter: parent.verticalCenter }
          spacing: 10

          Icon {
            name: modelData.icon
            size: 16
            iconColor: (ma.containsMouse || root.selectedIndex === index)
              ? Theme.text
              : (modelData.danger ? Theme.red : Theme.subtext)
          }

          Text {
            Layout.fillWidth: true
            text: modelData.label
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: 16
            font.weight: Theme.weightNormal
          }
        }

        MouseArea {
          id: ma
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onContainsMouseChanged: {
            if (containsMouse) root.selectedIndex = index
          }
          onClicked: {
            actionProc.command = ["sh", "-c", modelData.cmd]
            actionProc.startDetached()
            root.open = false
          }
        }
      }
    }
  }
}
