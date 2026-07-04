import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "Modules/Left"
import "Modules/Middle"
import "Modules/Right"
import "../../services"
import "../Launcher"
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
      
      implicitHeight: mainBarBody.height + leftWing.height
      color: "transparent"
      exclusiveZone: mainBarBody.height

      Rectangle {
        id: mainBarBody
        anchors {
          top: parent.top;
          left: parent.left;
          right: parent.right;
        }
        height: 26
        color: typeof Colors !== 'undefined' ? Colors.base : "#171719"

        // left wing
        Canvas {
          id: leftWing
          width: 12
          height: 12
          anchors {
            top: parent.bottom
            left: parent.left
          }

          onWidthChanged: requestPaint()
          onHeightChanged: requestPaint()

          onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.fillStyle = typeof Colors !== 'undefined' ? Colors.base : "#171719";
            ctx.beginPath();
            ctx.moveTo(0, 0);                             // top-left corner
            ctx.lineTo(width, 0);                         // line along the bar baseline
            ctx.quadraticCurveTo(0, 0, 0, height);        // curve outwards to the screen edge
            ctx.closePath();
            ctx.fill();
          }
        }

        // right wing
        Canvas {
          id: rightWing
          width: 12
          height: 12
          anchors {
            top: parent.bottom
            right: parent.right
          }

          onWidthChanged: requestPaint()
          onHeightChanged: requestPaint()

          onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.fillStyle = typeof Colors !== 'undefined' ? Colors.base : "#171719";
            ctx.beginPath();
            ctx.moveTo(width, 0);                         
            ctx.lineTo(width, height);                    
            ctx.quadraticCurveTo(width, 0, 0, 0);
            ctx.closePath();
            ctx.fill();
          }
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
            height: 24
            width: leftRow.width + 16
            color: typeof Colors !== 'undefined' ? Colors.base : "#252530"
            radius: 6

            Row {
              id: leftRow
              anchors.centerIn: parent
              spacing: 10

              LauncherButton {
                id: launcherButton
                targetScreen: modelData
                anchors {
                  verticalCenter: parent.verticalCenter
                }
              }

              Rectangle {
                width: micModule.implicitWidth + 8
                height: 20
                radius: 4
                color: Colors.overlay0
                anchors.verticalCenter: parent.verticalCenter
                Microphone { id: micModule; anchors.centerIn: parent }
              }

              Rectangle {
                width: tmuxModule.implicitWidth + 8
                height: 20
                radius: 4
                color: Colors.text
                anchors.verticalCenter: parent.verticalCenter
                Tmux { id: tmuxModule; anchors.centerIn: parent; textColor: Colors.base }
              }
              DevServer {}
            }
          }
          // middle
          Rectangle {
            id: centerPill
            height: 24
            radius: 6
            color: Colors.base

            anchors {
              left: spotifyModule.left
              leftMargin: -12
              right: clockModule.right
              rightMargin: 12
              verticalCenter: parent.verticalCenter
            }
          }

          // clock
          Clock {
            id: clockModule
            anchors {
              left: parent.horizontalCenter
              leftMargin: 16
              verticalCenter: parent.verticalCenter
            }
            width: 96
            horizontalAlignment: Text.AlignHCenter
          }
          Workspaces {
            id: workspacesModule
            targetScreen: modelData
            anchors {
              right: parent.horizontalCenter
              rightMargin: 12
              verticalCenter: parent.verticalCenter
            }
          }

          // spotify
          Spotify {
            id: spotifyModule
            anchors {
              right: workspacesModule.left
              rightMargin: 12
              verticalCenter: parent.verticalCenter
            }
          }

          SystemStatus {
            id: systemStatusModule
            anchors {
              left: clockModule.right
              leftMargin: 26
              verticalCenter: parent.verticalCenter
            }
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

            // tray
            Rectangle {
              width: trayModule.implicitWidth + 8
              height: 20
              radius: 4
              color: "transparent"
              Tray { id: trayModule; anchors.centerIn: parent }
            }

            // Rectangle {
            //   width: cpuModule.implicitWidth + 8
            //   height: 20
            //   radius: 4
            //   color: Colors.surface
            //   CpuTemp { id: cpuModule; anchors.centerIn: parent }
            // }
            //
            // Rectangle {
            //   width: gpuModule.implicitWidth + 8
            //   height: 20
            //   radius: 4
            //   color: Colors.surface
            //   GpuTemp { id: gpuModule; anchors.centerIn: parent }
            // }

            // network
            Rectangle {
              width: netModule.implicitWidth + 8
              height: 20
              radius: 4
              color: Colors.overlay0
              Network { id: netModule; anchors.centerIn: parent }
            }

            // volume
            Rectangle {
              width: volModule.implicitWidth + 8
              height: 20
              radius: 4
              color: Colors.overlay0
              Volume { id: volModule; anchors.centerIn: parent }
            }

            // notifications
            Rectangle {
              width: notifModule.implicitWidth + 8
              height: 20
              radius: 4
              color: Colors.overlay0
              Notifications { id: notifModule; anchors.centerIn: parent }
            }

            // logout
            Rectangle {
              width: logoutModule.implicitWidth + 8
              height: 20
              radius: 4
              color: Colors.overlay0
              Logout { 
                id: logoutModule; 
                anchors.centerIn: parent
              }
            }
          }
        }
      }

      LogoutPopup {
        id: logoutPopup
        triggerItem: logoutModule
      }

      VolumePopup {
        id: volumePopup
        triggerItem: volModule
      }

      Launcher {
        id: launcher
        panelWindow: ScreenAnchors.forScreen(modelData)
      }


      Connections {
        target: launcher
        function onOpenChanged() {
          if (!launcher.open) GlobalStates.launcherOpen = false
        }
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
