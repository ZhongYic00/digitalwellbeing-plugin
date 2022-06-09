import QtQuick 2.15
import QtQuick.Controls 2.15
import "utils.js" as U

Column {
    id: list
    property var listmodel: ListModel {}
    topPadding: 5
    bottomPadding: 15
    property bool folded: false
    property bool foldable: false
    onImplicitHeightChanged: foldable = foldable || implicitHeight > 250
    onHeightChanged: console.warn('usageranking', height, implicitHeight)
    Column {
        height: list.folded ? 200 : implicitHeight
        clip: true
        Repeater {
            Component.onCompleted: console.warn('list', listmodel.count)
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

                Image {
                    id: appicon
                    source: "image://fromtheme/" + icon
                    height: parent.height
                    width: height
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                }

                Text {
                    text: name
                    anchors.left: appicon.right
                    anchors.leftMargin: 5
                    elide: Text.ElideRight
                }
                Text {
                    text: stat
                    font.weight: Font.Thin
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                }
            }
        }
    }
    Button {
        flat: true
        height: 20
        width: list.width
        visible: list.foldable
        icon.source: list.folded ? "image://fromtheme/arrow-down-dark" : "image://fromtheme/arrow-up-dark"
        icon.color: "black"
        onClicked: {
            list.folded = !list.folded
            console.warn('tapped', list.height, list.implicitHeight)
        }
    }
}
