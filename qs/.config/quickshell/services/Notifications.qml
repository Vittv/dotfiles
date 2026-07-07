pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: root

  property bool dndEnabled: false
  property var activeToasts: []
  property var history: []

  signal toastAdded(var toast)
  signal toastRemoved(int id)

  NotificationServer {
    id: server
    bodySupported: true
    imageSupported: true
    keepOnReload: false

    onNotification: (notification) => {
      notification.tracked = true

      const entry = {
        id: notification.id,
        appName: notification.appName,
        summary: notification.summary,
        body: notification.body,
        image: notification.image,
        urgency: notification.urgency,
        expireTimeout: notification.expireTimeout,
        timestamp: Date.now()
      }

      root.history = root.history.concat([entry])

      if (!root.dndEnabled) {
        root.activeToasts = root.activeToasts.concat([entry])
        root.toastAdded(entry)
      }

      notification.closed.connect(() => {
        root.activeToasts = root.activeToasts.filter(t => t.id !== notification.id)
        root.toastRemoved(notification.id)
      })
    }
  }

  function dismissToast(id) {
    root.activeToasts = root.activeToasts.filter(t => t.id !== id)
    root.toastRemoved(id)
  }

  function clearHistory() {
    root.history = []
  }
}
