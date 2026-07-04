import QtQuick
import "../../../../utils" 
import "../../../../style/"

ScriptModule {
  id: devServerModule

  execCommand: "$HOME/.config/quickshell/src/devserver.sh"
  intervalMs: 3000

  // dynamically grabs the lowest running port from the active list and launches it in your browser
  onClickCommand: "bash -c 'port=$(ss -tlnp 2>/dev/null | grep -oP \":(5173|4173|8080|3000|8081) \" | head -1 | tr -d \": \"); [ -n \"$port\" ] && xdg-open \"http://localhost:$port\"'"

  visible: text !== ""
  textColor: Colors.palette.blue
  fontSize: 12
  fontWeight: Font.Bold
}
