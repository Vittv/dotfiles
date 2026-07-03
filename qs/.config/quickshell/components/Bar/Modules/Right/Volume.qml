import QtQuick
import Quickshell.Services.Pipewire
import "../../../../style/"

Row {
  id: root
  spacing: 4

  // keeps the default sink bound so its audio properties update live
  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  property var sink: Pipewire.defaultAudioSink
  readonly property bool muted: sink && sink.audio && sink.audio.muted
  readonly property int volumePct: (sink && sink.audio) ? Math.round(sink.audio.volume * 100) : 0

  Icon {
    anchors.verticalCenter: parent.verticalCenter
    size: 16
    iconColor: root.muted ? Colors.red : Colors.text
    name: {
      if (root.muted) return "volume_off";
      if (root.volumePct < 1) return "volume_mute";
      if (root.volumePct < 50) return "volume_down";
      return "volume_up";
    }
  }

  MouseArea {
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (root.sink && root.sink.audio)
      root.sink.audio.muted = !root.sink.audio.muted;
    }
  }
}
