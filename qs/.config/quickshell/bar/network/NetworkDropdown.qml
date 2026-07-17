import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../style"
import "../../core"

ClickMenu {
  id: root
  triggerItem: netModule

  implicitWidth: 320
  implicitHeight: 480
  backgroundColor: Theme.base
  radius: 10
  borderWidth: 1
  gap: 0
  borderColor: Theme.surface2

  property var connections: []
  property var wifiNetworks: []
  property var devices: []
  property bool busy: false
  property string message: ""
  property string wifiPassword: ""
  property int selectedWifiIndex: -1
  property bool editorAvailable: false
  property bool mudfishOn: false
  property bool mudfishStarting: false

  readonly property var activeConnections: connections.filter(c => c.active)
  readonly property var savedProfiles: connections.filter(c => !c.active && (c.type === "802-3-ethernet" || c.type === "ethernet" || c.type === "802-11-wireless" || c.type === "wifi" || c.type === "vpn"))

  function selectedWifiNetwork() {
    if (selectedWifiIndex < 0 || selectedWifiIndex >= wifiNetworks.length) return null
    return wifiNetworks[selectedWifiIndex]
  }

  function refresh() {
    root.connections = []
    root.wifiNetworks = []
    root.devices = []
    connProc.running = true
    devicesProc.running = true
    wifiScanProc.running = true
    editorCheckProc.running = true
    mudfishStatusProc.running = true
  }

  function connectWifi(network) {
    if (!network || network.ssid.length === 0) return
    if (network.secured && wifiPassword.length === 0) {
      selectedWifiIndex = wifiNetworks.indexOf(network)
      message = "Enter password for " + network.ssid
      return
    }
    busy = true
    message = "Connecting " + network.ssid + "..."
    var args = ["nmcli", "device", "wifi", "connect", network.ssid]
    if (network.device) args = args.concat(["ifname", network.device])
    if (network.secured) args = args.concat(["password", wifiPassword])
    actionProc.command = args
    actionProc.running = true
  }

  function connectProfile(profile) {
    busy = true
    message = "Connecting " + profile.name + "..."
    actionProc.command = ["nmcli", "connection", "up", "uuid", profile.uuid]
    actionProc.running = true
  }

  function disconnectDevice(device) {
    busy = true
    message = "Disconnecting..."
    actionProc.command = ["nmcli", "device", "disconnect", device]
    actionProc.running = true
  }

  onOpenChanged: {
    if (open) {
      wifiPassword = ""
      message = ""
      selectedWifiIndex = -1
      refresh()
    }
  }

  // PROCESSES
  Process {
    id: connProc
    command: ["nmcli", "-t", "-f", "NAME,UUID,TYPE,ACTIVE,DEVICE", "connection", "show"]
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        var f = line.split(":")
        if (f.length < 5) return
        if (f[4] === "lo" || f[0] === "lo") return
        root.connections.push({ name: f[0], uuid: f[1], type: f[2], active: f[3] === "yes", device: f[4] })
      }
    }
    onExited: root.connectionsChanged()
  }

  Process {
    id: devicesProc
    command: ["nmcli", "-t", "-f", "DEVICE,TYPE,STATE,CONNECTION", "device", "status"]
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        var f = line.split(":")
        if (f.length < 4) return
        if (f[0] === "lo") return
        root.devices.push({ device: f[0], type: f[1], state: f[2], connection: f[3] })
      }
    }
    onExited: root.devicesChanged()
  }

  Process {
    id: wifiScanProc
    command: ["nmcli", "-t", "-f", "IN-USE,BSSID,SSID,SIGNAL,SECURITY,CHANNEL,DEVICE", "device", "wifi", "list"]
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        var f = line.split(":")
        if (f.length < 7 || f[2].length === 0) return
        root.wifiNetworks.push({
          active: f[0] === "*",
          bssid: f[1],
          ssid: f[2],
          signal: parseInt(f[3]) || 0,
          security: f[4] === "--" ? "" : f[4],
          channel: f[5],
          device: f[6],
          secured: f[4] !== "--" && f[4].length > 0
        })
      }
    }
    onExited: root.wifiNetworksChanged()
  }

  Process { id: actionProc
    onRunningChanged: {
      if (!running) {
        root.busy = false
        root.wifiPassword = ""
        root.message = ""
        root.refresh()
      }
    }
  }

  Process {
    id: editorCheckProc
    command: ["sh", "-c", "command -v nm-connection-editor >/dev/null 2>&1 && printf yes || printf no"]
    stdout: SplitParser {
      onRead: (line) => { root.editorAvailable = line.trim() === "yes" }
    }
  }

  Process {
    id: mudfishStatusProc
    command: ["pgrep", "-x", "mudrun-headless"]
    onExited: (code) => { root.mudfishOn = (code === 0) }
    onRunningChanged: {
      if (running) root.mudfishOn = false
    }
  }

  Process {
    id: mudfishActionProc
    onRunningChanged: {
      if (!running) {
        if (root.mudfishStarting) {
          mudfishDelay.restart()
          root.mudfishStarting = false
        } else {
          mudfishStatusProc.running = true
        }
      }
    }
  }

  Timer {
    id: mudfishDelay
    interval: 1500
    onTriggered: mudfishStatusProc.running = true
  }

  // CONTENT
  ColumnLayout {
    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 14 }
    spacing: 12

    // header
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      Text {
        Layout.fillWidth: true
        text: "Network"
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Theme.weightBold
        elide: Text.ElideRight
      }

      Rectangle {
        visible: !root.busy
        width: scanText.implicitWidth + 14
        height: 24
        radius: 4
        color: scanMouse.containsMouse ? Theme.surfaceBorder : Theme.surface0
        border.width: 1
        border.color: Theme.surfaceBorder

        Text {
          id: scanText
          anchors.centerIn: parent
          text: "Scan"
          color: Theme.text
          font.family: Theme.fontFamily
          font.pixelSize: Theme.fontSizeSmall
          font.weight: Theme.weightNormal
        }

        MouseArea {
          id: scanMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: root.refresh()
        }
      }
    }

    // message
    Text {
      Layout.fillWidth: true
      visible: root.message.length > 0
      text: root.message
      color: Theme.subtext
      font.family: Theme.fontFamily
      font.pixelSize: Theme.fontSizeSmall
      elide: Text.ElideRight
    }

    // ACTIVE
    SectionLabel { text: "ACTIVE" }

    ColumnLayout { Layout.fillWidth: true; spacing: 4

      Repeater {
        model: root.activeConnections
        delegate: Rectangle {
          required property var modelData
          Layout.fillWidth: true
          Layout.preferredHeight: 36
          radius: 6
          color: Theme.surface0

          RowLayout {
            anchors { left: parent.left; right: parent.right; leftMargin: 10; rightMargin: 10; verticalCenter: parent.verticalCenter }
            spacing: 8

            StatusDot { active: true }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 0

              Text {
                Layout.fillWidth: true
                text: modelData.name
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeNormal
                font.weight: Theme.weightNormal
                elide: Text.ElideRight
              }

              Text {
                Layout.fillWidth: true
                text: modelData.type + " · " + modelData.device
                color: Theme.subtext
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeTiny
                elide: Text.ElideRight
              }
            }

            Rectangle {
              width: disconnectText.implicitWidth + 14
              height: 22
              radius: 4
              color: disconnectMouse.containsMouse ? Theme.red : Theme.surface0
              border.width: 1
              border.color: Theme.surfaceBorder

              Text {
                id: disconnectText
                anchors.centerIn: parent
                text: "Disconnect"
                color: disconnectMouse.containsMouse ? Theme.base : Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeTiny
                font.weight: Theme.weightNormal
              }

              MouseArea {
                id: disconnectMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.disconnectDevice(modelData.device)
              }
            }
          }
        }
      }

      Text {
        visible: root.activeConnections.length === 0
        text: "No active connections"
        color: Theme.subtextDark
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        font.italic: true
      }
    }

    // WI-FI
    SectionLabel { text: "WI-FI" }

    ColumnLayout { Layout.fillWidth: true; spacing: 4

      Repeater {
        model: root.wifiNetworks
        delegate: Rectangle {
          required property var modelData
          required property int index
          Layout.fillWidth: true
          Layout.preferredHeight: 36
          radius: 6
          color: root.selectedWifiIndex === index ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.12) : (wifiRowMouse.containsMouse ? Theme.surface0 : "transparent")

          RowLayout {
            anchors { left: parent.left; right: parent.right; leftMargin: 10; rightMargin: 10; verticalCenter: parent.verticalCenter }
            spacing: 8

            StatusDot { active: modelData.active; dotColor: Theme.accent }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 0

              Text {
                Layout.fillWidth: true
                text: modelData.ssid
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeNormal
                font.weight: Theme.weightNormal
                elide: Text.ElideRight
              }

              Text {
                Layout.fillWidth: true
                text: (modelData.security || "Open") + " · " + modelData.signal + "%"
                color: Theme.subtext
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeTiny
                elide: Text.ElideRight
              }
            }

            Rectangle {
              width: wifiActionText.implicitWidth + 14
              height: 22
              radius: 4
              color: wifiActionMouse.containsMouse && !root.busy ? Theme.accent : Theme.surface0
              border.width: 1
              border.color: Theme.surfaceBorder
              opacity: root.busy ? 0.5 : 1

              Text {
                id: wifiActionText
                anchors.centerIn: parent
                text: modelData.active ? "Active" : "Connect"
                color: wifiActionMouse.containsMouse && !root.busy ? Theme.base : Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeTiny
                font.weight: Theme.weightNormal
              }

              MouseArea {
                id: wifiActionMouse
                anchors.fill: parent
                enabled: !root.busy
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.connectWifi(modelData)
              }
            }
          }

          MouseArea {
            id: wifiRowMouse
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
          }
        }
      }

      Text {
        visible: root.wifiNetworks.length === 0
        text: "No Wi-Fi networks found"
        color: Theme.subtextDark
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        font.italic: true
      }
    }

    // password input
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 36
      visible: root.selectedWifiNetwork() !== null && root.selectedWifiNetwork().secured
      radius: 6
      color: Theme.surface0
      border.width: 1
      border.color: Theme.surfaceBorder

      RowLayout {
        anchors { left: parent.left; right: parent.right; leftMargin: 10; rightMargin: 10; verticalCenter: parent.verticalCenter }
        spacing: 8

        Item {
          Layout.fillWidth: true
          Layout.fillHeight: true

          TextInput {
            id: pwInput
            anchors.fill: parent
            text: root.wifiPassword
            echoMode: TextInput.Password
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            clip: true
            verticalAlignment: TextInput.AlignVCenter
            enabled: !root.busy

            onTextChanged: root.wifiPassword = text
            onAccepted: root.connectWifi(root.selectedWifiNetwork())
          }

          Text {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            visible: pwInput.text.length === 0
            text: "Password"
            color: Theme.subtext
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
          }
        }

        Rectangle {
          width: connectText.implicitWidth + 14
          height: 22
          radius: 4
          color: connectMouse.containsMouse && !root.busy ? Theme.accent : Theme.surface0
          border.width: 1
          border.color: Theme.surfaceBorder

          Text {
            id: connectText
            anchors.centerIn: parent
            text: "Connect"
            color: connectMouse.containsMouse && !root.busy ? Theme.base : Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeTiny
            font.weight: Theme.weightNormal
          }

          MouseArea {
            id: connectMouse
            anchors.fill: parent
            enabled: !root.busy
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.connectWifi(root.selectedWifiNetwork())
          }
        }
      }
    }

    // SAVED
    SectionLabel { text: "SAVED" }

    ColumnLayout { Layout.fillWidth: true; spacing: 4

      Repeater {
        model: root.savedProfiles
        delegate: Rectangle {
          required property var modelData
          Layout.fillWidth: true
          Layout.preferredHeight: 36
          radius: 6
          color: savedMouse.containsMouse ? Theme.surface0 : "transparent"

          RowLayout {
            anchors { left: parent.left; right: parent.right; leftMargin: 10; rightMargin: 10; verticalCenter: parent.verticalCenter }
            spacing: 8

            StatusDot { active: false }

            Text {
              Layout.fillWidth: true
              text: modelData.name
              color: Theme.text
              font.family: Theme.fontFamily
              font.pixelSize: Theme.fontSizeNormal
              font.weight: Theme.weightNormal
              elide: Text.ElideRight
            }

            Rectangle {
              width: savedActionText.implicitWidth + 14
              height: 22
              radius: 4
              color: savedActionMouse.containsMouse ? Theme.accent : Theme.surface0
              border.width: 1
              border.color: Theme.surfaceBorder

              Text {
                id: savedActionText
                anchors.centerIn: parent
                text: "Connect"
                color: savedActionMouse.containsMouse ? Theme.base : Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeTiny
                font.weight: Theme.weightNormal
              }

              MouseArea {
                id: savedActionMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.connectProfile(modelData)
              }
            }
          }

          MouseArea {
            id: savedMouse
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
          }
        }
      }

      Text {
        visible: root.savedProfiles.length === 0
        text: "No saved connections"
        color: Theme.subtextDark
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        font.italic: true
      }
    }

    // edit connections
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 30
      visible: root.editorAvailable
      radius: 6
      color: editorMouse.containsMouse ? Theme.surface0 : "transparent"
      border.width: 1
      border.color: Theme.surfaceBorder

      Text {
        anchors.centerIn: parent
        text: "Edit Connections"
        color: Theme.subtext
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        font.weight: Theme.weightNormal
      }

      MouseArea {
        id: editorMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          actionProc.command = ["nm-connection-editor"]
          actionProc.running = true
          root.open = false
        }
      }
    }

    // VPN
    SectionLabel { text: "VPN" }

    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 36
      radius: 6
      color: Theme.surface0

      RowLayout {
        anchors { left: parent.left; right: parent.right; leftMargin: 10; rightMargin: 10; verticalCenter: parent.verticalCenter }
        spacing: 8

        StatusDot { active: root.mudfishOn; dotColor: Theme.accent }

        Text {
          Layout.fillWidth: true
          text: "Mudfish"
          color: Theme.text
          font.family: Theme.fontFamily
          font.pixelSize: Theme.fontSizeNormal
          font.weight: Theme.weightNormal
        }

        Rectangle {
          width: mudfishActionText.implicitWidth + 14
          height: 22
          radius: 4
          color: mudfishBtnMouse.containsMouse ? (root.mudfishOn ? Theme.red : Theme.accent) : Theme.surface0
          border.width: 1
          border.color: Theme.surfaceBorder

          Text {
            id: mudfishActionText
            anchors.centerIn: parent
            text: root.mudfishOn ? "Stop" : "Start"
            color: mudfishBtnMouse.containsMouse ? Theme.base : Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeTiny
            font.weight: Theme.weightNormal
          }

          MouseArea {
            id: mudfishBtnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              if (root.mudfishOn) {
                mudfishActionProc.command = ["sh", "-c", "pkill -f mudrun-headless"]
              } else {
                root.mudfishStarting = true
                mudfishActionProc.command = ["sh", "-c", "sudo /opt/mudfish/6.5.0/bin/mudrun-headless &"]
              }
              mudfishActionProc.running = true
            }
          }
        }
      }
    }

    Text {
      Layout.fillWidth: true
      text: root.mudfishOn ? "VPN is active" : "VPN is inactive"
      color: root.mudfishOn ? Theme.subtext : Theme.subtextDark
      font.family: Theme.fontFamily
      font.pixelSize: Theme.fontSizeTiny
    }
  }
}
