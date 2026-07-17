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

  Process { id: actionProc }

  ColumnLayout {
    id: contentColumn
    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 8 }
    spacing: 2

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
        Layout.fillWidth: true
        Layout.preferredHeight: 32
        radius: 6
        color: ma.containsMouse ? Theme.surface0 : "transparent"

        RowLayout {
          anchors { left: parent.left; right: parent.right; leftMargin: 10; rightMargin: 10; verticalCenter: parent.verticalCenter }
          spacing: 10

          Icon {
            name: modelData.icon
            size: 14
            iconColor: ma.containsMouse
              ? Theme.text
              : (modelData.danger ? Theme.red : Theme.subtext)
          }

          Text {
            Layout.fillWidth: true
            text: modelData.label
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            font.weight: Theme.weightNormal
          }
        }

        MouseArea {
          id: ma
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
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
