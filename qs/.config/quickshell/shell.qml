//@ pragma UseQApplication
//@ pragma IconTheme Nordzy-pink-dark
import QtQuick
import Quickshell
import qs.components.Bar
import "style"
import "./services/"
import "./services/notifications/"

Bar {
  Component.onCompleted: {
    Qt.application.font.family = "Your Font Name"
  }

  ToastLayer {
    // Anchors to a specific screen since ToastLayer isn't inside
    // the per-monitor Variants loop — pick your primary.
    screen: Quickshell.screens.find(s => s.name === "DP-1") || Quickshell.screens[0]
  }
}
