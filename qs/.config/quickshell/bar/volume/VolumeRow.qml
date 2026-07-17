import QtQuick
import QtQuick.Layouts
import "../../style"
import "../../core"

ColumnLayout {
  id: root
  spacing: 4

  property string label: ""
  property string iconName: "volume_up"
  property real value: 0
  property bool muted: false
  property bool percentTabular: false

  signal dragged(real value)
  signal iconClicked()

  Text {
    visible: root.label.length > 0
    text: root.label
    color: Theme.text
    font.family: Theme.fontFamily
    font.pixelSize: 15
    font.weight: 600
    elide: Text.ElideRight
    Layout.fillWidth: true
    Layout.bottomMargin: 8
  }

  RowLayout {
    spacing: 10
    Layout.fillWidth: true

    Rectangle {
      width: 28
      height: 20
      radius: 4
      color: iconMouse.containsMouse ? Theme.surface : Theme.overlay
      border.width: 1
      border.color: Theme.surfaceBorder

      Icon {
        anchors.centerIn: parent
        name: root.iconName
        size: 14
        iconColor: root.muted ? Theme.danger : Theme.text
      }

      MouseArea {
        id: iconMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.iconClicked()
      }
    }

    Item {
      id: sliderTrack
      Layout.fillWidth: true
      Layout.preferredHeight: 16

      Rectangle {
        id: trackBg
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 2
        radius: height / 2
        color: Theme.surface
      }

      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: trackBg.width * root.value
        height: 2
        radius: height / 2
        color: root.muted ? Theme.danger : Theme.accent
      }

      Rectangle {
        width: 12
        height: 12
        radius: 6
        color: root.muted ? Theme.danger : Theme.accent
        anchors.verticalCenter: parent.verticalCenter
        x: Math.max(0, Math.min(sliderTrack.width - width, sliderTrack.width * root.value - width / 2))

        Rectangle {
          width: 4
          height: 4
          radius: 2
          color: Colors.palette.crust
          anchors.centerIn: parent
        }
      }

      MouseArea {
        anchors.fill: parent
        onPressed: (mouse) => root.dragged(mouse.x / sliderTrack.width)
        onPositionChanged: (mouse) => { if (pressed) root.dragged(mouse.x / sliderTrack.width) }
      }
    }

    Text {
      text: root.muted ? "muted" : Math.round(root.value * 100) + "%"
      color: Theme.text
      font.family: Theme.fontFamily
      font.pixelSize: Theme.fontSizeNormal
      font.weight: 600
      font.features: root.percentTabular ? { "tnum": 1 } : {}
      Layout.preferredWidth: 38
      horizontalAlignment: Text.AlignRight
    }
  }
}
