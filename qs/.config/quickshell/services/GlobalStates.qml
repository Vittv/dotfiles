pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
  id: root
  property bool launcherOpen: false
  property string launcherScreen: ""

  function toggle() {
    var focused = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : ""
    if (launcherOpen) {
      launcherOpen = false
    } else {
      launcherScreen = focused
      launcherOpen = true
    }
  }
  function open() {
    launcherScreen = Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : ""
    launcherOpen = true
  }
  function close() { launcherOpen = false }

  IpcHandler {
    target: "launcher"
    function toggle(): void { root.toggle() }
    function open(): void { root.open() }
    function close(): void { root.close() }
  }
}
