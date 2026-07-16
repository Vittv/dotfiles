import QtQuick
import QtQuick.Layouts
import "../../../../utils"
import "../../../../style"

Rectangle {
  id: root
  width: devServerText.implicitWidth + 8
  implicitHeight: 20
  radius: 4
  color: Colors.surface
  border.width: 1
  border.color: Colors.palette.surface2
  visible: devServerText.active

  ScriptModule {
    id: devServerText
    anchors.centerIn: parent
    readonly property bool active: text !== ""

    execCommand: "$HOME/.config/quickshell/src/devserver.sh"
    intervalMs: 15000
    onClickCommand: "bash -c 'port=$(ss -tlnp 2>/dev/null | grep -oP \":(5173|4173|8080|3000|8081) \" | head -1 | tr -d \": \"); [ -n \"$port\" ] && xdg-open \"http://localhost:$port\"'"
    visible: text !== ""

    textColor: Colors.palette.blue
    fontSize: 13
    fontFamily: "SF Pro Display"
    fontWeight: Font.Bold
  }
}
