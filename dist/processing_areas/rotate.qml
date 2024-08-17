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
//    height: 300

    property string name: ""

    property int startValue1: sizes[listView.currentIndex][1]
    property int startValue2: sizes[listView.currentIndex][0]

    property int minValue3: -360
    property int maxValue3: 360
    property int startValue3: 0

    property string func: ""
    property var val: [startValue1, startValue2, startValue3]

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
            anchors.left: parent.left
            anchors.top: area_name.bottom
            anchors.leftMargin: 50
            anchors.topMargin: 10
            width: 140
            height: 30
            from: minValue3
            to: maxValue3
            value: startValue3
            stepSize: 0.01
        }

        RoundButton {
            id: button_Minus1
            anchors.right: slider1.left
            anchors.rightMargin: 5
            anchors.top: slider1.top
            anchors.bottom: slider1.bottom
            width: height
            radius: 10
            text: qsTr("-")
            enabled: slider1.value !== slider1.from
            highlighted: true
            onClicked: slider1.value -= 10
        }

        RoundButton {
            id: button_Plus1
            anchors.left: slider1.right
            anchors.leftMargin: 5
            anchors.top: slider1.top
            anchors.bottom: slider1.bottom
            width: height
            radius: 10
            text: qsTr("+")
            enabled: slider1.value !== slider1.to
            highlighted: true
            onClicked: slider1.value += 10
        }

        Button {
            id: rstValueArea1
            width: 41
            height: 27
            anchors.left: ttext1.right
            anchors.leftMargin: 25
            anchors.bottom: button_Plus1.bottom
            text: qsTr("Rst")
            scale: 1.1
            onClicked: slider1.value = startValue3
        }

        Text {
            id: ttext1
            width: 16
            height: 15
            anchors.left: button_Plus1.right
            anchors.bottom: button_Plus1.bottom
            anchors.top: button_Plus1.top
            anchors.leftMargin: 15
            text: (slider1.value).toFixed(2)
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12

            onTextChanged: {
                val[2] = slider1.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        RoundButton {
            id: roundButton1
            x: 332
            y: 129
            text: "+90"
            highlighted: true
            enabled: slider1.value !== slider1.to
            onClicked: {
                if (slider1.value < 270) slider1.value += 90
                else slider1.value = 360
            }
        }

        RoundButton {
            id: roundButton2
            x: 282
            y: 129
            text: "-90"
            highlighted: true
            enabled: slider1.value !== slider1.from
            onClicked: {
                if (slider1.value >= -270) slider1.value -= 90
                else slider1.value = -360
            }
        }
    }
}




