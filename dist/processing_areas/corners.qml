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

    property int minValue1: 1
    property int maxValue1: 30
    property int startValue1: 1

    property int minValue2: 1
    property int maxValue2: 31
    property int startValue2: 1

    property real minValue3: 0.01
    property real maxValue3: 1
    property real startValue3: 0.01

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

        Text {
            id: value_area_text1
            x: 9
            y: 84
            width: 50
            height: 18
            text: "blockSize"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }

        Slider {
            id: slider1
            x: 111
            y: 78
            width: 140
            height: 30
            from: minValue1
            to: maxValue1
            value: startValue1
            stepSize: 1
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
            onClicked: slider1.value -= 2
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
            onClicked: slider1.value += 2
        }

        Button {
            id: rstValueArea1
            width: 41
            height: 27
            anchors.left: ttext1.right
            anchors.leftMargin: 15
            anchors.bottom: button_Plus1.bottom
            text: qsTr("Rst")
            anchors.bottomMargin: 1
            scale: 1.1
            onClicked: slider1.value = startValue1
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
            font.pixelSize: 14

            onTextChanged: {
                val[0] = slider1.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        Text {
            id: value_area_text2
            x: 9
            y: 113
            width: 50
            height: 18
            text: "kSize"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }

        Slider {
            id: slider2
            x: 111
            y: 107
            width: 140
            height: 30
            anchors.verticalCenterOffset: 0
            from: minValue2
            to: maxValue2
            value: startValue2
            stepSize: 2
        }

        RoundButton {
            id: button_Minus2
            anchors.right: slider2.left
            anchors.rightMargin: 5
            anchors.top: slider2.top
            anchors.bottom: slider2.bottom
            width: height
            radius: 10
            text: qsTr("-")
            highlighted: true
            enabled: slider2.value !== slider2.from
            onClicked: slider2.value -= 2
        }

        RoundButton {
            id: button_Plus2
            anchors.left: slider2.right
            anchors.leftMargin: 5
            anchors.top: slider2.top
            anchors.bottom: slider2.bottom
            width: height
            radius: 10
            text: qsTr("+")
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            enabled: slider2.value !== slider2.to
            highlighted: true
            onClicked: slider2.value += 2
        }

        Button {
            id: rstValueArea2
            width: 41
            height: 27
            anchors.left: ttext2.right
            anchors.leftMargin: 15
            anchors.bottom: button_Plus2.bottom
            text: qsTr("Rst")
            anchors.bottomMargin: 1
            scale: 1.1
            onClicked: slider2.value = startValue2
        }

        Text {
            id: ttext2
            width: 16
            height: 15
            anchors.left: button_Plus2.right
            anchors.bottom: button_Plus2.bottom
            anchors.top: button_Plus2.top
            anchors.leftMargin: 15
            text: (slider2.value).toFixed(2)
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
            x: 111
            y: 136
            width: 140
            height: 30
            from: minValue3
            to: maxValue3
            value: startValue3
            stepSize: 0.01
        }

        RoundButton {
            id: button_Minus3
            width: height
            radius: 10
            text: qsTr("-")
            highlighted: true
            anchors.top: slider3.top
            anchors.bottom: slider3.bottom
            enabled: slider3.value !== slider3.from
            anchors.right: slider3.left
            anchors.rightMargin: 5
            onClicked: slider3.value -= 1
        }

        RoundButton {
            id: button_Plus3
            width: height
            radius: 10
            text: qsTr("+")
            anchors.left: slider3.right
            highlighted: true
            anchors.top: slider3.top
            anchors.bottom: slider3.bottom
            anchors.leftMargin: 5
            enabled: slider3.value !== slider3.to
            onClicked: slider3.value += 1
        }

        Button {
            id: rstValueArea3
            width: 41
            height: 27
            text: qsTr("Rst")
            anchors.left: ttext3.right
            anchors.bottomMargin: 1
            anchors.bottom: button_Plus3.bottom
            anchors.leftMargin: 15
            scale: 1.1

            onClicked: slider3.value = startValue3
        }

        Text {
            id: ttext3
            width: 16
            height: 15
            text: (slider3.value).toFixed(2)
            anchors.left: button_Plus3.right
            font.pixelSize: 14
            anchors.bottom: button_Plus3.bottom
            anchors.top: button_Plus3.top
            anchors.leftMargin: 15
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            onTextChanged: {
                val[2] = slider3.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        Text {
            id: value_area_text3
            x: 9
            y: 141
            width: 50
            height: 18
            text: "k"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }
    }
}




