import QtQuick
import QtQuick.Layouts
import "../../style"
import "../../core"

Item {
  id: root

  property string iconName: ""
  property real value: 0
  property bool muted: false
  property bool percentTabular: false

  signal dragged(real value)
  signal toggled()

  implicitHeight: 32

  RowLayout {
    anchors.fill: parent
    spacing: 10

    Rectangle {
      visible: root.iconName.length > 0
      width: 28
      height: 20
      radius: 4
      color: iconMouse.containsMouse ? Theme.surface1 : Theme.surface0
      border.width: 1
      border.color: Theme.surfaceBorder

      Icon {
        anchors.centerIn: parent
        name: root.iconName
        size: 14
        iconColor: root.muted ? Theme.red : Theme.text
      }

      MouseArea {
        id: iconMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
      }
    }

    Item {
      id: sliderArea
      Layout.fillWidth: true
      Layout.preferredHeight: 32

      Rectangle {
        id: trackBg
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 4
        color: Theme.surface
        radius: height / 2

        Rectangle {
          width: Math.round((root.value) * parent.width)
          height: parent.height
          color: root.muted ? Theme.surface1 : Theme.accent
          radius: parent.radius
        }
      }

      Rectangle {
        width: 14
        height: 14
        x: Math.max(0, Math.min(sliderArea.width - width, Math.round(root.value * sliderArea.width) - width / 2))
        y: sliderArea.height / 2 - height / 2
        color: root.muted ? Theme.surface1 : Theme.accent
        radius: height / 2

        Rectangle {
          width: 8
          height: 8
          anchors.centerIn: parent
          color: Theme.base
          radius: 4
        }
      }

      MouseArea {
        id: sliderMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: (mouse) => root.dragged(Math.max(0, Math.min(1, mouse.x / sliderArea.width)))
        onPositionChanged: (mouse) => { if (pressed) root.dragged(Math.max(0, Math.min(1, mouse.x / sliderArea.width))) }
      }
    }

    Text {
      text: root.muted ? "muted" : Math.round(root.value * 100) + "%"
      color: Theme.text
      font.family: Theme.fontFamily
      font.pixelSize: Theme.fontSizeNormal
      font.bold: true
      font.features: root.percentTabular ? { "tnum": 1 } : {}
      Layout.preferredWidth: 42
      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
    }
  }
}
