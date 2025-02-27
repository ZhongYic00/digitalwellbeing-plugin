// SPDX-FileCopyrightText: 2023 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15

import org.deepin.ds 1.0
import org.deepin.dtk 1.0 as D
import org.deepin.ds.dock 1.0

import "utils.js" as U

AppletItem {
    id: tray
    property bool useColumnLayout: Panel.position % 2
    property int dockOrder: 29
    // 1:4 the distance between app : dock height; get width/height≈0.8
    implicitWidth: (useColumnLayout ? Panel.rootObject.dockSize : Panel.rootObject.dockItemMaxSize * 0.8) * 2.5
    implicitHeight: useColumnLayout ? Panel.rootObject.dockItemMaxSize * 0.8 : Panel.rootObject.dockSize

    Connections {
        target: Panel.rootObject
        function onDockCenterPartPosChanged()
        {
            updatePopupPos()
        }
    }

    Connections {
        target: Panel.rootObject
        function onScreenChanged()
        {
            var launchpad = DS.applet("org.deepin.ds.launchpad")
            if (!launchpad || !launchpad.rootObject)
                return

            launchpad.rootObject.fullscreenFrame.screen = Panel.rootObject.screen
        }
    }

    Connections {
        target: DS.applet("org.deepin.ds.launchpad")
        enabled: target
        function onRootObjectChanged() {
            updatePopupPos()
        }
    }

    property point itemPos: Qt.point(0, 0)
    function updateItemPos()
    {
        var lX = root.mapToItem(null, root.width / 2, 0).x
        var lY = root.mapToItem(null, 0, 0).y
        tray.itemPos = Qt.point(lX, lY)
        console.log('selfpos',tray.itemPos)
    }
    function updatePopupPos()
    {
        updateItemPos()
        popupItem.x = tray.itemPos.x
        popupItem.y = tray.itemPos.y
        console.log('popupItem',popupItem.x,popupItem.y)
        // var launchpad = DS.applet("org.deepin.ds.launchpad")
        // if (!launchpad || !launchpad.rootObject)
        //     return

        // launchpad.rootObject.windowedPos = tray.itemPos
    }
    Component.onCompleted: {
        updatePopupPos()
    }

    PanelToolTip {
        id: toolTip
        text: qsTr("Digital Wellbeing Plugin")
        toolTipX: DockPanelPositioner.x
        toolTipY: DockPanelPositioner.y
    }
    

    Pane {
        id: root
        objectName: "DigitalWellbeingPluginItem"
        clip: true
        anchors.fill: parent

        rightPadding: 3
        leftPadding: rightPadding
        bottomPadding: 2

        property D.Palette backgroundColor: D.Palette {
            normal {
                common: ("transparent")
                crystal: ("transparent")
            }
            normalDark {
                crystal: ("transparent")
            }
            hovered {
                crystal: Qt.rgba(1, 1, 1, .3)
            }
            hoveredDark {
                crystal: Qt.rgba(1, 1, 1, .15)
            }
        }
        property D.Palette insideBorderColor: D.Palette {
            normal {
                crystal: ("transparent")
            }
            normalDark {
                crystal: ("transparent")
            }
            hovered {
                common: ("transparent")
                crystal: Qt.rgba(1.0, 1.0, 1.0, 0.1)
            }
            hoveredDark {
                crystal: Qt.rgba(1.0, 1.0, 1.0, 0.05)
            }
        }
        property D.Palette outsideBorderColor: D.Palette {
            normal {
                crystal: ("transparent")
            }
            normalDark {
                crystal: ("transparent")
            }
            hovered {
                crystal: Qt.rgba(0.0, 0.0, 0.0, 0.03)
            }
            hoveredDark {
                crystal: Qt.rgba(0.0, 0.0, 0.0, 0.05)
            }
        }

        background: D.BoxPanel {
            radius: 5
            color1: parent.backgroundColor
            color2: color1
            insideBorderColor: parent.insideBorderColor
            outsideBorderColor: parent.outsideBorderColor
            D.ColorSelector.family: D.Palette.CrystalColor
        }
        
        property var stats: JSON.parse(Applet.basicStat)
        Component.onCompleted: {
            console.log(this,width,height,Applet.basicStat,stats)
        }

        Button {
            id: colorRef
            visible: false
        }

        Timer {
            id: pageSwipeTimer
            interval: 5000
            repeat: true
            running: true
            onTriggered: view.currentIndex = (view.currentIndex + 1) % view.count
        }
        onStatsChanged: console.log('stats changed', Applet.basicStat)

        contentItem: SwipeView {
            id: view

            currentIndex: 0
            topPadding: 5
            interactive: false
            clip: true

            Column {
                id: firstPage
                spacing: 0
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    topPadding: -5
                    text: U.getTimeString(root.stats.totalTime)
                    font.pointSize: 10
                    lineHeight: 0.8
                    color: colorRef.D.ColorSelector.textColor
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Screen Time")
                    font.pointSize: 8
                    lineHeight: 0.8
                    color: colorRef.D.ColorSelector.textColor
                }
            }
            Column {
                id: secondPage
                spacing: 0
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    topPadding: -5
                    width: root.width
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter
                    text: root.stats.longestUsedApp || '<unknown>'
                    font.pointSize: 10
                    lineHeight: 0.8
                    color: colorRef.D.ColorSelector.textColor
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Longest Used")
                    font.pointSize: 8
                    lineHeight: 0.8
                    color: colorRef.D.ColorSelector.textColor
                }
            }
            //        Item {
            //            id: thirdPage
            //        }
        }

        // PageIndicator {
        //     id: indicator
        //     height: 2

        //     count: view.count
        //     currentIndex: view.currentIndex

        //     delegate: Component {
        //         Rectangle {
        //             height: 2
        //             width: 6
        //             color: indicator.currentIndex === index ? colorRef.D.ColorSelector.textColor : "transparent"
        //         }
        //     }

        //     anchors.bottom: parent.bottom
        //     anchors.horizontalCenter: parent.horizontalCenter
        // }
        
        onXChanged: updatePopupPos()
        onYChanged: updatePopupPos()
        Timer {
            id: toolTipShowTimer
            interval: 50
            onTriggered: {
                var point = Applet.rootObject.mapToItem(null, Applet.rootObject.width / 2, Applet.rootObject.height / 2)
                toolTip.DockPanelPositioner.bounding = Qt.rect(point.x, point.y, toolTip.width, toolTip.height)
                toolTip.open()
            }
        }
        TapHandler {
            acceptedButtons: Qt.LeftButton
            onTapped: {
                console.info('digitalwellbeing popup toggled',popupItem.popupVisible)
                if (!popupItem.popupVisible) {
                    popupItem.update()
                    popupItem.open()
                    var point = Applet.rootObject.mapToItem(null, Applet.rootObject.width / 2, Applet.rootObject.height / 2)
                    popupItem.DockPanelPositioner.bounding = Qt.rect(point.x, point.y, popupItem.width, popupItem.height)
                } else {
                    popupItem.close()
                }
                toolTip.close()
            }
        }
        HoverHandler {
            onHoveredChanged: {
                if (hovered) {
                    toolTipShowTimer.start()
                } else {
                    if (toolTipShowTimer.running) {
                        toolTipShowTimer.stop()
                    }

                    toolTip.close()
                }
            }
        }
    }
    AppletPopup {
        id: popupItem
        popupX: DockPanelPositioner.x
        popupY: DockPanelPositioner.y
    }
}
