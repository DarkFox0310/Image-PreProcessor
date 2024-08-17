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

    property int minValue1: 0 // x
    property int startValue1: 0 // x

    property int minValue2: 0 // y
    property int startValue2: 0 // y

    property int minValue3: slider1.value + 2 // width
    property int maxValue3: if (listView.currentIndex === 0) sizes[0][1]; else sizes[listView.currentIndex - 1][1] // width
    property int startValue3: if (listView.currentIndex === 0) sizes[0][1]; else sizes[listView.currentIndex - 1][1] // width

    property int minValue4: slider2.value + 2 // height
    property int maxValue4: if (listView.currentIndex === 0) sizes[0][0]; else sizes[listView.currentIndex - 1][0] // height
    property int startValue4: if (listView.currentIndex === 0) sizes[0][0]; else sizes[listView.currentIndex - 1][0] // height

    property var val: [startValue1, startValue2, startValue3, startValue4]

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
            anchors.top: area_name.bottom
            anchors.left: area_name.left
            anchors.topMargin: 30
            width: 50
            height: 18
            text: "X"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }

        Slider {
            id: slider1
            x: 110
            anchors.left: value_area_text1.right
            anchors.verticalCenter: value_area_text1.verticalCenter
            anchors.leftMargin: 50
            width: 140
            height: 30
            from: minValue1
            to: maxValue3 - 2
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
            y: 54
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
            text: slider1.value
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14

            onTextChanged: {
                val[0] = slider1.value
                val[1] = slider2.value
                val[2] = slider3.value
                val[3] = slider4.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        Text {
            id: value_area_text2
            anchors.top: value_area_text1.bottom
            anchors.left: value_area_text1.left
            anchors.topMargin: 12
            width: 50
            height: 18
            text: "Y"
            anchors.leftMargin: 0
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }

        Slider {
            id: slider2
            anchors.left: value_area_text2.right
            anchors.verticalCenter: value_area_text2.verticalCenter
            anchors.leftMargin: 50
            width: 140
            height: 30
            anchors.verticalCenterOffset: 0
            from: minValue2
            to: maxValue4 - 2
            value: startValue2
            stepSize: 1
        }

        RoundButton {
            id: button_Minus2
            x: 74
            anchors.right: slider2.left
            anchors.rightMargin: 5
            anchors.top: slider2.top
            anchors.bottom: slider2.bottom
            width: height
            radius: 10
            text: qsTr("-")
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            highlighted: true
            enabled: slider2.value !== slider2.from
            onClicked: slider2.value -= 10
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
            onClicked: slider2.value += 10
        }

        Button {
            id: rstValueArea2
            y: 82
            width: 41
            height: 27
            anchors.left: ttext2.right
            anchors.leftMargin: 15
            anchors.bottom: button_Plus2.bottom
            text: qsTr("Rst")
            anchors.bottomMargin: 3
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
            text: slider2.value
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14

            onTextChanged: {
                val[0] = slider1.value
                val[1] = slider2.value
                val[2] = slider3.value
                val[3] = slider4.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        Text {
            id: value_area_text3
            anchors.top: value_area_text2.bottom
            anchors.left: value_area_text2.left
            anchors.topMargin: 30
            width: 50
            height: 18
            text: "Ширина"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }

        Slider {
            id: slider3
            anchors.left: value_area_text3.right
            anchors.verticalCenter: value_area_text3.verticalCenter
            anchors.leftMargin: 50
            width: 140
            height: 30
            anchors.verticalCenterOffset: 0
            from: minValue3
            to: maxValue3
            value: startValue3
            stepSize: 1
        }

        RoundButton {
            id: button_Minus3
            anchors.right: slider3.left
            anchors.rightMargin: 5
            anchors.top: slider3.top
            anchors.bottom: slider3.bottom
            width: height
            radius: 10
            text: qsTr("-")
            highlighted: true
            enabled: slider3.value !== slider3.from
            onClicked: slider3.value -= 10
        }

        RoundButton {
            id: button_Plus3
            anchors.left: slider3.right
            anchors.leftMargin: 6
            anchors.top: slider3.top
            anchors.bottom: slider3.bottom
            width: height
            radius: 10
            text: qsTr("+")
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            enabled: slider3.value !== slider3.to
            highlighted: true
            onClicked: slider3.value += 10
        }

        Button {
            id: rstValueArea3
            y: 82
            width: 41
            height: 27
            anchors.left: ttext3.right
            anchors.leftMargin: 15
            anchors.bottom: button_Plus3.bottom
            text: qsTr("Rst")
            anchors.bottomMargin: 3
            scale: 1.1
            onClicked: slider3.value = startValue3
        }

        Text {
            id: ttext3
            width: 16
            height: 15
            anchors.left: button_Plus3.right
            anchors.bottom: button_Plus3.bottom
            anchors.top: button_Plus3.top
            anchors.leftMargin: 15
            text: slider3.value
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14

            onTextChanged: {
                val[0] = slider1.value
                val[1] = slider2.value
                val[2] = slider3.value
                val[3] = slider4.value
                changes()
                set_image(listView.currentIndex)
            }
        }

        Text {
            id: value_area_text4
            anchors.top: value_area_text3.bottom
            anchors.left: value_area_text3.left
            anchors.topMargin: 12
            width: 50
            height: 18
            text: "Высота"
            anchors.leftMargin: 0
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }

        Slider {
            id: slider4
            anchors.left: value_area_text4.right
            anchors.verticalCenter: value_area_text4.verticalCenter
            anchors.leftMargin: 50
            width: 140
            height: 30
            anchors.verticalCenterOffset: 0
            from: minValue4
            to: maxValue4
            value: startValue4
            stepSize: 1
        }

        RoundButton {
            id: button_Minus4
            anchors.right: slider4.left
            anchors.rightMargin: 5
            anchors.top: slider4.top
            anchors.bottom: slider4.bottom
            width: height
            radius: 10
            text: qsTr("-")
            highlighted: true
            enabled: slider4.value !== slider4.from
            onClicked: slider4.value -= 10
        }

        RoundButton {
            id: button_Plus4
            anchors.left: slider4.right
            anchors.leftMargin: 6
            anchors.top: slider4.top
            anchors.bottom: slider4.bottom
            width: height
            radius: 10
            text: qsTr("+")
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            enabled: slider4.value !== slider4.to
            highlighted: true
            onClicked: slider4.value += 10
        }

        Button {
            id: rstValueArea4
            y: 82
            width: 41
            height: 27
            anchors.left: ttext4.right
            anchors.leftMargin: 15
            anchors.bottom: button_Plus4.bottom
            text: qsTr("Rst")
            anchors.bottomMargin: 3
            scale: 1.1
            onClicked: slider4.value = startValue4
        }

        Text {
            id: ttext4
            width: 16
            height: 15
            anchors.left: button_Plus4.right
            anchors.bottom: button_Plus4.bottom
            anchors.top: button_Plus4.top
            anchors.leftMargin: 15
            text: slider4.value
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14

            onTextChanged: {
                val[0] = slider1.value
                val[1] = slider2.value
                val[2] = slider3.value
                val[3] = slider4.value
                changes()
                set_image(listView.currentIndex)
            }
        }
    }
}




