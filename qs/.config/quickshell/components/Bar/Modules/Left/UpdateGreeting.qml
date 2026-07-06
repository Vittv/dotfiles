import QtQuick
import Quickshell.Io
import "../../../../style"

Item {
  id: root

  property int coreCount: 0
  property int aurCount: 0
  property int flatpakCount: 0
  property string username: ""

  readonly property int totalCount: coreCount + aurCount + flatpakCount

  property date currentTime: new Date()

  function greeting() {
    const h = root.currentTime.getHours()
    if (h >= 6 && h < 12) return "Morning"
    if (h >= 12 && h < 18) return "Afternoon"
    if (h >= 18 && h < 22) return "Evening"
    return "Night"
  }

  function capitalize(s) {
    if (!s) return s
    return s.charAt(0).toUpperCase() + s.slice(1)
  }

  function joinWithAnd(items) {
    if (items.length === 1) return items[0]
    if (items.length === 2) return items[0] + " and " + items[1]
    return items.slice(0, -1).join(", ") + ", and " + items[items.length - 1]
  }

  property string activeText: {
    const name = capitalize(username) || "there"
    const g = greeting()

    if (totalCount === 0) {
      return g + ", " + name + " — you have 0 package updates."
    }

    const parts = []
    if (coreCount > 0) parts.push(coreCount + " extra/core")
    if (aurCount > 0) parts.push(aurCount + " AUR")
    if (flatpakCount > 0) parts.push(flatpakCount + " Flatpak")

    const word = totalCount === 1 ? "update" : "updates"
    return g + ", " + name + " — you have " + joinWithAnd(parts) + " " + word + "."
  }

  implicitHeight: 24
  implicitWidth: 70
  width: implicitWidth
  height: implicitHeight

  // grab the username once
  Process {
    id: whoamiProc
    command: ["whoami"]
    stdout: StdioCollector {
      onStreamFinished: root.username = this.text.trim()
    }
  }

  // checkupdates (pacman-contrib) covers core/extra; AUR via paru/yay;
  // flatpak via its own update list. All counted in one shell call.
  Process {
    id: updateProc
    command: ["bash", "-c",
      "core=$(checkupdates 2>/dev/null | wc -l); " +
      "aur=$( (paru -Qua 2>/dev/null || yay -Qua 2>/dev/null) | wc -l ); " +
      "fp=$(flatpak list --updates 2>/dev/null | wc -l); " +
      "echo \"$core $aur $fp\""
    ]
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = this.text.trim().split(/\s+/).map(n => parseInt(n) || 0)
        root.coreCount = parts[0] || 0
        root.aurCount = parts[1] || 0
        root.flatpakCount = parts[2] || 0
      }
    }
  }

  Component.onCompleted: {
    whoamiProc.running = true
    updateProc.running = true
  }

  // recheck every 6 hours - kept lax since package updates don't need
  // near-real-time polling.
  Timer {
    interval: 6 * 60 * 60 * 1000
    running: true
    repeat: true
    onTriggered: updateProc.running = true
  }

  // refreshes just the greeting word, independent of the update poll,
  // so it flips Morning -> Afternoon -> Evening -> Night on time rather
  // than waiting on the next 6-hour check.
  Timer {
    interval: 5 * 60 * 1000
    running: true
    repeat: true
    onTriggered: root.currentTime = new Date()
  }

  Item {
    id: textClip
    width: parent.width
    height: label.implicitHeight
    clip: true
    anchors.verticalCenter: parent.verticalCenter

    Text {
      id: label
      text: root.activeText
      color: Colors.palette.base
      font.pixelSize: 14
      font.weight: Font.Bold
      font.family: "SF Pro Display"
      x: 0

      function restartScroll() {
        scrollAnim.stop()
        x = 0
        if (implicitWidth > textClip.width) {
          scrollAnim.start()
        }
      }

      onTextChanged: restartScroll()
      onImplicitWidthChanged: restartScroll()
      Component.onCompleted: restartScroll()

      SequentialAnimation {
        id: scrollAnim
        loops: Animation.Infinite

        PauseAnimation { duration: 2000 }
        NumberAnimation {
          target: label
          property: "x"
          from: 0
          to: -(label.implicitWidth - textClip.width + 8)
          duration: Math.max(2000, label.implicitWidth * 12)
          easing.type: Easing.Linear
        }
        PauseAnimation { duration: 2000 }
        NumberAnimation {
          target: label
          property: "x"
          from: -(label.implicitWidth - textClip.width + 8)
          to: 0
          duration: 0
        }
      }
    }
  }
}
