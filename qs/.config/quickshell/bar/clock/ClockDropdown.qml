import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../style"
import "../../core"

ClickMenu {
  id: root

  implicitWidth: 500
  implicitHeight: content.implicitHeight + 40
  backgroundColor: Colors.base
  radius: 12
  centerInWindow: true
  borderWidth: 1
  borderColor: Colors.palette.surface2

  SystemClock {
    id: sysClock
    precision: SystemClock.Seconds
  }
  readonly property date now: sysClock.date

  // world clocks
  property var worldTimes: ({})

  Process {
    id: worldProc
    command: ["bash", "-c",
    "echo \"New York|$(TZ=America/New_York date +%H:%M)|$(TZ=America/New_York date +%Z)\";"
    + "echo \"Paris|$(TZ=Europe/Paris date +%H:%M)|$(TZ=Europe/Paris date +%Z)\";"
    + "echo \"Tokyo|$(TZ=Asia/Tokyo date +%H:%M)|$(TZ=Asia/Tokyo date +%Z)\""]
    stdout: SplitParser {
      onRead: (line) => {
        var parts = line.split("|")
        if (parts.length < 3) return
        var updated = Object.assign({}, root.worldTimes)
        updated[parts[0].trim()] = { time: parts[1], zone: parts[2] }
        root.worldTimes = updated
      }
    }
  }

  Timer {
    interval: 30000
    running: root.open
    repeat: true
    triggeredOnStart: true
    onTriggered: worldProc.running = true
  }

  // events & birthdays
  property string eventsFile: Qt.homePath + "/.config/quickshell/events.json"
  property var events: ({})
  property string newEventText: ""
  property bool isBirthdayMode: false

  function _dateKey(d) { // NOTE: also defined in MonthCalendar.qml
    if (!d) return ""
    return d.getFullYear() + "-"
    + ("0" + (d.getMonth() + 1)).slice(-2) + "-"
    + ("0" + d.getDate()).slice(-2)
  }

  function _monthDayKey(d) {
    if (!d) return ""
    return ("0" + (d.getMonth() + 1)).slice(-2) + "-"
    + ("0" + d.getDate()).slice(-2)
  }

  readonly property string selectedKey: _dateKey(cal.selectedDate)

  function addItem() {
    var text = newEventText.trim()
    if (!text) return
    if (root.isBirthdayMode) {
      addBirthday(text)
    } else {
      addEvent(text)
    }
  }

  function addEvent(text) {
    var key = selectedKey
    var updated = Object.assign({}, root.events)
    if (!updated[key]) updated[key] = []
    updated[key] = updated[key].concat([text])
    root.events = updated
    root.newEventText = ""
    saveEvents()
  }

  function addBirthday(name) {
    var md = _monthDayKey(cal.selectedDate)
    var updated = Object.assign({}, root.events)
    if (!updated._birthdays) updated._birthdays = []
    var exists = updated._birthdays.some(function(b) {
      return b.name === name && b.md === md
    })
    if (!exists) {
      updated._birthdays = updated._birthdays.concat([{ name: name, md: md }])
      root.events = updated
    }
    root.newEventText = ""
    saveEvents()
  }

  function removeEvent(key, idx) {
    var updated = Object.assign({}, root.events)
    if (!updated[key]) return
    updated[key] = updated[key].filter(function(_, i) { return i !== idx })
    if (updated[key].length === 0) delete updated[key]
    root.events = updated
    saveEvents()
  }

  function removeBirthday(idx) {
    var updated = Object.assign({}, root.events)
    if (!updated._birthdays) return
    updated._birthdays = updated._birthdays.filter(function(_, i) { return i !== idx })
    if (updated._birthdays.length === 0) delete updated._birthdays
    root.events = updated
    saveEvents()
  }

  Process { id: saveProc }

  function saveEvents() {
    var json = JSON.stringify(root.events)
    saveProc.command = ["python3", "-c",
    "import sys; open(sys.argv[2],'w').write(sys.argv[1])",
    json, root.eventsFile]
    saveProc.running = true
  }

  Process {
    id: loadProc
    command: ["cat", root.eventsFile]
    running: true
    stdout: SplitParser {
      onRead: (line) => {
        try { root.events = JSON.parse(line) }
        catch(e) { root.events = {} }
      }
    }
  }

  // upcoming items (events + birthdays for the viewed month)
  readonly property var upcoming: {
    var items = []
    var viewYear = cal.viewDate.getFullYear()
    var viewMonth = cal.viewDate.getMonth()

    for (var k in root.events) {
      if (k === "_birthdays" || !root.events.hasOwnProperty(k)) continue
      var parts = k.split("-")
      if (parts.length !== 3) continue
      var year = parseInt(parts[0])
      var month = parseInt(parts[1]) - 1
      if (year !== viewYear || month !== viewMonth) continue
      var d = new Date(year, month, parseInt(parts[2]))
      var arr = root.events[k]
      if (!arr || !Array.isArray(arr)) continue
      for (var i = 0; i < arr.length; i++) {
        items.push({
          date: d,
          sortKey: d.getTime(),
          displayDate: Qt.formatDate(d, "MMM d"),
          text: arr[i],
          type: "event",
          eventKey: k,
          eventIdx: i
        })
      }
    }

    var bdays = root.events._birthdays
    if (bdays && Array.isArray(bdays)) {
      for (var j = 0; j < bdays.length; j++) {
        var b = bdays[j]
        var bparts = b.md.split("-")
        if (bparts.length !== 2) continue
        var bmonth = parseInt(bparts[0]) - 1
        if (bmonth !== viewMonth) continue
        var bdate = new Date(viewYear, bmonth, parseInt(bparts[1]))
        items.push({
          date: bdate,
          sortKey: bdate.getTime(),
          displayDate: Qt.formatDate(bdate, "MMM d"),
          text: b.name,
          type: "birthday",
          bdayIdx: j
        })
      }
    }

    items.sort(function(a, b) { return a.sortKey - b.sortKey })
    return items
  }

  // marked dates for calendar
  readonly property var markedList: {
    var keys = []
    for (var k in root.events) {
      if (k === "_birthdays" || !root.events.hasOwnProperty(k)) continue
      keys.push(k)
    }
    var bdays = root.events._birthdays
    if (bdays && Array.isArray(bdays)) {
      var year = root.now.getFullYear()
      for (var j = 0; j < bdays.length; j++) {
        var b = bdays[j]
        var bparts = b.md.split("-")
        if (bparts.length !== 2) continue
        keys.push(year + "-" + b.md)
      }
    }
    return keys
  }

  // layout
  RowLayout {
    id: content
    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 16 }
    spacing: 16

    // left column: clock + calendar
    ColumnLayout {
      Layout.fillWidth: true
      Layout.preferredWidth: 3
      Layout.fillHeight: true
      spacing: 14

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2

        Text {
          Layout.fillWidth: true
          horizontalAlignment: Text.AlignLeft
          text: Qt.formatTime(root.now, "hh:mm:ss")
          color: Colors.text
          font.family: Fonts.display
          font.pixelSize: Theme.fontSizeHeading
          font.weight: 300
          font.letterSpacing: 1
        }

        Text {
          Layout.fillWidth: true
          horizontalAlignment: Text.AlignLeft
          text: Qt.formatDate(root.now, "dddd, MMMM d, yyyy")
          color: Colors.subtext
          font.family: Fonts.display
          font.pixelSize: Theme.fontSizeNormal
          font.italic: true
        }
      }

      Divider {}

      MonthCalendar {
        id: cal
        Layout.fillWidth: true
        viewDate: root.now
        markedDates: root.markedList
      }
    }

    Rectangle {
      Layout.fillHeight: true
      width: 1
      color: Colors.palette.surface2
    }

    // right column: world + upcoming
    ColumnLayout {
      Layout.fillWidth: true
      Layout.preferredWidth: 2
      Layout.fillHeight: true
      Layout.topMargin: 4
      spacing: 10

      SectionLabel { text: "WORLD" }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2

        Repeater {
          model: ["New York", "Paris", "Tokyo"]

          delegate: ColumnLayout {
            required property string modelData
            Layout.fillWidth: true
            spacing: 0

            RowLayout {
              Layout.fillWidth: true
              spacing: 6

              Rectangle {
                width: 4; height: 4; radius: 2
                color: Colors.accent
                opacity: 0.6
              }

              Text {
                text: modelData
                color: Colors.text
                font.family: Fonts.display
                font.pixelSize: 14
              }

              Item { Layout.fillWidth: true }

              Text {
                text: worldTimes[modelData] ? worldTimes[modelData].time : "--:--"
                color: Colors.subtext
                font.family: Fonts.display
                font.pixelSize: Theme.fontSizeNormal
                font.weight: 500
              }
            }

            Text {
              text: worldTimes[modelData] ? worldTimes[modelData].zone : ""
              color: Colors.palette
              font.family: Fonts.display
              font.pixelSize: 11
              font.italic: true
              Layout.leftMargin: 10
              Layout.bottomMargin: 4
            }
          }
        }
      }

      Divider {}

      // upcoming section header
      RowLayout {
        Layout.fillWidth: true
        spacing: 8

        SectionLabel { text: "UPCOMING" }

        Text {
          text: root.isBirthdayMode ? "BDAY" : "EVENT"
          color: Colors.text
          font.family: Fonts.display
          font.pixelSize: 11
          font.weight: 600
          font.letterSpacing: 1.2
          MouseArea {
            anchors.fill: parent
            anchors.margins: -4
            cursorShape: Qt.PointingHandCursor
            onClicked: root.isBirthdayMode = !root.isBirthdayMode
          }
        }
      }

      ListView {
        id: upcomingList
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: root.upcoming
        clip: true
        spacing: 4

        delegate: RowLayout {
          required property var modelData
          required property int index
          width: upcomingList.width
          spacing: 6

          Text {
            text: modelData.displayDate
            color: modelData.type === "birthday" ? Colors.red : Colors.subtext
            font.family: Fonts.display
            font.pixelSize: 12
          }

          Text {
            Layout.fillWidth: true
            text: modelData.text
            color: Colors.text
            font.family: Fonts.display
            font.pixelSize: Theme.fontSizeNormal
            wrapMode: Text.WordWrap
          }

          Text {
            text: "×"
            color: Colors.red
            font.family: Fonts.display
            font.pixelSize: 14
            MouseArea {
              anchors.fill: parent
              anchors.margins: -4
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                if (modelData.type === "event") {
                  root.removeEvent(modelData.eventKey, modelData.eventIdx)
                } else if (modelData.type === "birthday") {
                  root.removeBirthday(modelData.bdayIdx)
                }
              }
            }
          }
        }
      }

      Divider {}

      RowLayout {
        Layout.fillWidth: true
        spacing: 6

        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 30
          radius: 6
          color: Colors.overlay0
          border.width: 1
          border.color: Colors.palette.surface2
          clip: true

          TextInput {
            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
            anchors.leftMargin: 8
            text: root.newEventText
            color: Colors.text
            font.family: Fonts.display
            font.pixelSize: 14
            font.weight: 600
            onTextChanged: root.newEventText = text
            onAccepted: root.addItem()
          }
        }

        Text {
          text: "ADD"
          Layout.leftMargin: 8
          color: Colors.text
          font.family: Fonts.display
          font.pixelSize: 11
          font.weight: 600
          font.letterSpacing: 1.2
          MouseArea {
            anchors.fill: parent
            anchors.margins: -4
            cursorShape: Qt.PointingHandCursor
            onClicked: root.addItem()
          }
        }
      }
    }
  }
}
