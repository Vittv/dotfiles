import QtQuick
import "../../../../style"

Item {
  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  Icon {
    id: icon
    name: "logout"
    size: 15
    iconColor: Colors.text
  }
}
