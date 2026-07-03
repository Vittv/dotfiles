import QtQuick
import "../../../../style"

Item {
  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  Icon {
    id: icon
    name: "inbox"
    size: 15
    iconColor: Colors.text
  }
}
