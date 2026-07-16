import QtQuick
import QtQuick.Layouts
import "../../style"

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
    color: Colors.text
    font.family: Fonts.display
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
      color: iconMouse.containsMouse ? Colors.palette.surface0 : Colors.palette.overlay0
      border.width: 1
      border.color: Colors.palette.surface2

      Icon {
        anchors.centerIn: parent
        name: root.iconName
        size: 14
        iconColor: root.muted ? Colors.red : Colors.text
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
        color: Colors.palette.surface0
      }

      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: trackBg.width * root.value
        height: 2
        radius: height / 2
        color: root.muted ? Colors.red : Colors.palette.blue
      }

      Rectangle {
        width: 12
        height: 12
        radius: 6
        color: root.muted ? Colors.red : Colors.palette.blue
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
      color: Colors.text
      font.family: Fonts.display
      font.pixelSize: 13
      font.weight: 600
      font.features: root.percentTabular ? { "tnum": 1 } : {}
      Layout.preferredWidth: 38
      horizontalAlignment: Text.AlignRight
    }
  }
}
