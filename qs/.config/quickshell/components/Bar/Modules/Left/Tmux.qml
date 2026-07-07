import QtQuick
import "../../../../utils" 
import "../../../../style/"

ScriptModule {
  id: tmuxModule
  readonly property bool active: text !== ""
  visible: active

  execCommand: "$HOME/.config/quickshell/src/tmux.sh"
  intervalMs: 15000

  // opens kitty terminal running the fish shell 't' alias/function
  onClickCommand: "kitty fish -c t"

  // only allocate layout space if there are active sessions
  textColor: Colors.palette.base
  fontSize: 14
  fontWeight: Font.Bold
  fontFamily: "SF Pro Display"
}
