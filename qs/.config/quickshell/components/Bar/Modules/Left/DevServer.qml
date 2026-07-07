import QtQuick
import QtQuick.Layouts
import "../../../../utils"
import "../../../../style"

Row {
  id: root
  readonly property bool active: devServerText.text !== ""
  visible: active
  spacing: 4
  anchors.verticalCenter: parent.verticalCenter

  Rectangle {
    width: 6; height: 6; radius: 3
    color: Colors.base
    anchors.verticalCenter: parent.verticalCenter
    visible: devServerText.text !== ""

    SequentialAnimation on opacity {
      running: visible
      loops: Animation.Infinite
      PropertyAnimation { to: 0.3; duration: 600; easing.type: Easing.InOutSine }
      PropertyAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutSine }
    }
  }

  ScriptModule {
    id: devServerText
    execCommand: "$HOME/.config/quickshell/src/devserver.sh"
    intervalMs: 15000
    onClickCommand: "bash -c 'port=$(ss -tlnp 2>/dev/null | grep -oP \":(5173|4173|8080|3000|8081) \" | head -1 | tr -d \": \"); [ -n \"$port\" ] && xdg-open \"http://localhost:$port\"'"
    visible: text !== ""
    textColor: Colors.base
    fontSize: 12
    fontWeight: Font.Bold
  }
}
