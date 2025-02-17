import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import org.deepin.ds 1.0
import org.deepin.dtk 1.0 as D
import org.deepin.ds.dock 1.0

import "utils.js" as U

PanelPopup {
    width: 300
    height: 500

    function update() {
        sortedByFreqModel.clear()
        sortedByTimeModel.clear()
        let records = JSON.parse(Applet.perAppStatDaily)
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
        barChart.update(JSON.parse(Applet.eventsDaily))
    }

    id: root
    ScrollView {
        anchors.fill: parent
        id: scrollview
        clip: true
        contentHeight: expand.height + piePane.height + barPane.height + rankingPane.height + 20
        onContentHeightChanged: console.log('scrollview', width, height,
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
                Component.onCompleted: console.log('piepane', height,
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
                onHeightChanged: console.log("ColLayout", height,
                                             implicitHeight, list.height,
                                             list.implicitHeight, contentHeight)
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
