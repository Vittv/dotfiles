import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: cpuModule
  property string temp: "--"
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    // toggle the running property instead of calling a non-existent start() method
    onTriggered: readTemp.running = true 
  }

  Process {
    id: readTemp
    command: ["bash", "-c", "/usr/bin/sensors | awk '/Tctl:/ {gsub(/[+°C]/, \"\", \$2); print int(\$2)}'"]
    
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        let cleanLine = line.trim();
        if (cleanLine.length > 0) {
          cpuModule.temp = cleanLine;
        }
      }
    }
  }

  Row {
    id: row
    spacing: 4
    Icon { name: "cpu"; size: 14; iconColor: Colors.text }
    Text {
      id: txt
      text: `${cpuModule.temp}°C`
      color: Colors.text
      font.pixelSize: 12
      font.family: "FiraCode Nerd Font"
      font.bold: true
    }
  }
}
