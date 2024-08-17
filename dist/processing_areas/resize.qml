import QtQuick 2.14
import QtQuick.Controls 2.14

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

    property int change: 0

    property int startValue1: if (listView.currentIndex === 0) sizes[0][1]; else sizes[listView.currentIndex - 1][1] // width
    property int startValue2: if (listView.currentIndex === 0) sizes[0][0]; else sizes[listView.currentIndex - 1][0] // height

    property string func: ""
    property var val: [startValue1, startValue2]

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
            id: widthText
            x: 15
            y: 42
            width: 30
            height: 14
            text: qsTr("Ширина")
            font.pixelSize: 12
        }

        TextField {
            id: widthInput
            x: 15
            y: 63
            width: 75
            height: 43
            text: startValue1
            font.pixelSize: 12
            onTextChanged: {
                if (text > 1) {
                    startValue1 = text
                }

                if (change === 0) {
                    changes()
                    set_image(listView.currentIndex)
                }
            }
        }

        Text {
            id: heightText
            x: 107
            y: 43
            width: 30
            height: 14
            text: qsTr("Высота")
            font.pixelSize: 12
        }

        TextField {
            id: heightInput
            x: 107
            y: 63
            width: 75
            height: 43
            text: startValue2
            font.pixelSize: 12
            onTextChanged: {
                if (text > 1) {
                    startValue2 = text
                }

                if (change === 0) {
                    changes()
                    set_image(listView.currentIndex)
                }
            }
        }

        Button {
            id: rstValueArea1
            x: 227
            y: 71
            width: 41
            height: 27
            text: qsTr("Rst")
            scale: 1.1

            onClicked: {
                widthInput.text = start_width
                heightInput.text = start_height
            }
        }

        RoundButton {
            id: roundButton
            x: 279
            y: 129
            text: "x2"
            highlighted: true
            onClicked: {
                change = 1
                widthInput.text = (widthInput.text * 2).toFixed(0)
                heightInput.text = (heightInput.text * 2).toFixed(0)
                changes()
                set_image(listView.currentIndex)
                change = 0
            }
        }

        RoundButton {
            id: roundButton1
            x: 332
            y: 129
            text: "1/2"
            highlighted: true
            onClicked: {
                change = 1
                if (widthInput.text > 3 && heightInput.text > 3) {
                    widthInput.text = (widthInput.text / 2).toFixed(0)
                    heightInput.text = (heightInput.text / 2).toFixed(0)
                }
                else {
                    widthInput.text = 2
                    heightInput.text = 2
                }
                changes()
                set_image(listView.currentIndex)
                change = 0
            }
        }
    }
}




