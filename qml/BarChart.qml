import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15
import QtQuick.Layouts 1.12
import "utils.js" as U

ChartView {
    id: root
    height: width
    property var update: events => {
                             let apps = {}
                             let summary = events.reduce((prev, cur) => {
                                                             cur.tsoff < 0 ? cur.tsoff = 0 : 0
                                                             apps[cur.id] = []
                                                             while (cur.tsoff >= prev.length * 3600)
                                                             prev.push({})
                                                             let till = cur.tsoff
                                                             while (cur.teoff
                                                                    > prev.length * 3600) {
                                                                 let hourend = prev.length * 3600
                                                                 if (!prev[prev.length - 1][cur.id])
                                                                 prev[prev.length - 1][cur.id] = 0
                                                                 prev[prev.length - 1][cur.id]
                                                                 += hourend - till
                                                                 till = hourend
                                                                 prev.push({})
                                                             }
                                                             if (!prev[prev.length - 1][cur.id])
                                                             prev[prev.length - 1][cur.id] = 0
                                                             prev[prev.length - 1][cur.id]
                                                             += cur.teoff - till
                                                             return prev
                                                         }, [])
                             while (summary.length < 24)
                             summary.push({})
                             //                             console.warn(JSON.stringify(summary))
                             let cnt = 0
                             for (let app in apps) {
                                 for (var i = 0; i < 24; i++)
                                 apps[app].push(summary[i][app] / 60 || 0)
                                 cnt++
                                 console.warn(apps[app])
                                 if (app != "dde-lock")
                                 barSeries.append(app, apps[app])
                             }
                             console.warn(JSON.stringify(apps))
                         }
    theme: ChartView.ChartThemeLight
    antialiasing: true
    legend.visible: false
    backgroundColor: "transparent"
    plotAreaColor: "transparent"
    onHeightChanged: console.warn('barchart', height, implicitHeight)

    StackedBarSeries {
        id: barSeries
        axisX: BarCategoryAxis {
            categories: (() => {
                             let rt = []
                             for (var i = 0; i < 24; i++)
                             rt.push(i)
                             return rt
                         })()
        }
        axisY: ValueAxis {
            id: axisy
            min: 0
            max: 60
            labelFormat: '%.0f min'
            onMaxChanged: console.warn('mxchanged', max)
        }

        //        BarSet {
        //            label: "Bob"
        //            values: [202, 2, 3, 4, 5, 6]
        //        }
        //        BarSet {
        //            label: "Susan"
        //            values: [5, 108, 2, 4, 1, 7]
        //        }
        //        BarSet {
        //            label: "James"
        //            values: [3, 5, 8, 13, 5, 8]
        //        }
    }
}
