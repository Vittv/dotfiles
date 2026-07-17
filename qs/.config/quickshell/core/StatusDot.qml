import QtQuick
import "."

Rectangle {
  id: root

  property bool active: false
  property color dotColor: Theme.accent

  width: 6
  height: 6
  radius: 3
  color: active ? dotColor : Theme.surface1
}
