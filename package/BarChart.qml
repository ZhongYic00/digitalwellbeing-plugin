import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15
import QtQuick.Layouts 1.12
import "utils.js" as U

import "Chart.js" as Chart

Chart {
    id: root
    chartType: 'bar'
    chartOptions: ({
        maintainAspectRatio: false,
        title: {
            display: true,
            text: 'Chart.js Bar Chart - Stacked'
        },
        tooltips: {
            mode: 'index',
            intersect: false,
            callbacks: {
                label: function(ctx) {
                    console.log(JSON.stringify(ctx))
                    return ctx.yLabel.toFixed(2) + ' min'; // Format tooltip
                }
            }
        },
        responsive: true,
        scales: {
            xAxes: [{
                stacked: true,
            }],
            yAxes: [{
                stacked: true,
                min: 0,
                max: 60,
                ticks: {
                    callback: function(value) {
                        return value + ' min'; // Custom label format
                    }
                }
            }]
        },
        legend: {
            labels: {
                filter: (legendItem, chartData) => {
                    const topK = 5
                    // Logic to determine if the dataset is in the top K
                    const datasetIndex = legendItem.datasetIndex;
                    const datasetData = chartData.datasets[datasetIndex].data;
                    const total = datasetData.reduce((a, b) => a + b, 0); // Example logic: sum of data
                    
                    // Sort datasets by total and get the top K
                    const sortedDatasets = chartData.datasets
                        .map((dataset, index) => ({ index, total: dataset.data.reduce((a, b) => a + b, 0) }))
                        .sort((a, b) => b.total - a.total)
                        .slice(0, topK)
                        .map(item => item.index);
                    
                    return sortedDatasets.includes(datasetIndex);
                }
            }
        }
    })
    animationEasingType: Easing.Linear
    animationDuration: 200

    function update(events) {
        let datasets=[]
        const xlabels = U.range(0, 24)
        let apps = new Map()
        let summary = events
            .reduce((prev, cur) => {
            cur.tsoff < 0 ? cur.tsoff = 0 : 0
            apps.set(cur.id, [])
            while (cur.tsoff >= prev.length * 3600)
                prev.push({})
            let till = cur.tsoff
            while (cur.teoff > prev.length * 3600) {
                let hourend = prev.length * 3600
                if (!prev[prev.length - 1][cur.id])
                prev[prev.length - 1][cur.id] = 0
                prev[prev.length - 1][cur.id] += hourend - till
                till = hourend
                prev.push({})
            }
            if (!prev[prev.length - 1][cur.id])
            prev[prev.length - 1][cur.id] = 0
            prev[prev.length - 1][cur.id] += cur.teoff - till
            return prev
        }, [])
        while (summary.length < 24)
            summary.push({})
        U.initColor(apps.size)
        for (const [app, datas] of apps.entries()) {
            if (app != "dde-lock")
                datasets.push({
                    label: app,
                    data: xlabels.map(i => summary[i][app] / 60 || 0),
                    backgroundColor: U.nextColor(),
                    borderWidth: 2,
                    // borderSkipped: false,
                })
        }
        console.log(JSON.stringify(apps))
        chartData = {
            labels: xlabels,
            datasets: datasets,
        }
        console.log(JSON.stringify(chartData))
    }
}
