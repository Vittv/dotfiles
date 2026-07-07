import QtQuick
import "../../style"

Item {
  id: toast
  property string appName: ""
  property string summary: ""
  property string body: ""
  property string image: ""
  property int expireMs: 5000
  property int notifId: -1
  signal dismissed(int id)

  width: 380
  height: card.implicitHeight
  // off-screen to the right at creation; slides in on completion.
  x: width

  Rectangle {
    id: card
    width: toast.width
    implicitHeight: 124
    radius: 16
    color: Colors.base

    Row {
      id: contentRow
      anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: 16 }
      spacing: 14

      Rectangle {
        id: thumb
        width: 44
        height: 44
        radius: 10
        color: Colors.overlay0
        visible: toast.image !== ""
        clip: true
        anchors.verticalCenter: parent.verticalCenter

        Image {
          anchors.fill: parent
          source: toast.image
          fillMode: Image.PreserveAspectCrop
        }
      }

      Column {
        width: parent.width - (toast.image !== "" ? (thumb.width + parent.spacing) : 0)
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter

        Text {
          text: toast.summary
          color: Colors.text
          font.family: Fonts.display
          font.pixelSize: 16
          font.weight: 700
          width: parent.width
          wrapMode: Text.Wrap
        }

        Text {
          text: toast.body
          color: Colors.text
          font.family: Fonts.display
          font.pixelSize: 15
          lineHeight: 1.25
          width: parent.width
          wrapMode: Text.Wrap
          maximumLineCount: 3
          elide: Text.ElideRight
        }
      }
    }
    Rectangle {
      anchors { top: parent.top; right: parent.right; margins: 10 }
      width: 14
      height: 14
      radius: 7
      color: closeBtn.containsMouse ? Colors.red : "transparent"

      Text {
        anchors.centerIn: parent
        text: "✕"
        color: closeBtn.containsMouse ? Colors.text : Colors.subtext
        font.pixelSize: 9
        font.weight: 700
      }

      MouseArea {
        id: closeBtn
        anchors.fill: parent
        hoverEnabled: true
        onClicked: toast.startDismiss()
      }
    }
  }

  // slide in from the right on creation.
  NumberAnimation {
    id: slideIn
    target: toast
    property: "x"
    to: 0
    from: 80
    duration: 200
    easing.type: Easing.OutCubic
    easing.overshoot: 0.4
  }
  Component.onCompleted: slideIn.start()

  Timer {
    interval: toast.expireMs
    running: true
    onTriggered: toast.startDismiss()
  }

  function startDismiss() {
    slideOut.start()
  }

  NumberAnimation {
    id: slideOut
    target: toast
    property: "opacity"
    to: 0
    duration: 120
    easing.type: Easing.InCubic
    onFinished: toast.dismissed(toast.notifId)
  }
}
