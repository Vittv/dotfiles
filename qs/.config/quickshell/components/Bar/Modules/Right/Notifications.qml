import QtQuick
import "../../../../style"

Item {
  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  Icon {
    id: icon
    name: "inbox"
    size: 14
    iconColor: Colors.text
  }
}
