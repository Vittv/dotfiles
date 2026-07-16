pragma Singleton
import QtQuick
import Quickshell

Singleton {
  id: root

  property var appList: []

  function buildAppList() {
    var all = [...DesktopEntries.applications.values]
    var visible = []

    for (var i = 0; i < all.length; i++) {
      var e = all[i]
      if (!e.name) continue
      if (e.noDisplay) continue
      if (typeof e.hidden !== "undefined" && e.hidden) continue
      visible.push(e)
    }

    visible.sort(function(a, b) {
      return a.name.toLowerCase().localeCompare(b.name.toLowerCase())
    })

    appList = visible
  }

  Component.onCompleted: buildAppList()

  Connections {
    target: DesktopEntries
    function onApplicationsChanged() {
      buildAppList()
    }
  }
}
