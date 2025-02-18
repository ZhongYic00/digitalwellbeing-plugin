import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 400
    height: 200
    visible: true
    SemicircleText {
        text: "This is a sample text that needs to wrap aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa in a semicircle area. 这是一段需要在上半圆形区域显示的中英文混合文本。 "
        anchors.centerIn: parent
        cR: 120
    }
}