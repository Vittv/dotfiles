import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../style"
import "../../services"
import "../../core"

ModulePill {
  id: root
  width: spotifyContent.implicitWidth + 8
  visible: SpotifyService.displayText !== ""

  Item {
    id: spotifyContent
    anchors.centerIn: parent
    property string displayText: SpotifyService.displayText
    implicitHeight: 24
    implicitWidth: 180

    Row {
      spacing: 6
      anchors.verticalCenter: parent.verticalCenter
      anchors.right: parent.right
      Item {
        id: textClip
        width: 150
        height: label.implicitHeight
        clip: true
        anchors.verticalCenter: parent.verticalCenter
        Text {
          id: label
          text: spotifyContent.displayText
          color: Theme.text
          font.pixelSize: Theme.fontSizeNormal
          font.weight: Theme.weightNormal
          font.family: Theme.fontFamily
          x: 0
          SequentialAnimation on x {
            id: scrollAnim
            running: label.implicitWidth > textClip.width && spotifyContent.displayText !== ""
            loops: Animation.Infinite
            PauseAnimation { duration: 2000 }
            NumberAnimation {
              from: 0
              to: -(label.implicitWidth - textClip.width + 8)
              duration: Math.max(2000, label.implicitWidth * 12)
              easing.type: Easing.Linear
            }
            PauseAnimation { duration: 800 }
            NumberAnimation {
              from: -(label.implicitWidth - textClip.width + 8)
              to: 0
              duration: Math.max(1500, label.implicitWidth * 8)
              easing.type: Easing.Linear
            }
          }
        }
      }
    }

    Process { id: nextProcess; command: ["bash", "-c", "$HOME/.config/quickshell/src/spotify/spotify-ctl.sh next"] }
    Process { id: prevProcess; command: ["bash", "-c", "$HOME/.config/quickshell/src/spotify/spotify-ctl.sh previous"] }
    Process { id: playPauseProcess; command: ["bash", "-c", "$HOME/.config/quickshell/src/spotify/spotify-ctl.sh play-pause"] }
    Process { id: volUpProcess; command: ["bash", "-c", "$HOME/.config/quickshell/src/spotify/spotify-ctl.sh volume 0.05+"] }
    Process { id: volDownProcess; command: ["bash", "-c", "$HOME/.config/quickshell/src/spotify/spotify-ctl.sh volume 0.05-"] }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      onClicked: (mouse) => {
        if (mouse.button === Qt.LeftButton) nextProcess.running = true;
        else if (mouse.button === Qt.RightButton) prevProcess.running = true;
        else if (mouse.button === Qt.MiddleButton) playPauseProcess.running = true;
      }
      onWheel: (wheel) => {
        if (wheel.angleDelta.y > 0) volUpProcess.running = true;
        else volDownProcess.running = true
      }
    }
  }
}
