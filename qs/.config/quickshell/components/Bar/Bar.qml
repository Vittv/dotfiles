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
        implicitHeight: 28
        color: Colors.base
        border.width: 1
        border.color: Colors.palette.surface1

        Rectangle {
          anchors { top: parent.top; left: parent.left; right: parent.right }
          height: 1
          color: Qt.rgba(1, 1, 1, 0.06)
        }

        Item {
          anchors.fill: parent

          // left
          Rectangle {
            id: leftPill
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: 24
            width: leftRow.width + 16
            color: typeof Colors !== 'undefined' ? Colors.base : "#252530"
            // radius: 6

            Row {
              id: leftRow
              anchors.centerIn: parent
              spacing: 4

              LauncherButton {
                anchors.verticalCenter: parent.verticalCenter
              }
              Microphone {
                anchors.verticalCenter: parent.verticalCenter
              }
              Workspaces {
                id: workspacesModule
                targetScreen: modelData
                anchors.verticalCenter: parent.verticalCenter
              }
              Tmux {
                anchors.verticalCenter: parent.verticalCenter
              }
              DevServer {
                anchors.verticalCenter: parent.verticalCenter
              }
              ActiveWindow {
                anchors.verticalCenter: parent.verticalCenter
              }
            }
          }
          // middle -> purposely not a row or a group rectangle!
          // so we can have clock and spotify not push each other
          Spotify {
            id: spotifyModule
            anchors {
              right: clockModule.left
              rightMargin: 4
              verticalCenter: parent.verticalCenter
            }
          }
          Clock {
            id: clockModule
            anchors.centerIn: parent
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
            spacing: 4

            Tray {
              id: trayModule
              anchors.verticalCenter: parent.verticalCenter
            }

            Network {
              id: netModule
              anchors.verticalCenter: parent.verticalCenter
            }

            Volume {
              id: volModule
              anchors.verticalCenter: parent.verticalCenter
            }

            Logout {
              id: logoutModule
              anchors.verticalCenter: parent.verticalCenter
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
      // popups and state

      TrayPopup {
        id: trayPopup
        triggerItem: trayModule
      }

      VolumePopup {
        id: volumePopup
        triggerItem: volModule
      }

      NetworkPopup {
        id: networkPopup
        triggerItem: netModule
      }

      LogoutPopup {
        id: logoutPopup
        triggerItem: logoutModule
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
