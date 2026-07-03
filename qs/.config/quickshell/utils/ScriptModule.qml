import QtQuick
import Quickshell
import Quickshell.Io
import "../style/"

// a reusable item that acts like a Waybar custom JSON module
Item {
  id: module

  property string execCommand: ""
  property int intervalMs: 2000
  property string onClickCommand: ""
  property string onClickRightCommand: ""
  property color textColor: Colors.text
  property int fontSize: 11
  property int fontWeight: Font.Bold

  // internal data parsed from your script's JSON output
  property string text: ""
  property string tooltip: ""
  property string className: ""

  implicitWidth: textLabel.implicitWidth
  implicitHeight: 24

  // timer to poll the script
  Timer {
    interval: module.intervalMs
    running: module.execCommand !== ""
    repeat: true
    triggeredOnStart: true
    onTriggered: backendProcess.running = true
  }

  // process executor for fetching data
  Process {
    id: backendProcess
    command: ["bash", "-c", module.execCommand]
    stdout: SplitParser {
      onRead: (line) => {
        try {
          let json = JSON.parse(line);
          module.text = json.text || "";
          module.tooltip = json.tooltip || "";
          module.className = json.class || "";
        } catch(e) {
          // fallback if script prints raw text instead of JSON
          module.text = line.trim();
        }
      }
    }
  }

  // process executor for mouse actions
  Process { id: clickProcess }

  Text {
    id: textLabel
    text: module.text
    color: module.textColor
    font.pixelSize: module.fontSize
    font.weight: module.fontWeight
    anchors.verticalCenter: parent.verticalCenter
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    cursorShape: Qt.PointingHandCursor
    onClicked: (mouse) => {
      if (mouse.button === Qt.LeftButton && module.onClickCommand) {
        clickProcess.command = ["bash", "-c", module.onClickCommand];
        clickProcess.running = true;
      } else if (mouse.button === Qt.RightButton && module.onClickRightCommand) {
        clickProcess.command = ["bash", "-c", module.onClickRightCommand];
        clickProcess.running = true;
      }
    }
  }
}
