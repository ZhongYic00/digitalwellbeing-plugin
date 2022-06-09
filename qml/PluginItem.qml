import QtQuick 2.15
import QtQuick.Controls 2.15
import "utils.js" as U

Item {
    implicitWidth: 90
    implicitHeight: 40
    id: root
    property var stats: JSON.parse(BasicStat)
    Timer {
        id: pageSwipeTimer
        interval: 15000
        repeat: true
        running: true
        onTriggered: view.currentIndex = (view.currentIndex + 1) % view.count
    }
    onStatsChanged: console.warn('stats changed', JSON.stringify(stats))
    function update() {
        let basicStat = JSON.parse(basicStat_)
        stats = {
            "totalTime": basicStat.totalTime,
            "longestUsedApp": basicStat.longestUsedApp
        }
    }
    SwipeView {
        id: view

        currentIndex: 0
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter

        Column {
            id: firstPage
            spacing: 0
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: -5
                text: U.getTimeString(stats.totalTime)
                font.pointSize: 11
                lineHeight: 0.8
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Screen Time")
                font.pointSize: 8
                lineHeight: 0.8
            }
        }
        Column {
            id: secondPage
            spacing: 0
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: -5
                width: root.width
                elide: Text.ElideMiddle
                horizontalAlignment: Text.AlignHCenter
                text: stats.longestUsedApp || ''
                font.pointSize: 11
                lineHeight: 0.8
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Longest Used")
                font.pointSize: 8
                lineHeight: 0.8
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
