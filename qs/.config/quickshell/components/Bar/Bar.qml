import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "Modules/Left"
import "Modules/Middle"
import "Modules/Right"
import "../Launcher"
import "../../style"

Scope {
  id: root

  property bool launcherOpen: false
  property string launcherScreen: ""

  IpcHandler {
    target: "launcher"

    function toggle(): void {
      var focused = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : ""
      if (root.launcherOpen && root.launcherScreen === focused) {
        root.launcherOpen = false
      } else {
        root.launcherScreen = focused
        root.launcherOpen = true
      }
    }
    function open(): void {
      root.launcherScreen = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : ""
      root.launcherOpen = true
    }
    function close(): void {
      root.launcherOpen = false
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel
      required property var modelData
      screen: modelData

      anchors { top: true; left: true; right: true }
      
      implicitHeight: 28
      color: "transparent"
      exclusiveZone: mainBarBody.height

      Rectangle {
        id: mainBarBody
        anchors {
          top: parent.top
          left: parent.left
          right: parent.right
        }
        height: 28
        color: typeof Colors !== 'undefined' ? Colors.base : "#171719"

        // // left wing
        // Canvas {
        //   id: leftWing
        //   width: 12
        //   height: 12
        //   anchors {
        //     top: parent.bottom
        //     left: parent.left
        //   }
        //
        //   onWidthChanged: requestPaint()
        //   onHeightChanged: requestPaint()
        //
        //   onPaint: {
        //     var ctx = getContext("2d");
        //     ctx.reset();
        //     ctx.fillStyle = typeof Colors !== 'undefined' ? Colors.base : "#171719";
        //     ctx.beginPath();
        //     ctx.moveTo(0, 0);                             // top-left corner
        //     ctx.lineTo(width, 0);                         // line along the bar baseline
        //     ctx.quadraticCurveTo(0, 0, 0, height);        // curve outwards to the screen edge
        //     ctx.closePath();
        //     ctx.fill();
        //   }
        // }
        //
        // // right wing
        // Canvas {
        //   id: rightWing
        //   width: 12
        //   height: 12
        //   anchors {
        //     top: parent.bottom
        //     right: parent.right
        //   }
        //
        //   onWidthChanged: requestPaint()
        //   onHeightChanged: requestPaint()
        //
        //   onPaint: {
        //     var ctx = getContext("2d");
        //     ctx.reset();
        //     ctx.fillStyle = typeof Colors !== 'undefined' ? Colors.base : "#171719";
        //     ctx.beginPath();
        //     ctx.moveTo(width, 0);                         
        //     ctx.lineTo(width, height);                    
        //     ctx.quadraticCurveTo(width, 0, 0, 0);
        //     ctx.closePath();
        //     ctx.fill();
        //   }
        // }

        Item {
          anchors.fill: parent
          anchors.leftMargin: 8
          anchors.rightMargin: 8

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
              spacing: 0
              Rectangle {
                width: 28
                height: 20
                radius: 4
                color: Colors.surface
                anchors.verticalCenter: parent.verticalCenter
                Icon {
                  name: "apps"
                  size: 14
                  anchors.centerIn: parent
                }
                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: {
                    root.launcherScreen = modelData.name
                    root.launcherOpen = !root.launcherOpen
                  }
                }
              }
              Microphone {
                  anchors.verticalCenter: parent.verticalCenter
              }
              Workspaces {
                targetScreen: modelData
              }
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

          // clock - absolutely centered in the bar
          Clock {
            id: clockModule
            anchors.centerIn: parent
          }

          // spotify
          Spotify {
            id: spotifyModule
            anchors {
              right: clockModule.left
              rightMargin: 60
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
            spacing: 6

            // tray
            Rectangle {
              width: trayModule.implicitWidth + 8
              height: 20
              radius: 4
              color: Colors.surface
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
              color: Colors.surface
              Network { id: netModule; anchors.centerIn: parent }
            }

            // bluetooth
            Rectangle {
              width: btModule.implicitWidth + 8
              height: 20
              radius: 4
              color: Colors.surface
              Bluetooth { id: btModule; anchors.centerIn: parent }
            }

            // volume
            Rectangle {
              width: volModule.implicitWidth + 8
              height: 20
              radius: 4
              color: Colors.surface
              Volume { id: volModule; anchors.centerIn: parent }
            }

            // notifications
            Rectangle {
              width: notifModule.implicitWidth + 8
              height: 20
              radius: 4
              color: Colors.surface
              Notifications { id: notifModule; anchors.centerIn: parent }
            }

            // logout
            Rectangle {
              width: logoutModule.implicitWidth + 8
              height: 20
              radius: 4
              color: Colors.surface
              Logout { 
                id: logoutModule; 
                anchors.centerIn: parent
                onClicked: logoutPopup.open = !logoutPopup.open
              }
            }
          }
        }
      }

      LogoutPopup {
        id: logoutPopup
        panelWindow: panel
      }

      Launcher {
        id: launcher
        panelWindow: panel
      }

      Connections {
        target: launcher
        function onOpenChanged() {
          if (!launcher.open) {
            root.launcherOpen = false
          }
        }
      }

      Connections {
        target: root
        function onLauncherOpenChanged() { updateLauncherState() }
        function onLauncherScreenChanged() { updateLauncherState() }
        function updateLauncherState() {
          launcher.open = root.launcherOpen && root.launcherScreen === modelData.name
        }
      }
    }
  }
}
