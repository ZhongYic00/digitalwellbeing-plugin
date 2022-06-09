import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import "utils.js" as U
import singleton.dpalette 1.0

Rectangle {
    width: 300
    height: 500
    property string perAppStatDaily_: PerAppStatDaily
    property string eventsDaily_: EventsDaily
    color: Qt.rgba(1, 1, 1, 0.1)

    function update() {
        console.warn('>>>>>>>DPalette test', DPalette.highlitedText, DPalette,
                     DPalette.button, DPalette.highlight)
        sortedByFreqModel.clear()
        sortedByTimeModel.clear()
        let records = JSON.parse(PerAppStatDaily)
        pieChart.update(records)
        records.forEach(record => sortedByTimeModel.append({
                                                               "name": record.name,
                                                               "icon": record.icon,
                                                               "stat": U.getTimeString(
                                                                           record.time)
                                                           }))
        records.sort((a, b) => b.freq - a.freq)
        records.forEach(record => sortedByFreqModel.append({
                                                               "name": record.name,
                                                               "icon": record.icon,
                                                               "stat": record.freq + ' times'
                                                           }))
    }

    onPerAppStatDaily_Changed: update()
    onEventsDaily_Changed: barChart.update(JSON.parse(EventsDaily))

    id: root
    ScrollView {
        anchors.fill: parent
        id: scrollview
        clip: true
        contentHeight: expand.height + piePane.height + barPane.height + rankingPane.height + 20
        onContentHeightChanged: console.warn('scrollview', width, height,
                                             contentHeight,
                                             contentWidth, spacing)
        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: 10
            width: root.width
            spacing: 10
            Switch {
                id: expand
                onToggled: root.update()
                visible: false
            }
            Pane {
                id: piePane
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.fillWidth: true
                padding: 0
                Component.onCompleted: console.warn('piepane', height,
                                                    contentHeight,
                                                    pieChart.implicitHeight)
                background: Rectangle {
                    id: pieBg
                    color: Qt.rgba(1, 1, 1, 0.3)
                    radius: 5
                    clip: true
                }

                PieChart {
                    id: pieChart
                    HoverHandler {
                        onHoveredChanged: pieBg.color = hovered ? Qt.rgba(
                                                                      1, 1, 1,
                                                                      0.4) : Qt.rgba(
                                                                      1,
                                                                      1, 1, 0.2)
                    }
                    implicitHeight: parent.width
                    implicitWidth: parent.width
                }
            }
            ListModel {
                id: sortedByTimeModel
            }
            ListModel {
                id: sortedByFreqModel
            }
            Pane {
                id: barPane
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.fillWidth: true
                padding: 0
                background: Rectangle {
                    id: barBg
                    color: Qt.rgba(1, 1, 1, 0.3)
                    radius: 5
                    clip: true
                }

                ScrollView {
                    implicitWidth: parent.width
                    implicitHeight: implicitWidth
                    contentHeight: height
                    contentWidth: 3 * width
                    clip: true
                    BarChart {
                        id: barChart
                        anchors.fill: parent
                        HoverHandler {
                            onHoveredChanged: barBg.color = hovered ? Qt.rgba(
                                                                          1, 1,
                                                                          1,
                                                                          0.4) : Qt.rgba(
                                                                          1, 1,
                                                                          1,
                                                                          0.2)
                        }
                    }
                }
            }
            Pane {
                id: rankingPane
                background: Rectangle {
                    color: Qt.rgba(1, 1, 1, 0.3)
                    HoverHandler {
                        onHoveredChanged: parent.color = hovered ? Qt.rgba(
                                                                       1, 1, 1,
                                                                       0.4) : Qt.rgba(
                                                                       1, 1, 1,
                                                                       0.2)
                    }
                    radius: 5
                    clip: true
                }

                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.fillWidth: true
                onHeightChanged: console.warn("ColLayout", height,
                                              implicitHeight, list.height,
                                              list.implicitHeight,
                                              contentHeight)
                implicitHeight: contentHeight
                bottomPadding: 20
                ColumnLayout {
                    spacing: 0
                    width: parent.width
                    Row {
                        height: 20
                        Layout.fillWidth: true
                        ButtonGroup {
                            id: rankingBtn
                        }
                        Button {
                            flat: true
                            checkable: true
                            checked: true
                            text: "Time"
                            height: parent.height
                            ButtonGroup.group: rankingBtn
                            onCheckedChanged: list.listmodel
                                              = checked ? sortedByTimeModel : sortedByFreqModel
                        }
                        Button {
                            flat: true
                            checkable: true
                            text: "Frequency"
                            height: parent.height
                            ButtonGroup.group: rankingBtn
                        }
                    }
                    UsageRanking {
                        id: list
                        listmodel: sortedByTimeModel
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
