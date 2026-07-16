import QtQuick
import Quickshell.Services.Pipewire
import "../../../../style/"

Rectangle {
  id: root
  width: volModule.implicitWidth + 8
  implicitHeight: 20
  radius: 4
  color: Colors.surface
  border.width: 1
  border.color: Colors.palette.surface2

  signal clicked()
  property bool popupActive: volModule.popupActive

  Item {
    id: volModule
    anchors.centerIn: parent
    property bool popupActive: root.popupActive
    implicitWidth: contentRow.implicitWidth
    implicitHeight: contentRow.implicitHeight

    PwObjectTracker {
      objects: [Pipewire.defaultAudioSink]
    }
    property var sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink && sink.audio && sink.audio.muted
    readonly property int volumePct: (sink && sink.audio) ? Math.round(sink.audio.volume * 100) : 0

    Row {
      id: contentRow
      anchors.verticalCenter: parent.verticalCenter
      spacing: 6

      Icon {
        anchors.verticalCenter: parent.verticalCenter
        size: 14
        iconColor: volModule.popupActive ? Colors.accent : (volModule.muted ? Colors.red : Colors.palette.blue)
        name: {
          if (volModule.muted) return "volume_off";
          if (volModule.volumePct < 1) return "volume_mute";
          if (volModule.volumePct < 50) return "volume_down";
          return "volume_up";
        }
      }

      Item {
        anchors.verticalCenter: parent.verticalCenter
        width: 30
        height: 2

        Rectangle {
          anchors.fill: parent
          radius: height / 2
          color: Colors.overlay0
        }

        Rectangle {
          width: parent.width * (volModule.volumePct / 100)
          height: parent.height
          radius: height / 2
          color: volModule.muted ? Colors.red : Colors.palette.blue
        }
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: root.clicked()
      onWheel: (wheel) => {
        if (!volModule.sink || !volModule.sink.audio) return
        var delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
        volModule.sink.audio.volume = Math.max(0, Math.min(1, volModule.sink.audio.volume + delta))
      }
    }
  }
}
