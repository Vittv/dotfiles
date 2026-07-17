import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../../style"
import "../../core"

ClickMenu {
  id: root

  implicitWidth: 420
  backgroundColor: Colors.base
  radius: 12
  borderWidth: 1
  borderColor: Colors.palette.surface2

  property var sink: Pipewire.defaultAudioSink
  readonly property bool muted: sink && sink.audio && sink.audio.muted
  readonly property real volume: (sink && sink.audio) ? sink.audio.volume : 0

  property var source: Pipewire.defaultAudioSource
  readonly property bool sourceMuted: source && source.audio && source.audio.muted
  readonly property real sourceVolume: (source && source.audio) ? source.audio.volume : 0

  readonly property string sinkName: sink ? (sink.description || sink.name || "Output") : "Output"
  readonly property string sourceName: source ? (source.description || source.name || "Input") : "Input"

  function setVolume(v) {
    v = Math.max(0, Math.min(1, v))
    if (root.sink && root.sink.audio) root.sink.audio.volume = v
  }
  function toggleMute() {
    if (root.sink && root.sink.audio) root.sink.audio.muted = !root.sink.audio.muted
  }
  function setSourceVolume(v) {
    v = Math.max(0, Math.min(1, v))
    if (root.source && root.source.audio) root.source.audio.volume = v
  }
  function toggleSourceMute() {
    if (root.source && root.source.audio) root.source.audio.muted = !root.source.audio.muted
  }

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

  readonly property var _trackedNodes: {
    var list = root.streamNodes.slice()
    if (root.sink) list.push(root.sink)
    if (root.source) list.push(root.source)
    return list
  }
  PwObjectTracker { objects: root._trackedNodes }

  Process { id: pavuControlProc }

  implicitHeight: contentColumn.implicitHeight + 32

  ColumnLayout {
    id: contentColumn
    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 18 }
    spacing: 18

    // header row: DEVICES label + settings pill
    RowLayout {
      Layout.fillWidth: true

      SectionLabel { text: "DEVICES" }

      Item { Layout.fillWidth: true }

      Rectangle {
        id: settingsPill
        radius: 6
        color: "transparent"
        border.width: 1
        border.color: Colors.palette.surface2
        implicitWidth: settingsIcon.implicitWidth + 16
        implicitHeight: settingsIcon.implicitHeight + 8

        Icon {
          id: settingsIcon
          anchors.centerIn: parent
          name: "settings"
          size: 14
          iconColor: Colors.palette.overlay1
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            pavuControlProc.command = ["pavucontrol"]
            pavuControlProc.running = true
          }
        }
      }
    }

    // devices - flat, no nested card, divider between rows
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 12

      VolumeRow {
        Layout.fillWidth: true
        label: root.sinkName + " (Output)"
        iconName: root.muted ? "volume_off" : (root.volume < 0.01 ? "volume_mute" : root.volume < 0.5 ? "volume_down" : "volume_up")
        value: root.volume
        muted: root.muted
        percentTabular: true
        onDragged: (v) => root.setVolume(v)
        onIconClicked: root.toggleMute()
      }

      Divider {}

      VolumeRow {
        Layout.fillWidth: true
        label: root.sourceName + " (Input)"
        iconName: root.sourceMuted ? "mic_off" : "mic"
        value: root.sourceVolume
        muted: root.sourceMuted
        percentTabular: true
        onDragged: (v) => root.setSourceVolume(v)
        onIconClicked: root.toggleSourceMute()
      }
    }

    // divider between DEVICES section and SOURCES section
    Divider { visible: root.streamNodes.length > 0 }

    // sources
    ColumnLayout {
      Layout.fillWidth: true
      visible: root.streamNodes.length > 0
      spacing: 12

      SectionLabel { text: "SOURCES" }

      Repeater {
        model: root.streamNodes
        delegate: ColumnLayout {
          required property int index
          required property var modelData
          Layout.fillWidth: true
          spacing: 12

          VolumeRow {
            Layout.fillWidth: true
            label: root.appLabel(modelData)
            iconName: modelData.audio.muted ? "volume_off" : "volume_up"
            value: modelData.audio.volume
            muted: modelData.audio.muted
            percentTabular: true
            onDragged: (v) => { modelData.audio.volume = Math.max(0, Math.min(1, v)) }
            onIconClicked: modelData.audio.muted = !modelData.audio.muted
          }

          Divider { visible: index < root.streamNodes.length - 1 }
        }
      }
    }
  }
}
