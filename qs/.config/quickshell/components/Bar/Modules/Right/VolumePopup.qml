import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../../../../style"
import "../../../Bar"

HoverMenu {
  id: root

  implicitWidth: 340
  implicitHeight: outputColumn.implicitHeight + 28
  backgroundColor: Colors.base
  radius: 12

  // master output
  property var sink: Pipewire.defaultAudioSink
  readonly property bool muted: sink && sink.audio && sink.audio.muted
  readonly property real volume: (sink && sink.audio) ? sink.audio.volume : 0

  function setVolume(v) {
    v = Math.max(0, Math.min(1, v))
    if (root.sink && root.sink.audio) root.sink.audio.volume = v
  }
  function toggleMute() {
    if (root.sink && root.sink.audio) root.sink.audio.muted = !root.sink.audio.muted
  }

  // --- per-application streams ---
  // AudioOutStream = pipewire media.class "Stream/Output/Audio", i.e. an
  // app playing sound (Spotify, Discord, a browser tab, a game, etc.)
  // rather than a hardware sink/source.
  readonly property var streamNodes: {
    var out = []
    var list = Pipewire.nodes.values
    for (var i = 0; i < list.length; i++) {
      var n = list[i]
      if (n && n.isStream && n.audio && n.type === PwNodeType.AudioOutStream)
        out.push(n)
    }
    return out
  }

  function appLabel(node) {
    var p = node.properties || {}
    return p["application.name"] || p["media.name"] || node.description || node.name
  }

  // keep the sink + every visible stream bound so .audio.* stays live
  readonly property var _trackedNodes: {
    var list = root.streamNodes.slice()
    if (root.sink) list.push(root.sink)
    return list
  }
  PwObjectTracker { objects: root._trackedNodes }

  ColumnLayout {
    id: outputColumn
    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 14 }
    spacing: 10

    VolumeRow {
      Layout.fillWidth: true
      label: "Output"
      iconName: root.muted ? "volume_off" : (root.volume < 0.01 ? "volume_mute" : root.volume < 0.5 ? "volume_down" : "volume_up")
      value: root.volume
      muted: root.muted
      onDragged: (v) => root.setVolume(v)
      onIconClicked: root.toggleMute()
    }

    Repeater {
      model: root.streamNodes
      delegate: VolumeRow {
        required property var modelData
        Layout.fillWidth: true
        label: root.appLabel(modelData)
        iconName: modelData.audio.muted ? "volume_off" : "volume_up"
        value: modelData.audio.volume
        muted: modelData.audio.muted
        onDragged: (v) => { modelData.audio.volume = Math.max(0, Math.min(1, v)) }
        onIconClicked: modelData.audio.muted = !modelData.audio.muted
      }
    }
  }
}
