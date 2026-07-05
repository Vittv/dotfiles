import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../../../style"
import "../../../Bar"

HoverMenu {
  id: root
  triggerItem: netModule

  implicitWidth: 280
  implicitHeight: 180
  backgroundColor: Colors.base
  radius: 12

  ColumnLayout {
    anchors { fill: parent; margins: 8 }
    spacing: 6

    Text {
      text: "Network"
      color: Colors.text
      font.family: Fonts.display
      font.pixelSize: 15
      font.weight: 700
    }

    Process {
      id: netInfo
      command: ["bash", "-c",
        'ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep \'^yes\' | cut -d: -f2);' +
        'ip=$(nmcli -t -f IP4.ADDRESS dev show | head -1 | cut -d: -f2);' +
        'type=$(nmcli -t -f TYPE,STATE dev status | grep \':connected$\' | cut -d: -f1 | head -1);' +
        'echo "$type|$ssid|$ip"'
      ]
      stdout: SplitParser {
        splitMarker: "\n"
        onRead: (line) => infoText.text = line
      }
      running: true
    }

    Text {
      id: infoText
      color: Colors.subtext
      font.family: Fonts.display
      font.pixelSize: 12
      Layout.fillWidth: true
      wrapMode: Text.Wrap
    }

    Item { Layout.fillHeight: true }

    Process { id: nmProc }
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 32
      radius: 8
      color: Colors.surface

      Text {
        anchors.centerIn: parent
        text: "Network Settings"
        color: Colors.text
        font.family: Fonts.display
        font.pixelSize: 13
        font.weight: 600
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          nmProc.command = ["bash", "-c", "nm-connection-editor"]
          nmProc.running = true
          root.open = false
        }
      }
    }
  }
}
