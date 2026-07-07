import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "Modules/Left"
import "Modules/Middle"
import "Modules/Right"
import "../Launcher"
import "../../services"
import "../../style"

Scope {
  id: root

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel
      required property var modelData
      screen: modelData

      anchors { top: true; left: true; right: true }

      implicitHeight: mainBarBody.height
      color: "transparent"
      exclusiveZone: mainBarBody.height

      Rectangle {
        id: mainBarBody
        anchors {
          top: parent.top;
          left: parent.left;
          right: parent.right;
        }
        implicitHeight: 30
        color: Colors.base

        Rectangle {
          anchors { top: parent.top; left: parent.left; right: parent.right }
          height: 1
          color: Qt.rgba(1, 1, 1, 0.06)
        }

        Item {
          anchors.fill: parent
          anchors.leftMargin: 4
          anchors.rightMargin: 4

          // left
          Rectangle {
            id: leftPill
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: 24
            width: leftRow.width + 16
            color: typeof Colors !== 'undefined' ? Colors.base : "#252530"
            radius: 6

            Row {
              id: leftRow
              anchors.centerIn: parent
              spacing: 10

              Rectangle {
                width: micModule.implicitWidth + 8
                implicitHeight: 20
                radius: 4
                color: micHover.containsMouse ? Colors.overlay0 : "transparent"
                Behavior on color { ColorAnimation { duration: 120 } }
                anchors.verticalCenter: parent.verticalCenter

                Microphone { id: micModule; anchors.centerIn: parent }

                MouseArea {
                  id: micHover
                  anchors.fill: parent
                  hoverEnabled: true
                  acceptedButtons: Qt.NoButton
                  cursorShape: Qt.PointingHandCursor
                }
              }

              Workspaces {
                id: workspacesModule
                targetScreen: modelData
                anchors.verticalCenter: parent.verticalCenter
              }

              Rectangle {
                width: tmuxModule.implicitWidth + 8
                implicitHeight: 20
                radius: 4
                color: tmuxHover.containsMouse ? Colors.overlay0 : "transparent"
                Behavior on color { ColorAnimation { duration: 120 } }
                anchors.verticalCenter: parent.verticalCenter
                visible: tmuxModule.active

                Tmux { id: tmuxModule; anchors.centerIn: parent; }

                MouseArea {
                  id: tmuxHover
                  anchors.fill: parent
                  hoverEnabled: true
                  acceptedButtons: Qt.NoButton
                  cursorShape: Qt.PointingHandCursor
                }
              }

              Rectangle {
                width: devServerText.implicitWidth + 8
                implicitHeight: 20
                radius: 4
                color: devHover.containsMouse ? Colors.overlay0 : "transparent"
                Behavior on color { ColorAnimation { duration: 120 } }
                anchors.verticalCenter: parent.verticalCenter
                visible: devServerText.active

                DevServer { id: devServerText; anchors.centerIn: parent; }

                MouseArea {
                  id: devHover
                  anchors.fill: parent
                  hoverEnabled: true
                  acceptedButtons: Qt.NoButton
                  cursorShape: Qt.PointingHandCursor
                }
              }

            }
          }

          // spotify
          Rectangle {
            id: spotifyWrapper
            width: spotifyModule.implicitWidth + 8
            implicitHeight: 20
            radius: 4
            color: "transparent"
            Behavior on color { ColorAnimation { duration: 120 } }
            anchors {
              right: clockWrapper.left
              rightMargin: 8
              verticalCenter: parent.verticalCenter
            }
            Spotify { id: spotifyModule; anchors.centerIn: parent }
          }

          // clock
          Rectangle {
            id: clockWrapper
            anchors.centerIn: parent
            implicitWidth: clockModule.implicitWidth + 12
            implicitHeight: 24
            radius: 6
            color: clockHover.containsMouse ? Colors.overlay0 : "transparent"
            Behavior on color { ColorAnimation { duration: 120 } }

            Clock {
              id: clockModule
              anchors.centerIn: parent
            }

            MouseArea {
              id: clockHover
              anchors.fill: parent
              hoverEnabled: true
              acceptedButtons: Qt.NoButton
              cursorShape: Qt.PointingHandCursor
            }
          }
          ClockPopup {
            id: clockPopup
            triggerItem: clockModule
          }

          // right
          Row {
            id: rightSideRow
            anchors {
              right: parent.right
              rightMargin: 10
              verticalCenter: parent.verticalCenter
            }
            spacing: 8

            Rectangle {
              width: trayModule.implicitWidth + 8
              implicitHeight: 20
              radius: 4
              color: trayHover.containsMouse ? Colors.overlay0 : "transparent"
              Behavior on color { ColorAnimation { duration: 120 } }

              Tray { id: trayModule; anchors.centerIn: parent }

              MouseArea {
                id: trayHover
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                cursorShape: Qt.PointingHandCursor
              }
            }

            Rectangle {
              width: mudfishModule.implicitWidth + 8
              implicitHeight: 20
              radius: 4
              color: mudHover.containsMouse ? Colors.overlay0 : "transparent"
              Behavior on color { ColorAnimation { duration: 120 } }

              Mudfish { id: mudfishModule; anchors.centerIn: parent }

              MouseArea {
                id: mudHover
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                cursorShape: Qt.PointingHandCursor
              }
            }

            Rectangle {
              width: netModule.implicitWidth + 8
              implicitHeight: 20
              radius: 4
              color: netHover.containsMouse ? Colors.overlay0 : "transparent"
              Behavior on color { ColorAnimation { duration: 120 } }

              Network { id: netModule; anchors.centerIn: parent }

              MouseArea {
                id: netHover
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                cursorShape: Qt.PointingHandCursor
              }
            }

            Rectangle {
              width: volModule.implicitWidth + 8
              implicitHeight: 20
              radius: 4
              color: volHover.containsMouse ? Colors.overlay0 : "transparent"
              Behavior on color { ColorAnimation { duration: 120 } }

              Volume { id: volModule; anchors.centerIn: parent }

              MouseArea {
                id: volHover
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                cursorShape: Qt.PointingHandCursor
              }
            }

            Rectangle {
              width: ccModule.implicitWidth + 8
              implicitHeight: 20
              radius: 4
              color: ccHover.containsMouse ? Colors.overlay0 : "transparent"
              Behavior on color { ColorAnimation { duration: 120 } }

              ControlCenter { id: ccModule; anchors.centerIn: parent }

              MouseArea {
                id: ccHover
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                cursorShape: Qt.PointingHandCursor
              }
            }
          }
        }
        Rectangle {
          anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
          }
          height: 1
          color: Qt.rgba(1, 1, 1, 0.06)
        }
      }

      VolumePopup {
        id: volumePopup
        triggerItem: volModule
      }

      ControlCenterPopup {
        id: ccPopup
        triggerItem: ccModule
      }

      NetworkPopup {
        id: networkPopup
        triggerItem: netModule
      }

      Launcher {
        id: launcher
        panelWindow: panel
      }

      Connections {
        target: GlobalStates
        function onLauncherOpenChanged() { updateLauncherState() }
        function onLauncherScreenChanged() { updateLauncherState() }
        function updateLauncherState() {
          launcher.open = GlobalStates.launcherOpen && GlobalStates.launcherScreen === modelData.name
        }
      }
    }
  }
}
