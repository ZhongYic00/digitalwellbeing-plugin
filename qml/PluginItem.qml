import QtQuick 2.15
import QtQuick.Controls 2.15
import "utils.js" as U
import singleton.dpalette 1.0

Item {
    implicitWidth: 90
    implicitHeight: 50
    id: root
    property var stats: JSON.parse(BasicStat)
    Timer {
        id: pageSwipeTimer
        interval: 15000
        repeat: true
        running: true
        onTriggered: view.currentIndex = (view.currentIndex + 1) % view.count
    }
    //    onStatsChanged: console.log('stats changed', JSON.stringify(stats))
    //    Component.onCompleted: console.warn('height', height, implicitHeight)
    function update() {
        let basicStat = JSON.parse(basicStat_)
        stats = {
            "totalTime": basicStat.totalTime,
            "longestUsedApp": basicStat.longestUsedApp
        }
    }

    //    Rectangle {
    //        anchors.fill: parent
    //        color: "red"
    //    }
    SwipeView {
        id: view

        currentIndex: 0
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        topPadding: 8

        Column {
            id: firstPage
            spacing: 0
            anchors.verticalCenter: parent.verticalCenter
            //            Component.onCompleted: console.warn(height, implicitHeight,
            //                                                anchors.topMargin,
            //                                                anchors.bottomMargin)
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: -5
                text: U.getTimeString(stats.totalTime)
                font.pointSize: 10
                lineHeight: 0.8
                color: DPalette.text
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Screen Time")
                font.pointSize: 8
                lineHeight: 0.8
                color: DPalette.text
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
                text: stats.longestUsedApp || '<unknown>'
                font.pointSize: 10
                lineHeight: 0.8
                color: DPalette.text
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Longest Used")
                font.pointSize: 8
                lineHeight: 0.8
                color: DPalette.text
            }
        }
        //        Item {
        //            id: thirdPage
        //        }
    }

    //    PageIndicator {
    //        id: indicator

    //        count: view.count
    //        currentIndex: view.currentIndex

    //        anchors.bottom: view.bottom
    //        anchors.horizontalCenter: parent.horizontalCenter
    //    }
}
