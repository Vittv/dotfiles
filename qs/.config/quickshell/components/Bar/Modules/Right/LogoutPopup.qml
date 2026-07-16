import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../../../style"
import "../../../Bar/"

ClickMenu {
  id: root

  implicitWidth: 260
  implicitHeight: 232
  backgroundColor: Colors.base
  radius: 10

  Process { id: actionProc }

  ColumnLayout {
    anchors { fill: parent; margins: 6 }
    spacing: 2
    Repeater {
      model: [
        { label: "Lock",      cmd: "hyprlock" },
        { label: "Logout",    cmd: "loginctl kill-session $XDG_SESSION_ID" },
        { label: "Suspend",   cmd: "systemctl suspend" },
        { label: "Hibernate", cmd: "systemctl hibernate" },
        { label: "Shutdown",  cmd: "poweroff" },
        { label: "Restart",   cmd: "reboot" },
      ]
      delegate: Rectangle {
        required property var modelData
        Layout.fillWidth: true
        Layout.preferredHeight: 34
        radius: 10
        color: mouse.containsMouse ? Colors.base : "transparent"
        Text {
          anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
          text: modelData.label
          color: mouse.containsMouse ? Colors.palette.lavender : Colors.text
          font.family: "SF Pro Display"
          font.weight: 600
          font.pixelSize: 14
        }
        MouseArea {
          id: mouse
          anchors.fill: parent
          hoverEnabled: true
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
