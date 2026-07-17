import QtQuick
import QtQuick.Layouts
import "../../style"
import "../../core"

Item {
  id: root
  implicitHeight: content.implicitHeight

  property date viewDate: new Date()
  readonly property date today: new Date()
  property date selectedDate: root.today
  property var markedDates: ([])

  readonly property var monthNames: ["January","February","March","April","May","June",
  "July","August","September","October","November","December"]
  readonly property var weekdayNames: ["Mo","Tu","We","Th","Fr","Sa","Su"]

  function _isSameDay(a, b) {
    return a && b && a.getFullYear() === b.getFullYear()
    && a.getMonth() === b.getMonth() && a.getDate() === b.getDate()
  }

  function _dateKey(d) { // NOTE: also defined in ClockDropdown.qml
    if (!d) return ""
    return d.getFullYear() + "-"
    + ("0" + (d.getMonth() + 1)).slice(-2) + "-"
    + ("0" + d.getDate()).slice(-2)
  }

  readonly property var cells: {
    var first = new Date(viewDate.getFullYear(), viewDate.getMonth(), 1)
    var offset = (first.getDay() + 6) % 7
    var totalDays = new Date(viewDate.getFullYear(), viewDate.getMonth() + 1, 0).getDate()
    var out = []
    for (var i = 0; i < offset; i++) out.push(null)
    for (var d = 1; d <= totalDays; d++) out.push(new Date(viewDate.getFullYear(), viewDate.getMonth(), d))
    while (out.length < 42) out.push(null)
    return out
  }

  ColumnLayout {
    id: content
    anchors { left: parent.left; right: parent.right; top: parent.top }
    spacing: 10

    RowLayout {
      Layout.fillWidth: true

      Icon {
        name: "chevron_left"
        size: 16
        iconColor: Theme.subtext
        MouseArea {
          anchors.fill: parent
          anchors.margins: -8
          cursorShape: Qt.PointingHandCursor
          onClicked: root.viewDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() - 1, 1)
        }
      }

      Text {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        text: root.monthNames[root.viewDate.getMonth()] + " " + root.viewDate.getFullYear()
        color: Theme.text
        font.family: Fonts.display
        font.pixelSize: 16
        font.weight: Theme.weightNormal
        font.letterSpacing: 0.5
      }

      Icon {
        name: "chevron_right"
        size: 16
        iconColor: Theme.subtext
        MouseArea {
          anchors.fill: parent
          anchors.margins: -8
          cursorShape: Qt.PointingHandCursor
          onClicked: root.viewDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() + 1, 1)
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: 0
      Repeater {
        model: root.weekdayNames
        delegate: Text {
          required property string modelData
          Layout.fillWidth: true
          Layout.preferredWidth: 1
          horizontalAlignment: Text.AlignHCenter
          text: modelData.toUpperCase()
          color: Theme.subtext
          font.family: Fonts.display
          font.pixelSize: 11
          font.letterSpacing: 0.8
          font.weight: Theme.weightSemibold
        }
      }
    }

    GridLayout {
      Layout.fillWidth: true
      columns: 7
      rowSpacing: 2
      columnSpacing: 0

      Repeater {
        model: 42

        delegate: Item {
          required property int index
          Layout.fillWidth: true
          Layout.preferredWidth: 1
          Layout.preferredHeight: 32

          readonly property var cellData: root.cells[index] || null
          readonly property bool isWeekend: index % 7 === 5 || index % 7 === 6
          readonly property bool isToday: cellData && root._isSameDay(cellData, root.today)
          readonly property bool isSelected: cellData && root._isSameDay(cellData, root.selectedDate)
          readonly property bool hasEvents: cellData && root.markedDates.indexOf(root._dateKey(cellData)) >= 0

          Rectangle {
            anchors.centerIn: parent
            width: 30
            height: 30
            radius: 8
            color: isSelected ? Theme.accent : Theme.surface0
            opacity: isSelected ? 0.25 : (hoverArea.containsMouse ? 0.4 : 0)
            visible: cellData
            Behavior on opacity { NumberAnimation { duration: 120 } }
          }

          Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: 6
            width: 3
            height: 3
            radius: 1.5
            visible: isToday && !isSelected && cellData
            color: Theme.accent
          }

          Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: 6
            width: 4
            height: 4
            radius: 2
            visible: hasEvents && cellData
            color: isSelected ? Theme.base : Theme.accent
          }

          Text {
            anchors.centerIn: parent
            visible: cellData
            text: cellData ? cellData.getDate() : ""
            color: {
              if (!cellData) return "transparent"
              if (isSelected) return Theme.accent
              if (isToday) return Theme.accent
              if (isWeekend) return Theme.subtext
              return Theme.text
            }
            font.family: Fonts.display
            font.pixelSize: 14
            font.weight: isToday || isSelected ? Theme.weightBold : Theme.weightNormal
          }

          MouseArea {
            id: hoverArea
            anchors.fill: parent
            hoverEnabled: true
            visible: cellData
            cursorShape: Qt.PointingHandCursor
            onClicked: { if (cellData) root.selectedDate = cellData }
          }
        }
      }
    }
  }
}
