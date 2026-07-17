import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../style"
import "../../core"

ClickMenu {
  id: root
  triggerItem: netModule

  implicitWidth: 300
  backgroundColor: Colors.base
  radius: 12

  property var wiredConns: []
  property var wifiNets: []
  property var vpnConns: []
  property var activeNames: []

  function signalBars(s) {
    if (s >= 75) return "▂▄▆█"
    if (s >= 50) return "▂▄▆_"
    if (s >= 25) return "▂▄__"
    return "▂___"
  }

  Process {
    id: connProc
    command: ["bash", "-c",
    "nmcli -t -f NAME,TYPE,ACTIVE connection show"]
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        var parts = line.split(":")
        if (parts.length < 3) return
        var name = parts[0], type = parts[1], active = parts[2] === "yes"
        if (type === "802-3-ethernet")
        root.wiredConns.push({ name: name, active: active })
        else if (type === "vpn")
        root.vpnConns.push({ name: name, active: active })
      }
    }
    onExited: root.wiredConnsChanged()
  }

  Process {
    id: wifiProc
    command: ["bash", "-c",
    "nmcli -t -f SSID,SIGNAL,SECURITY,ACTIVE device wifi list 2>/dev/null"]
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        var parts = line.split(":")
        if (parts.length < 3 || parts[0] === "") return
        root.wifiNets.push({
          ssid: parts[0],
          signal: parseInt(parts[1]) || 0,
          security: parts[2] !== "--",
          active: parts[3] === "yes"
        })
      }
    }
    onExited: root.wifiNetsChanged()
  }

  Process { id: actionProc }

  function doConnect(ssid) {
    actionProc.command = ["nmcli", "device", "wifi", "connect", ssid]
    actionProc.running = true
  }
  function doUp(name) {
    actionProc.command = ["nmcli", "connection", "up", name]
    actionProc.running = true
  }
  function doDown(name) {
    actionProc.command = ["nmcli", "connection", "down", name]
    actionProc.running = true
  }

  onOpenChanged: {
    if (open) {
      wiredConns = []; wifiNets = []; vpnConns = []
      connProc.running = true
      wifiProc.running = true
    }
  }

  ColumnLayout {
    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 18 }
    spacing: 16

    // WIRED
    SectionLabel { text: "WIRED" }
    ColumnLayout { Layout.fillWidth: true; spacing: 4
    Repeater {
      model: root.wiredConns
      delegate: Rectangle {
        required property var modelData
        Layout.fillWidth: true
        Layout.preferredHeight: 28
        radius: 6
        color: ma.containsMouse ? Colors.surface
        : modelData.active ? Qt.rgba(Colors.palette.blue.r, Colors.palette.blue.g, Colors.palette.blue.b, 0.1)
        : "transparent"
        RowLayout {
          anchors { left: parent.left; right: parent.right; leftMargin: 8; rightMargin: 8; verticalCenter: parent.verticalCenter }
          spacing: 8
          StatusDot { active: modelData.active }
          UiText { Layout.fillWidth: true; text: modelData.name; font.pixelSize: Theme.fontSizeNormal; font.weight: 500; elide: Text.ElideRight }
        }
        MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.doUp(modelData.name) }
      }
    }
    Text { visible: root.wiredConns.length === 0; text: "None"; color: Colors.subtext; font.family: Fonts.display; font.pixelSize: 12; font.italic: true }
  }

  Divider {}

  // WIFI
  SectionLabel { text: "WIFI" }
  ColumnLayout { Layout.fillWidth: true; spacing: 4
  Repeater {
    model: root.wifiNets
    delegate: Rectangle {
      required property var modelData
      Layout.fillWidth: true
      Layout.preferredHeight: 28
      radius: 6
      color: ma.containsMouse ? Colors.surface
      : modelData.active ? Qt.rgba(Colors.palette.blue.r, Colors.palette.blue.g, Colors.palette.blue.b, 0.1)
      : "transparent"
      RowLayout {
        anchors { left: parent.left; right: parent.right; leftMargin: 8; rightMargin: 8; verticalCenter: parent.verticalCenter }
        spacing: 8
        StatusDot { active: modelData.active }
        Text { text: root.signalBars(modelData.signal); color: modelData.active ? Colors.palette.blue : Colors.subtext; font.family: Fonts.display; font.pixelSize: 11 }
        UiText { Layout.fillWidth: true; text: modelData.ssid; font.pixelSize: Theme.fontSizeNormal; font.weight: 500; elide: Text.ElideRight }
        Text { visible: modelData.security; text: "🔒"; font.pixelSize: 10 }
      }
      MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.doConnect(modelData.ssid) }
    }
  }
  Text { visible: root.wifiNets.length === 0; text: "No networks found"; color: Colors.subtext; font.family: Fonts.display; font.pixelSize: 12; font.italic: true }
}

Divider {}

// VPN
SectionLabel { text: "VPN" }
ColumnLayout { Layout.fillWidth: true; spacing: 4
Repeater {
  model: root.vpnConns
  delegate: Rectangle {
    required property var modelData
    Layout.fillWidth: true
    Layout.preferredHeight: 28
    radius: 6
    color: ma.containsMouse ? Colors.surface
    : modelData.active ? Qt.rgba(Colors.palette.green.r, Colors.palette.green.g, Colors.palette.green.b, 0.1)
    : "transparent"
    RowLayout {
      anchors { left: parent.left; right: parent.right; leftMargin: 8; rightMargin: 8; verticalCenter: parent.verticalCenter }
      spacing: 8
      StatusDot { active: modelData.active; dotColor: Colors.green }
      UiText { Layout.fillWidth: true; text: modelData.name; font.pixelSize: Theme.fontSizeNormal; font.weight: 500; elide: Text.ElideRight }
      Text { text: modelData.active ? "On" : "Off"; color: modelData.active ? Colors.palette.green : Colors.subtext; font.family: Fonts.display; font.pixelSize: 11 }
    }
    MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: modelData.active ? root.doDown(modelData.name) : root.doUp(modelData.name) }
  }
}
Text { visible: root.vpnConns.length === 0; text: "None"; color: Colors.subtext; font.family: Fonts.display; font.pixelSize: 12; font.italic: true }
  }
}

Icon {
  name: "settings"
  size: 14
  iconColor: Colors.palette.overlay1
  anchors { top: parent.top; right: parent.right; margins: 12 }
  MouseArea {
    anchors.fill: parent
    anchors.margins: -4
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      actionProc.command = ["nm-connection-editor"]
      actionProc.running = true
      root.open = false
    }
  }
}
}
