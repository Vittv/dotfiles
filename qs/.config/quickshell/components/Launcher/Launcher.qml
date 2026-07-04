import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../style"

PopupWindow {
  id: root

  required property var panelWindow
  property bool open: false

  readonly property int listHeight: 120
  readonly property int searchHeight: 80
  readonly property int contentSpacing: 8
  readonly property int contentMargins: 4

  width: 800
  height: (contentMargins * 2) + searchHeight + contentSpacing + listHeight
  color: "transparent"

  grabFocus: true
  visible: open

  onOpenChanged: {
    if (open) {
      resultList.positionViewAtBeginning()
      searchInput.text = ""
      searchInput.forceActiveFocus()
      runSearch()
    }
  }

  anchor {
    window: panelWindow
    rect.x: root.screen ? (root.screen.width - width) / 2 : 0
    rect.y: root.screen ? Math.round(root.screen.height * 0.3) : 36
  }

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

  Component.onCompleted: {
    buildAppList()
    runSearch()
  }

  Connections {
    target: DesktopEntries
    function onApplicationsChanged() {
      buildAppList()
      runSearch()
    }
  }

  property string pendingQuery: ""
  property var filteredResults: []

  Timer {
    id: searchDebounce
    interval: 16
    onTriggered: root.runSearch()
  }

  function runSearch() {
    var q = pendingQuery.trim().toLowerCase()

    if (!q) {
      filteredResults = appList
      resultList.currentIndex = filteredResults.length > 0 ? 0 : -1
      return
    }

    var scored = []
    for (var i = 0; i < appList.length; i++) {
      var entry = appList[i]
      var s = fuzzyScore(entry.name, q)
      if (s > 0) scored.push({ entry: entry, score: s })
    }

    scored.sort(function(a, b) { return b.score - a.score })
    filteredResults = scored.map(function(x) { return x.entry })
    resultList.currentIndex = filteredResults.length > 0 ? 0 : -1
  }

  function moveSelection(delta) {
    if (resultList.count === 0) return
    var next = resultList.currentIndex + delta
    if (next < 0) next = 0
    if (next > resultList.count - 1) next = resultList.count - 1
    resultList.currentIndex = next
    resultList.positionViewAtIndex(next, ListView.Contain)
  }

  function launchSelected() {
    if (resultList.currentIndex < 0 || resultList.currentIndex >= filteredResults.length) return
    var entry = filteredResults[resultList.currentIndex]
    entry.execute()
    root.open = false
  }

  Rectangle {
    id: content
    anchors.fill: parent
    color: Colors.base
    border.width: 1
    border.color: Colors.surface
    radius: 20

    opacity: root.open ? 1 : 0
    Behavior on opacity {
      NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
    }

    transform: Scale {
      id: scaleTransform
      origin.x: content.width / 2
      origin.y: content.height / 2
      xScale: root.open ? 1 : 0.97
      yScale: root.open ? 1 : 0.97

      Behavior on xScale {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
      }
      Behavior on yScale {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
      }
    }

    ColumnLayout {
      anchors { fill: parent; margins: 6 }
      spacing: 8

      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 60
        radius: 20
        color: Colors.palette.mantle
        border.width: 1
        border.color: Colors.surface

        Item {
          anchors.fill: parent
          anchors.leftMargin: 12
          anchors.rightMargin: 12

          Text {
            id: searchIcon
            text: "\ue8b6"
            font.family: "Material Symbols Outlined"
            font.pixelSize: 17
            color: Colors.palette.overlay1
            anchors.verticalCenter: parent.verticalCenter
            font.variableAxes: { "wght": 500, "FILL": 0, "GRAD": 0, "opsz": 24 }
          }

          TextInput {
            id: searchInput
            anchors {
              left: searchIcon.right; leftMargin: 8
              right: parent.right
              verticalCenter: parent.verticalCenter
            }
            color: Colors.text
            font.pixelSize: 20
            font.family: Fonts.display
            font.weight: 500
            clip: true

            onTextChanged: {
              root.pendingQuery = text
              searchDebounce.restart()
            }

            Keys.onPressed: (event) => {
              if (event.key === Qt.Key_Down) {
                root.moveSelection(1)
                event.accepted = true
              } else if (event.key === Qt.Key_Up) {
                root.moveSelection(-1)
                event.accepted = true
              } else if (event.key === Qt.Key_J && (event.modifiers & Qt.ControlModifier)) {
                root.moveSelection(1)
                event.accepted = true
              } else if (event.key === Qt.Key_K && (event.modifiers & Qt.ControlModifier)) {
                root.moveSelection(-1)
                event.accepted = true
              } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                root.launchSelected()
                event.accepted = true
              } else if (event.key === Qt.Key_Escape) {
                root.open = false
                event.accepted = true
              }
            }
          }

          Text {
            anchors {
              left: searchIcon.right; leftMargin: 8
              right: parent.right
              verticalCenter: parent.verticalCenter
            }
            visible: searchInput.text.length === 0
            text: "Search..."
            color: Colors.palette.overlay1
            font.pixelSize: 20
            font.weight: 500
            font.family: Fonts.display
            elide: Text.ElideRight
          }
        }
      }

      ListView {
        id: resultList
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: 2
        boundsBehavior: Flickable.StopAtBounds
        cacheBuffer: 400
        currentIndex: -1

        model: ScriptModel {
          values: root.filteredResults
        }

        delegate: Rectangle {
          id: delegateRoot
          required property var modelData
          required property int index
          width: ListView.view.width
          height: 40
          radius: 6
          color: (ListView.isCurrentItem || mouse.containsMouse) ? Colors.base : "transparent"

          RowLayout {
            anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
            spacing: 10

            IconImage {
              source: Quickshell.iconPath(delegateRoot.modelData.icon || "", true)
              width: 14
              height: 14
              asynchronous: true
            }

            Text {
              Layout.fillWidth: true
              text: delegateRoot.modelData.name || ""
              color: (delegateRoot.ListView.isCurrentItem || mouse.containsMouse) ? Colors.palette.lavender : Colors.text
              font.family: Fonts.display
              font.weight: 500
              font.pixelSize: 16
              elide: Text.ElideRight
            }
          }

          MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: resultList.currentIndex = delegateRoot.index
            onClicked: {
              delegateRoot.modelData.execute()
              root.open = false
            }
          }
        }
      }
    }
  }

  function fuzzyScore(text, query) {
    if (!query || !text) return 0
    text = text.toLowerCase()
    query = query.toLowerCase()

    var ti = 0
    var score = 0
    var matchCount = 0
    var totalGap = 0
    var lastMatchIndex = -1
    var firstMatchIndex = -1

    for (var qi = 0; qi < query.length; qi++) {
      var qc = query[qi]
      var matched = false

      while (ti < text.length) {
        if (text[ti] === qc) {
          matched = true
          if (firstMatchIndex === -1) firstMatchIndex = ti

          if (ti === 0 || text[ti-1] === ' ' || text[ti-1] === '-' || text[ti-1] === '_')
            score += 15  // word boundary match
          else if (lastMatchIndex >= 0 && ti === lastMatchIndex + 1)
            score += 8   // consecutive match
          else
            score += 3   // scattered match

          if (lastMatchIndex >= 0)
            totalGap += ti - lastMatchIndex - 1

          lastMatchIndex = ti
          matchCount++
          ti++
          break
        }
        ti++
      }

      if (!matched) return 0
    }

    if (firstMatchIndex === 0) score += 30       // prefix match
    score -= totalGap * 2                         // penalize gaps
    if (lastMatchIndex - firstMatchIndex + 1 === query.length)
      score += 20                                 // consecutive block bonus

    return Math.max(score, 0)
  }
}
