// SPDX-FileCopyrightText: 2025 Yicheng Zhong <rubbishzyc@outlook.com>.
// SPDX-License-Identifier: MIT
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
        const id2info = new Map(records.map(record => ([record.id, {"name": record.name, "icon": record.icon}])))
        barChart.update(JSON.parse(Applet.eventsDaily),id2info)
    }
    component BackgroundColor: D.Palette {
        normal {
            common: ("transparent")
            crystal: Qt.rgba(1, 1, 1, .05)
        }
        normalDark {
            crystal: Qt.rgba(0, 0, 0, .3)
        }
        hovered {
            crystal: Qt.rgba(1, 1, 1, .3)
        }
        hoveredDark {
            crystal: Qt.rgba(0, 0, 0, .1)
        }
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
                
                background: D.BoxPanel {
                    radius: 5
                    color1: BackgroundColor {}
                    color2: color1
                    D.ColorSelector.family: D.Palette.CrystalColor
                    anchors.fill: parent
                }
                // onHoveredChanged: console.log(this,'hovered',hovered)

                PieChart {
                    id: pieChart
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

                // onHoveredChanged: console.log(this,'hovered',hovered)
                padding: 0
                background: D.BoxPanel {
                    radius: 5
                    color1: BackgroundColor {}
                    color2: color1
                    D.ColorSelector.family: D.Palette.CrystalColor
                    anchors.fill: parent
                }

                ScrollView {
                    implicitWidth: parent.width
                    implicitHeight: implicitWidth
                    contentHeight: height
                    contentWidth: 2 * width
                    clip: true
                    BarChart {
                        id: barChart
                        anchors.fill: parent
                    }
                }
            }
            Pane {
                id: rankingPane
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.fillWidth: true

                background: D.BoxPanel {
                    radius: 5
                    color1: BackgroundColor {}
                    color2: color1
                    D.ColorSelector.family: D.Palette.CrystalColor
                    anchors.fill: parent
                }

                Component.onCompleted: console.log("ColLayout", height,
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
