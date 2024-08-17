import QtQuick 2.14
import QtQuick.Controls 2.13

Rectangle {
    id: area
    color: "#00ffffff"
    border.color: "#000000"
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 394
    height: 300

    property string name: ""
    property string func: ""

    property int startValue1: 0

    property var val: [startValue1]

    property var selection_area_enabled: false

    ScrollView {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 1
        height: area.parent.height

        contentHeight: area.height
        clip: true

        visible: true

        ScrollBar.vertical.policy: {
            if (contentHeight > height) ScrollBar.AlwaysOn
            else ScrollBar.AlwaysOff
        }
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        ComboBox {
            id: types
            x: 500
            width: 132
            height: 38
            anchors.leftMargin: 8
            font.pointSize: 12
            anchors.left: parent.left
            anchors.top: area_name.bottom
            anchors.topMargin: 6
            currentIndex: startValue1
            model: ["Синий", "Зеленый", "Красный"]
            onCurrentIndexChanged: {
                val[0] = currentIndex
                changes()
                set_image(listView.currentIndex)
            }
        }

        Text {
            id: area_name
            x: 9
            y: 10
            width: 159
            height: 18
            text: name
            font.pixelSize: 15
        }
    }
}


