import QtQuick
import Quickshell
import Quickshell.Io
import "../../../../style"

Item {
  id: gpuModule
  property string temp: "--"
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: readTemp.running = true 
  }

  Process {
    id: readTemp
    command: ["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"]
    
    stdout: SplitParser {
      splitMarker: "\n"
      onRead: (line) => {
        let cleanLine = line.trim();
        if (cleanLine.length > 0) {
          gpuModule.temp = cleanLine;
        }
      }
    }
  }

  Row {
    id: row
    spacing: 4
    Icon { name: "gpu"; size: 11; iconColor: Colors.text }
    Text {
      id: txt
      text: `${gpuModule.temp}°C`
      color: Colors.text
      font.pixelSize: 12
      font.family: "FiraCode Nerd Font"
      font.bold: true
    }
  }
}
