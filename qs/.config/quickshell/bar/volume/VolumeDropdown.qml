import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../../style"
import "../../core"

ClickMenu {
  id: root

  implicitWidth: 340
  backgroundColor: Theme.base
  radius: 6
  borderWidth: 1
  borderColor: Theme.surface2
  gap: 0

  property var sink: Pipewire.defaultAudioSink
  readonly property bool muted: sink && sink.audio && sink.audio.muted
  readonly property real volume: (sink && sink.audio) ? sink.audio.volume : 0

  property var source: Pipewire.defaultAudioSource
  readonly property bool sourceMuted: source && source.audio && source.audio.muted
  readonly property real sourceVolume: (source && source.audio) ? source.audio.volume : 0

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

  readonly property var outputDevices: {
    var out = []
    var list = Pipewire.nodes.values
    for (var i = 0; i < list.length; i++) {
      var n = list[i]
      if (n && n.type === PwNodeType.AudioSink && n.audio)
        out.push(n)
    }
    return out
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

  function setDefaultOutput(nodeName) {
    var list = Pipewire.nodes.values
    for (var i = 0; i < list.length; i++) {
      var n = list[i]
      if (n && n.name === nodeName && n.audio) {
        n.audio.setDefault()
        break
      }
    }
  }

  readonly property var _trackedNodes: {
    var list = root.streamNodes.slice()
    if (root.sink) list.push(root.sink)
    if (root.source) list.push(root.source)
    return list
  }
  PwObjectTracker { objects: root._trackedNodes }

  implicitHeight: contentColumn.implicitHeight + 32

  ColumnLayout {
    id: contentColumn
    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 16 }
    spacing: 12

    // header
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      Text {
        Layout.fillWidth: true
        text: "Volume"
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Theme.weightBold
        elide: Text.ElideRight
      }

      Rectangle {
        width: settingsIcon.width + 14
        height: 24
        radius: 4
        color: settingsMouse.containsMouse ? Theme.surfaceBorder : Theme.surface0
        border.width: 1
        border.color: Theme.surfaceBorder

        Icon {
          id: settingsIcon
          anchors.centerIn: parent
          name: "settings"
          size: 14
        }

        MouseArea {
          id: settingsMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            settingsProc.running = true
            root.open = false
          }
        }
      }
    }

    Process {
      id: settingsProc
      command: ["pavucontrol"]
    }

    // ── SLIDERS ──
    VolumeRow {
      Layout.fillWidth: true
      iconName: root.muted ? "volume_off" : "volume_up"
      value: root.volume
      muted: root.muted
      percentTabular: true
      onDragged: (v) => root.setVolume(v)
      onToggled: root.toggleMute()
    }

    VolumeRow {
      Layout.fillWidth: true
      iconName: root.sourceMuted ? "mic_off" : "mic"
      value: root.sourceVolume
      muted: root.sourceMuted
      percentTabular: true
      onDragged: (v) => root.setSourceVolume(v)
      onToggled: root.toggleSourceMute()
    }

    // ── DEVICES ──
    ColumnLayout {
      Layout.fillWidth: true
      spacing: 4
      visible: root.outputDevices.length > 0

      Repeater {
        model: root.outputDevices
        delegate: Rectangle {
          required property var modelData
          readonly property bool isDefault: root.sink && modelData.name === root.sink.name

          Layout.fillWidth: true
          Layout.preferredHeight: 34
          radius: 6
          color: deviceMouse.containsMouse && !isDefault ? Theme.surfaceBorder : Theme.surface0
          border.color: isDefault ? Theme.accent : Theme.surfaceBorder
          border.width: 1

          RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 10

            Text {
              Layout.fillWidth: true
              text: modelData.description || modelData.name || "Unknown"
              color: Theme.text
              font.family: Theme.fontFamily
              font.pixelSize: Theme.fontSizeLarge
              font.bold: isDefault
              elide: Text.ElideRight
              verticalAlignment: Text.AlignVCenter
            }

            Text {
              Layout.preferredWidth: 58
              text: isDefault ? "Default" : "Set"
              color: isDefault ? Theme.accent : Theme.subtext
              font.family: Theme.fontFamily
              font.pixelSize: Theme.fontSizeNormal
              font.bold: true
              horizontalAlignment: Text.AlignRight
              verticalAlignment: Text.AlignVCenter
              elide: Text.ElideRight
            }
          }

          MouseArea {
            id: deviceMouse
            anchors.fill: parent
            enabled: !isDefault
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.setDefaultOutput(modelData.name)
          }
        }
      }
    }

    // ── APPLICATIONS ──
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: root.streamNodes.length > 0 ? 148 : 40
      radius: 6
      color: Theme.surface0
      border.width: 1
      border.color: Theme.surfaceBorder

      Text {
        anchors.centerIn: parent
        visible: root.streamNodes.length === 0
        text: "No applications playing audio"
        color: Theme.subtextDark
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeNormal
      }

      Flickable {
        id: appsFlickable
        anchors.fill: parent
        anchors.margins: 12
        contentWidth: appsRow.implicitWidth
        contentHeight: 124
        clip: true
        flickableDirection: Flickable.HorizontalFlick
        visible: root.streamNodes.length > 0

        Row {
          id: appsRow
          spacing: 8

          Repeater {
            model: root.streamNodes
            delegate: Rectangle {
              required property var modelData
              width: 56
              height: 124
              radius: 4
              color: Theme.surface0
              border.width: 1
              border.color: Theme.surfaceBorder

              ColumnLayout {
                anchors.centerIn: parent
                spacing: 4

                Text {
                  Layout.preferredWidth: 56
                  Layout.alignment: Qt.AlignHCenter
                  text: root.appLabel(modelData)
                  color: modelData.audio.muted ? Theme.subtext : Theme.text
                  font.family: Theme.fontFamily
                  font.pixelSize: Theme.fontSizeNormal
                  horizontalAlignment: Text.AlignHCenter
                  elide: Text.ElideRight
                }

                Item {
                  Layout.preferredWidth: 56
                  Layout.preferredHeight: 56
                  Layout.alignment: Qt.AlignHCenter

                  Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 3
                    height: parent.height
                    radius: 1.5
                    color: Theme.base

                    Rectangle {
                      width: parent.width
                      height: Math.round(modelData.audio.volume * parent.height)
                      anchors.bottom: parent.bottom
                      color: modelData.audio.muted ? Theme.surfaceBorder : Theme.accent
                      radius: parent.radius
                    }
                  }

                  Rectangle {
                    width: 10
                    height: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: Math.max(0, Math.min(parent.height - height, (1 - modelData.audio.volume) * parent.height - height / 2))
                    color: modelData.audio.muted ? Theme.surfaceBorder : Theme.accent
                    radius: height / 2

                    Rectangle {
                      width: 6
                      height: 6
                      anchors.centerIn: parent
                      color: Theme.base
                      radius: 4
                    }
                  }

                  MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onPressed: (mouse) => {
                      modelData.audio.volume = Math.max(0, Math.min(1, 1 - mouse.y / parent.height))
                    }
                    onPositionChanged: (mouse) => {
                      if (pressed) {
                        modelData.audio.volume = Math.max(0, Math.min(1, 1 - mouse.y / parent.height))
                      }
                    }
                    onWheel: (wheel) => {
                      var delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                      modelData.audio.volume = Math.max(0, Math.min(1, modelData.audio.volume + delta))
                    }
                  }
                }

                Rectangle {
                  Layout.preferredWidth: 24
                  Layout.preferredHeight: 16
                  Layout.alignment: Qt.AlignHCenter
                  radius: 3
                  color: muteMouse.containsMouse ? Theme.surface1 : Theme.surface0
                  border.width: 1
                  border.color: Theme.surfaceBorder

                  Icon {
                    anchors.centerIn: parent
                    name: modelData.audio.muted ? "volume_off" : "volume_up"
                    size: 11
                    iconColor: modelData.audio.muted ? Theme.red : Theme.text
                  }

                  MouseArea {
                    id: muteMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.audio.muted = !modelData.audio.muted
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
