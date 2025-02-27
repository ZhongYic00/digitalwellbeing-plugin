// SPDX-FileCopyrightText: 2025 Yicheng Zhong <rubbishzyc@outlook.com>.
// SPDX-License-Identifier: MIT
import QtQuick 2.15
import QtQuick.Controls 2.15

import org.deepin.ds 1.0
import org.deepin.dtk 1.0 as D
import org.deepin.ds.dock 1.0

import "utils.js" as U

Column {
    id: list
    property var listmodel: ListModel {}
    topPadding: 5
    bottomPadding: 15
    property bool folded: false
    property bool foldable: false
    onImplicitHeightChanged: foldable = foldable || implicitHeight > 250
    onHeightChanged: console.log('usageranking', height, implicitHeight)
    Column {
        height: list.folded ? 200 : implicitHeight
        clip: true
        Repeater {
            Component.onCompleted: console.log('list', listmodel.count)
            model: listmodel
            delegate: Rectangle {
                width: list.width
                height: 20
                radius: 5
                color: "transparent"
                HoverHandler {
                    onHoveredChanged: parent.color = hovered ? Qt.rgba(
                                                                   1, 1, 1,
                                                                   0.2) : "transparent"
                }
                D.DciIcon {
                    id: appicon
                    name: icon
                    // scale: Panel.rootObject.dockItemMaxSize * 9 / 14 / parent.height
                    // // 9:14 (iconSize/dockHeight)
                    sourceSize: Qt.size(parent.height, parent.height)
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                }

                Text {
                    text: name
                    anchors.left: appicon.right
                    anchors.leftMargin: 5
                    elide: Text.ElideRight
                    color: foldBtn.D.ColorSelector.textColor
                }
                Text {
                    text: stat
                    font.weight: Font.Thin
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    color: foldBtn.D.ColorSelector.textColor
                }
            }
        }
    }
    Button {
        id: foldBtn
        flat: true
        height: 20
        width: list.width
        visible: list.foldable
        icon.source: list.folded ? "image://fromtheme/arrow-down-dark" : "image://fromtheme/arrow-up-dark"
        icon.color: "black"
        onClicked: {
            list.folded = !list.folded
            console.log('tapped', list.height, list.implicitHeight)
        }
    }
}
