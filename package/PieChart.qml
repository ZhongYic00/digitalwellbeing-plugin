import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15
import QtQuick.Layouts 1.12

import org.deepin.dtk 1.0 as D

import "utils.js" as U


ChartView {
    id: root
    //    property var pieSeries: pieSeries
    property var update: records => {
                             pieSeries.clear()
                             U.initColor()
                             records.forEach(record => {
                                                 pieSeries.append(
                                                     record.name,
                                                     record.time).color = U.nextColor()
                                             })
                         }

    theme: ChartView.ChartThemeLight
    antialiasing: true
    legend.visible: false

    //    backgroundColor: Qt.rgba(1, 1, 1, 0.2)
    backgroundColor: "transparent"
    plotAreaColor: "transparent"
    onHeightChanged: console.log('piechart', height, implicitHeight)

    PieSeries {
        size: 0.85
        holeSize: 0.75
        id: pieSeries
        endAngle: 0

        PropertyAnimation on endAngle {
            id: anim
            from: 0
            to: 360
            easing.type: Easing.Bezier
            duration: 500
            running: true
        }
        property var curSlice: null
        onClicked: slice => {
                       //                                       console.log('clicked', slice)
                       if (curSlice)
                       curSlice.exploded = curSlice.labelVisible = false
                       if (curSlice !== slice) {
                           slice.exploded = true
                           curSlice = slice
                       } else {
                           curSlice = null
                       }
                   }
    }

    Column {
        x: 0
        y: (parent.height - height) / 2
        width: parent.width
        property real holeWidth: width * 0.6
        Component.onCompleted: console.log(parent.width, width, height, x, y)
        SemicircleText {
            text: pieSeries.curSlice ? pieSeries.curSlice.label : "Today"
            cR: parent.holeWidth / 2
            anchors.horizontalCenter: parent.horizontalCenter
            maxFontSize: 26
            fontColor: D.ColorSelector.textColor
        }

        Column {
            width: parent.width
            height: parent.holeWidth / 2
            Text {
                text: U.getTimeString(
                        pieSeries.curSlice ? pieSeries.curSlice.value : pieSeries.sum)
                anchors.horizontalCenter: parent.horizontalCenter
                color: "black"
                font.pointSize: 18
            }
            Text {
                text: pieSeries.curSlice ? U.getPercent(
                                            pieSeries.curSlice.value / pieSeries.sum) : ''
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        
        //                Rectangle {
        //                    width: parent.width * 0.6
        //                    height: 10
        //                    color: "red"
        //                    anchors.horizontalCenter: parent.horizontalCenter
        //                }
    }
}
