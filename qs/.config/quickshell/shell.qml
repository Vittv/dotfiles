//@ pragma UseQApplication
//@ pragma IconTheme Nordzy-pink-dark
import QtQuick
import Quickshell
import qs.components.Bar
import "style"

Bar {
  Component.onCompleted: {
    Qt.application.font.family = "Your Font Name"
  }
}
