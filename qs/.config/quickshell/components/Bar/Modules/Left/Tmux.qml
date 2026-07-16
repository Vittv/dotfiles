import QtQuick
import "../../../../utils"
import "../../../../style/"

Rectangle {
  id: root
  width: tmuxModule.implicitWidth + 8
  implicitHeight: 20
  radius: 4
  color: Colors.palette.overlay0
  border.width: 1
  border.color: Colors.palette.surface2
  visible: tmuxModule.active

  ScriptModule {
    id: tmuxModule
    anchors.centerIn: parent
    readonly property bool active: text !== ""
    visible: active

    execCommand: "$HOME/.config/quickshell/src/tmux.sh"
    intervalMs: 15000
    onClickCommand: "kitty fish -c t"

    textColor: Colors.text
    fontSize: 13
    fontWeight: Font.Medium
    fontFamily: "SF Pro Display"
  }
}
