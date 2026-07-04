import QtQuick
import "../../../../utils" 
import "../../../../style/"

ScriptModule {
  id: tmuxModule

  execCommand: "$HOME/.config/quickshell/src/tmux.sh"
  intervalMs: 2000

  // opens kitty terminal running the fish shell 't' alias/function
  onClickCommand: "kitty fish -c t"

  // only allocate layout space if there are active sessions
  visible: text !== ""
  textColor: Colors.palette.rosewater
  fontSize: 14
  fontWeight: Font.Bold
  fontFamily: "SF Pro Display"
}
