//@ pragma UseQApplication
//@ pragma IconTheme Nordzy-pink-dark
import QtQuick
import Quickshell
import qs.components.Bar
import "style"
import "./services/"

Bar {
  Component.onCompleted: {
    Qt.application.font.family = "Your Font Name"
  }
}
