import QtQuick
import QtQuick.Layouts
import "../../utils"
import "../../style"
import "../../core"

ModulePill {
  id: root
  width: devServerText.implicitWidth + 8
  visible: devServerText.active

  ScriptModule {
    id: devServerText
    anchors.centerIn: parent
    readonly property bool active: text !== ""

    execCommand: "$HOME/.config/quickshell/src/devserver.sh"
    intervalMs: 15000
    onClickCommand: "bash -c 'port=$(ss -tlnp 2>/dev/null | grep -oP \":(5173|4173|8080|3000|8081) \" | head -1 | tr -d \": \"); [ -n \"$port\" ] && xdg-open \"http://localhost:$port\"'"
    visible: text !== ""

    textColor: Theme.accent
    fontSize: Theme.fontSizeNormal
    fontFamily: Theme.fontFamily
    fontWeight: Font.Medium
  }
}
