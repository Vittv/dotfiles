import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../../../style"
import "../../../Bar/"

ClickMenu {
  id: root

  implicitWidth: 240
  implicitHeight: contentColumn.implicitHeight + 28
  backgroundColor: Colors.base
  radius: 10
  borderWidth: 1
  borderColor: Colors.palette.surface2

  property string homeDir: ""
  property string uptimeText: ""
  property string ageText: ""

  Process {
    id: userProc
    command: ["bash", "-c", "echo $HOME"]
    running: true
    stdout: SplitParser {
      onRead: (line) => { root.homeDir = line.trim() }
    }
  }

  Process {
    id: uptimeProc
    command: ["sh", "-c", "awk '{h=int($1/3600); m=int(($1%3600)/60); printf \"%dh %dm\", h, m}' /proc/uptime"]
    running: true
    stdout: SplitParser {
      onRead: (line) => { root.uptimeText = line.trim() }
    }
  }

  Process {
    id: ageProc
    command: ["sh", "-c", "b=$(stat -c %W ~ 2>/dev/null); now=$(date +%s); echo $(( (now - b) / 86400 ))d"]
    running: true
    stdout: SplitParser {
      onRead: (line) => { root.ageText = line.trim() }
    }
  }

  readonly property string userName: homeDir ? homeDir.split("/").pop() : ""
  readonly property string facePath: homeDir ? "file://" + homeDir + "/.face" : ""

  Process { id: actionProc }

  ColumnLayout {
    id: contentColumn
    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 14 }
    spacing: 14

    // user info
    RowLayout {
      Layout.fillWidth: true
      spacing: 12

      Item {
        Layout.preferredWidth: 44
        Layout.preferredHeight: 44

        // initial fallback
        Rectangle {
          anchors.fill: parent
          radius: width / 2
          color: Colors.palette.mauve

          Text {
            anchors.centerIn: parent
            text: root.userName ? root.userName.charAt(0).toUpperCase() : "?"
            color: Colors.base
            font.family: Fonts.display
            font.pixelSize: 18
            font.weight: 700
          }
        }

        // face image on top
        Rectangle {
          anchors.fill: parent
          radius: 10
          visible: avatarImage.status === Image.Ready
          layer.enabled: true
          clip: true

          Image {
            id: avatarImage
            source: root.facePath
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
          }
        }
      }

      ColumnLayout {
        spacing: 1

        Text {
          text: root.userName || "User"
          color: Colors.text
          font.family: Fonts.display
          font.pixelSize: 15
          font.weight: 700
        }

        Text {
          text: root.userName ? ("@" + root.userName) : ""
          color: Colors.subtext
          font.family: Fonts.display
          font.pixelSize: 12
        }
      }

      Item { Layout.fillWidth: true }

      ColumnLayout {
        spacing: 1
        Layout.alignment: Qt.AlignRight

        Text {
          text: root.uptimeText
          color: Colors.subtext
          font.family: Fonts.display
          font.pixelSize: 11
          Layout.alignment: Qt.AlignRight
        }

        Text {
          text: root.ageText ? (root.ageText) : ""
          color: Colors.subtext
          font.family: Fonts.display
          font.pixelSize: 11
          Layout.alignment: Qt.AlignRight
        }
      }
    }

    Rectangle { Layout.fillWidth: true; height: 1; color: Colors.palette.surface2 }

    // actions grid
    GridLayout {
      Layout.fillWidth: true
      columns: 3
      columnSpacing: 8
      rowSpacing: 8

      Repeater {
        model: [
          { icon: "lock",      cmd: "hyprlock" },
          { icon: "logout",    cmd: "loginctl kill-session $XDG_SESSION_ID" },
          { icon: "sleep",     cmd: "systemctl suspend" },
          { icon: "hibernate",   cmd: "systemctl hibernate" },
          { icon: "restart",   cmd: "reboot",    danger: true },
          { icon: "power",     cmd: "poweroff",  danger: true },
        ]
        delegate: Rectangle {
          required property var modelData
          Layout.fillWidth: true
          Layout.preferredHeight: 40
          radius: 8
          color: actionMouse.containsMouse
            ? (modelData.danger ? Colors.palette.red : Colors.overlay0)
            : "transparent"
          border.width: 1
          border.color: actionMouse.containsMouse
            ? (modelData.danger ? Colors.palette.red : Colors.overlay0)
            : Colors.palette.surface2

          Icon {
            anchors.centerIn: parent
            name: modelData.icon
            size: 18
            iconColor: modelData.danger
              ? (actionMouse.containsMouse ? Colors.base : Colors.palette.red)
              : (actionMouse.containsMouse ? Colors.palette.lavender : Colors.text)
          }

          MouseArea {
            id: actionMouse
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
}
