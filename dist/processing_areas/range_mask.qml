import QtQuick 2.14
import QtQuick.Controls 2.13

Rectangle {
    id: area
    color: "#00ffffff"
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 394
    height: 300

    property string name: ""
    property string func: ""

    property int minValue1: 0
    property int maxValue1: 255
    property int startValue1: 0

    property int minValue2: 0
    property int maxValue2: 255
    property int startValue2: 0

    property int minValue3: 0
    property int maxValue3: 255
    property int startValue3: 0

    property int minValue4: 0
    property int maxValue4: 255
    property int startValue4: 255

    property int minValue5: 0
    property int maxValue5: 255
    property int startValue5: 255

    property int minValue6: 0
    property int maxValue6: 255
    property int startValue6: 255

    property var val: [startValue1, startValue2, startValue3, startValue4, startValue5, startValue6]

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

        Text {
            id: area_name
            x: 9
            y: 10
            width: 159
            height: 18
            text: name
            font.pixelSize: 15
        }

        Slider {
            id: slider1
            x: 31
            y: 77
            width: 140
            height: 30
            from: minValue1
            to: maxValue1
            value: startValue1
            stepSize: 1
        }

        Text {
            id: ttext1
            x: 177
            y: 77
            width: 16
            height: 30
            text: slider1.value
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14

            onTextChanged: {
                val[0] = slider1.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        Slider {
            id: slider2
            x: 31
            y: 105
            width: 140
            height: 30
            anchors.verticalCenterOffset: 0
            from: minValue2
            to: maxValue2
            value: startValue2
            stepSize: 1
        }

        Text {
            id: ttext2
            x: 177
            y: 105
            width: 16
            height: 30
            text: slider2.value
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14

            onTextChanged: {
                val[1] = slider2.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        Slider {
            id: slider3
            x: 31
            y: 132
            width: 140
            height: 30
            from: minValue3
            to: maxValue3
            value: startValue3
            stepSize: 1
        }

        Text {
            id: ttext3
            x: 177
            y: 132
            width: 16
            height: 30
            text: slider3.value
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            onTextChanged: {
                val[2] = slider3.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        Slider {
            id: slider4
            x: 221
            y: 77
            width: 140
            height: 30
            value: startValue4
            to: maxValue4
            from: minValue4
            stepSize: 1
        }

        Text {
            id: ttext4
            x: 367
            y: 77
            width: 16
            height: 30
            text: slider4.value
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 14

            onTextChanged: {
                val[3] = slider4.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        Slider {
            id: slider5
            x: 221
            y: 105
            width: 140
            height: 30
            anchors.verticalCenterOffset: 0
            value: startValue5
            to: maxValue5
            from: minValue5
            stepSize: 1
        }

        Text {
            id: ttext5
            x: 367
            y: 105
            width: 16
            height: 30
            text: slider5.value
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 14

            onTextChanged: {
                val[4] = slider5.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        Slider {
            id: slider6
            x: 221
            y: 132
            width: 140
            height: 30
            value: startValue6
            to: maxValue6
            from: minValue6
            stepSize: 1
        }

        Text {
            id: ttext6
            x: 367
            y: 132
            width: 16
            height: 30
            text: slider6.value
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 14

            onTextChanged: {
                val[5] = slider6.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        Text {
            id: ttextB
            x: 9
            y: 77
            width: 16
            height: 30
            text: "B"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 14
        }

        Text {
            id: ttextG
            x: 9
            y: 105
            width: 16
            height: 30
            text: "G"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.topMargin: 0
            font.pixelSize: 14
        }

        Text {
            id: ttextR
            x: 9
            y: 132
            width: 16
            height: 30
            text: "R"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 14
        }
    }
}
