import QtQuick
import "../../utils"
import "../../style"
import "../../core"

ModulePill {
  id: root
  width: tmuxModule.implicitWidth + 8
  visible: tmuxModule.active

  ScriptModule {
    id: tmuxModule
    anchors.centerIn: parent
    readonly property bool active: text !== ""
    visible: active

    execCommand: "$HOME/.config/quickshell/src/tmux.sh"
    intervalMs: 15000
    onClickCommand: "kitty fish -c t"

    textColor: Theme.text
    fontSize: Theme.fontSizeNormal
    fontWeight: Font.Medium
    fontFamily: Theme.fontFamily
  }
}
