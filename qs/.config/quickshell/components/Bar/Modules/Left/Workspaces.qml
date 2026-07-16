import QtQuick
import Quickshell.Hyprland
import "../../../../style/"

Item {
  id: root
  property var targetScreen
  implicitHeight: 20
  implicitWidth: row.width + 12

  readonly property int wsCount: {
    var max = 0
    var list = Hyprland.workspaces.values
    for (var i = 0; i < list.length; i++)
      if (list[i].id > max) max = list[i].id
    return Math.max(max, 1)
  }

  Rectangle {
    anchors.fill: parent
    radius: 4
    color: Colors.overlay0
    border.width: 1
    border.color: Colors.palette.surface2
  }

  Row {
    id: row
    anchors.centerIn: parent
    spacing: 4

    Repeater {
      model: root.wsCount

      Rectangle {
        property int wsId: index + 1
        property var ws: Hyprland.workspaces.values.find(w => w.id === wsId)
        property bool isActive: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === wsId : false

        implicitWidth: 20
        implicitHeight: 16
        radius: 3
        color: isActive ? Qt.rgba(Colors.palette.blue.r, Colors.palette.blue.g, Colors.palette.blue.b, 0.2) : "transparent"

        Text {
          anchors.centerIn: parent
          text: wsId
          color: isActive ? Colors.palette.blue : (ws ? Colors.palette.text : Colors.palette.overlay1)
          font { family: "FiraCode Nerd Font"; pixelSize: 11; bold: true }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (Hyprland.usingLua)
              Hyprland.dispatch("hl.dsp.focus({ workspace = " + wsId + " })")
            else
              Hyprland.dispatch("workspace " + wsId)
          }
        }
      }
    }
  }
}
