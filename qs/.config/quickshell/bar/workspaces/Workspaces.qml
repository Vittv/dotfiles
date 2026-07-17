import QtQuick
import Quickshell.Hyprland
import "../../style"
import "../../core"

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

  ModulePill {
    anchors.fill: parent
  }

  Row {
    id: row
    anchors.centerIn: parent
    spacing: Theme.spacingSmall

    Repeater {
      model: root.wsCount

      Rectangle {
        property int wsId: index + 1
        property var ws: Hyprland.workspaces.values.find(w => w.id === wsId)
        property bool isActive: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === wsId : false

        implicitWidth: 20
        implicitHeight: 16
        radius: 3
        color: isActive ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.2) : "transparent"

        Text {
          anchors.centerIn: parent
          text: wsId
          color: isActive ? Theme.accent : (ws ? Colors.palette.text : Colors.palette.overlay1)
          font { family: Theme.monoFamily; pixelSize: Theme.fontSizeTiny; bold: true }
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
