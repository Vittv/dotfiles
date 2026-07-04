import QtQuick
import QtQuick.Layouts
import "../../style"

// One row: icon (click = mute), slider (drag = set volume), percentage.
// Used for both the master output and each per-application stream.
RowLayout {
  id: root
  spacing: 10

  property string label: ""
  property string iconName: "volume_up"
  property real value: 0        // 0.0 - 1.0
  property bool muted: false

  signal dragged(real value)
  signal iconClicked()

  Icon {
    name: root.iconName
    size: 16
    iconColor: Colors.text
    Layout.alignment: Qt.AlignVCenter

    MouseArea {
      anchors.fill: parent
      anchors.margins: -6
      onClicked: root.iconClicked()
    }
  }

  ColumnLayout {
    Layout.fillWidth: true
    spacing: 2

    Text {
      visible: root.label.length > 0
      text: root.label
      color: Colors.text
      font.family: Fonts.display
      font.pixelSize: 13
      font.weight: 600
      elide: Text.ElideRight
      Layout.fillWidth: true
    }

    Item {
      id: sliderTrack
      Layout.fillWidth: true
      Layout.preferredHeight: 16

      Rectangle {
        id: trackBg
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 6
        radius: height / 2
        color: Colors.palette.surface0
      }

      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: trackBg.width * root.value
        height: 6
        radius: height / 2
        color: Colors.text
      }

      Rectangle {
        width: 12
        height: 12
        radius: 6
        color: root.muted ? Colors.red : Colors.text
        anchors.verticalCenter: parent.verticalCenter
        x: Math.max(0, Math.min(sliderTrack.width - width, sliderTrack.width * root.value - width / 2))
      }

      MouseArea {
        anchors.fill: parent
        onPressed: (mouse) => root.dragged(mouse.x / sliderTrack.width)
        onPositionChanged: (mouse) => { if (pressed) root.dragged(mouse.x / sliderTrack.width) }
      }
    }
  }

  Text {
    text: root.muted ? "muted" : Math.round(root.value * 100) + "%"
    color: Colors.text
    font.family: Fonts.display
    font.pixelSize: 13
    font.weight: 600
    Layout.preferredWidth: 38
    horizontalAlignment: Text.AlignRight
  }
}
