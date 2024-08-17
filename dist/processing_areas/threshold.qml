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
    property int startValue2: 255

    property int startValue3: 0

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

        ComboBox {
            id: types
            x: 241
            width: 132
            height: 38
            font.pointSize: 12
            anchors.rightMargin: 21
            anchors.topMargin: 8
            anchors.top: parent.top
            anchors.right: parent.right
            model: ["Binary", "BinaryInv", "Trunc", "Tozero", "TozeroInv", "Mask", "Otsu", "Triangle"]
            currentIndex: startValue3
            onCurrentIndexChanged: {
                val[2] = currentIndex
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

        Text {
            id: value_area_text1
            anchors.top: area_name.bottom
            anchors.left: area_name.left
            anchors.topMargin: 30
            width: 50
            height: 18
            text: "thresh"
            font.pixelSize: 12
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
            text: "threshMax"
            anchors.leftMargin: 0
            font.pixelSize: 12
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
            to: maxValue2
            value: startValue2
            stepSize: 1
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
                val[1] = slider2.value
                changes()
                set_image(listView.currentIndex)
            }
        }
    }
}




