import Quickshell
import QtQuick
import QtQuick.Layouts
import "../launcher"
import "../services"
import "../style"
import "../core"
import "./clock"
import "./network"
import "./bluetooth"
import "./volume"
import "./tray"
import "./powermenu"
import "./spotify"
import "./workspaces"
import "./launcher"
import "./mic"
import "./tmux"
import "./devserver"

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
        implicitHeight: Theme.barHeight
        color: Theme.base
        border.width: 1
        border.color: Theme.surfaceAlt

        Rectangle {
          anchors { top: parent.top; left: parent.left; right: parent.right }
          height: 1
          color: Theme.surfaceBorder
        }

        Item {
          anchors.fill: parent

          // left
          Rectangle {
            id: leftPill
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: Theme.pillHeight
            width: leftRow.width + Theme.pillPadding * 2
            color: Theme.base

            Row {
              id: leftRow
              anchors.centerIn: parent
              spacing: Theme.spacingSmall

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
            }
          }
          // middle -> purposely not a row or a group rectangle!
          // so we can have clock and spotify not push each other
          Spotify {
            id: spotifyModule
            anchors {
              right: clockModule.left
              rightMargin: Theme.spacingSmall
              verticalCenter: parent.verticalCenter
            }
          }
          Clock {
            id: clockModule
            anchors.centerIn: parent
          }
          // right
          Row {
            id: rightSideRow
            anchors {
              right: parent.right
              rightMargin: Theme.spacing + Theme.spacingTight
              verticalCenter: parent.verticalCenter
            }
            spacing: Theme.spacingSmall

            Tray {
              id: trayModule
              anchors.verticalCenter: parent.verticalCenter
              onRequestMenu: (handle, item, x, y) => {
                if (!trayDropdownLoader.active) trayDropdownLoader.active = true
                trayDropdownLoader.item.show(handle, item, x, y)
              }
            }

            Bluetooth {
              id: btModule
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

            PowerMenuButton {
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
          color: Theme.surfaceBorder
        }
      }

      // --- lazy-loaded dropdowns ---

      Loader {
        id: clockDropdownLoader
        active: false
        sourceComponent: Component {
          ClockDropdown { triggerItem: clockModule }
        }
        onLoaded: item.open = true
      }
      Connections {
        target: clockModule
        function onClicked() {
          if (!clockDropdownLoader.active) clockDropdownLoader.active = true
        }
      }

      Loader {
        id: trayDropdownLoader
        active: false
        sourceComponent: Component {
          TrayDropdown { triggerItem: trayModule }
        }
      }

      Loader {
        id: networkDropdownLoader
        active: false
        sourceComponent: Component {
          NetworkDropdown { triggerItem: netModule }
        }
        onLoaded: item.open = true
      }
      Connections {
        target: netModule
        function onClicked() {
          if (!networkDropdownLoader.active) networkDropdownLoader.active = true
        }
      }

      Loader {
        id: bluetoothDropdownLoader
        active: false
        sourceComponent: Component {
          BluetoothDropdown { triggerItem: btModule }
        }
        onLoaded: item.open = true
      }
      Connections {
        target: btModule
        function onClicked() {
          if (!bluetoothDropdownLoader.active) bluetoothDropdownLoader.active = true
        }
      }

      Loader {
        id: volumeDropdownLoader
        active: false
        sourceComponent: Component {
          VolumeDropdown { triggerItem: volModule }
        }
        onLoaded: item.open = true
      }
      Connections {
        target: volModule
        function onClicked() {
          if (!volumeDropdownLoader.active) volumeDropdownLoader.active = true
        }
      }

      Loader {
        id: logoutDropdownLoader
        active: false
        sourceComponent: Component {
          PowerMenu { triggerItem: logoutModule }
        }
        onLoaded: item.open = true
      }
      Connections {
        target: logoutModule
        function onClicked() {
          if (!logoutDropdownLoader.active) logoutDropdownLoader.active = true
        }
      }

      Loader {
        id: launcherLoader
        active: false
        sourceComponent: Component {
          Launcher { panelWindow: panel }
        }
      }

      Connections {
        target: GlobalStates
        function onLauncherOpenChanged() { updateLauncherState() }
        function onLauncherScreenChanged() { updateLauncherState() }
        function updateLauncherState() {
          var shouldOpen = GlobalStates.launcherOpen && GlobalStates.launcherScreen === modelData.name
          if (shouldOpen) {
            if (!launcherLoader.active) launcherLoader.active = true
            launcherLoader.item.open = true
          } else if (launcherLoader.active) {
            launcherLoader.item.open = false
          }
        }
      }
    }
  }
}
