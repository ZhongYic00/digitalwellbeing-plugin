// SPDX-FileCopyrightText: 2025 Yicheng Zhong <rubbishzyc@outlook.com>.
// SPDX-License-Identifier: MIT
import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    id: container
    property real cR // 半圆半径
    property string text: "<empty>"
    property int maxFontSize: 19
    property int minFontSize: 14
    property int currentFontSize: maxFontSize
    property var fontColor: 'black'

    width: 2 * cR
    height: cR
    // radius: cR
    clip: true

    // 字体大小调整逻辑
    property var lineWidths: []
    property var lines: []

    function calculateLineWidths(fontSize) {
        let metrics = Qt.createQmlObject('import QtQuick 2.15; TextMetrics{ text: "r" }', container)
        metrics.font.pixelSize = fontSize
        let lineHeight = metrics.height * 1.2
        console.log('lineHeight',lineHeight)
        let lineWidths = []
        for (let y = lineHeight; y <= cR; y += lineHeight) {
            let width = 2 * Math.sqrt(Math.pow(cR, 2) - Math.pow(cR - y, 2))
            lineWidths.push(width)
        }
        return lineWidths
    }

    function splitText(text, fontSize) {
        let metrics = Qt.createQmlObject('import QtQuick 2.15; TextMetrics{}', container)
        metrics.font.pixelSize = fontSize
        let words = text.split(' ')
        let lines = []
        let currentLine = ''
        
        for (let i = 0; i < words.length; i++) {
            let testLine = currentLine ? currentLine + ' ' + words[i] : words[i]
            metrics.text = testLine
            // 获取当前行号
            let lineIndex = lines.length
            let maxWidth = lineWidths[lineIndex] || lineWidths[lineWidths.length-1]
            
            if (metrics.width <= maxWidth) {
                currentLine = testLine
                // console.log('testLine',testLine)
            } else {
                // 处理中文：逐个字符拆分
                if (/[\u4e00-\u9fa5]/.test(words[i])) {
                    let chars = currentLine ? [currentLine, ...words[i].split('')] : [...words[i].split('')]
                    // console.log('chars:',chars)
                    currentLine = ''
                    for (let ch of chars) {
                        // console.log('ch=',ch)
                        metrics.text = currentLine + ch
                        if (metrics.width <= maxWidth) {
                            currentLine += ch
                        } else {
                            // console.log('lines.push',currentLine)
                            lines.push(currentLine)
                            currentLine = ch
                            lineIndex++
                            maxWidth = lineWidths[lineIndex] || lineWidths[lineWidths.length-1]
                        }
                    }
                } else {
                    lines.push(currentLine)
                    currentLine = words[i]
                }
            }
        }
        if (currentLine) lines.push(currentLine)
        metrics.destroy()
        return lines
    }

    function updateLayout() {
        for (let fontSize = maxFontSize; fontSize >= minFontSize; fontSize--) {
            lineWidths = calculateLineWidths(fontSize)
            console.log('linewidths',lineWidths)
            let tempLines = splitText(text, fontSize)
            console.log('font',fontSize,'lines',tempLines)
            if (tempLines.length <= lineWidths.length) {
                lines = tempLines
                currentFontSize = fontSize
                return
            }
        }
        // 使用最小字号并添加省略号
        lineWidths = calculateLineWidths(minFontSize)
        lines = splitText(text, minFontSize)
        if (lines.length > lineWidths.length) {
            lines = lines.slice(0, lineWidths.length)
            lines[lines.length-1] = lines[lines.length-1].slice(0, -3) + '...'
        }
        currentFontSize = minFontSize
    }

    Component.onCompleted: updateLayout()
    onTextChanged: {
        console.log('text changed!', text)
        updateLayout()
    }

    // 行布局
    Column {
        anchors.bottom: parent.bottom
        width: parent.width
        spacing: 0

        Repeater {
            model: container.lines
            delegate: Text {
                width: container.lineWidths[index] || container.lineWidths[container.lineWidths.length-1]
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                font.pixelSize: currentFontSize
                text: modelData
                anchors.horizontalCenter: parent.horizontalCenter
                lineHeight: 1.2
                color: container.fontColor
                // Rectangle {
                //     anchors.fill: parent
                //     color: 'transparent'
                //     border {
                //         width: 1
                //         color: 'red'
                //     }
                // }
            }
        }
    }
}