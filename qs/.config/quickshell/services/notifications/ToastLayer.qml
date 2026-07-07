import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../style"
import "../../services/"

PanelWindow {
  id: toastWindow

  property int barHeight: 26
  property int edgeMargin: 8

  anchors {
    top: true
    right: true
  }
  margins {
    top: barHeight + edgeMargin
    right: edgeMargin
  }

  exclusiveZone: 0
  color: "transparent"
  implicitWidth: 340
  implicitHeight: column.implicitHeight

  WlrLayershell.layer: WlrLayer.Overlay

  Column {
    id: column
    width: parent.width
    spacing: 8

    Repeater {
      model: Notifications.activeToasts

      delegate: Toast {
        width: column.width
        notifId: modelData.id
        appName: modelData.appName
        summary: modelData.summary
        body: modelData.body
        image: modelData.image
        expireMs: modelData.expireTimeout > 0 ? modelData.expireTimeout : 5000

        onDismissed: (id) => Notifications.dismissToast(id)
      }
    }
  }
}
