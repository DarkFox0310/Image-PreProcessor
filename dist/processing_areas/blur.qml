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
    property int maxValue1: 63
    property int startValue1: 3

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

        Text {
            id: area_name
            x: 9
            y: 10
            width: 159
            height: 18
            text: name
            font.pixelSize: 15
        }

        RoundButton {
            id: button_Minus1
            anchors.left: area_name.left
            anchors.top: area_name.bottom
            anchors.topMargin: 10
            height: 30
            width: height
            radius: 10
            text: qsTr("-")
            enabled: false
            highlighted: true
            onClicked: {
                val[0] -= 2
                ttext1.text = val[0]

                if (val[0] === minValue1) enabled = false

                button_Plus1.enabled = true
            }
        }

        Text {
            id: ttext1
            anchors.left: button_Minus1.right
            anchors.top: button_Minus1.top
            anchors.bottom: button_Minus1.bottom
            anchors.leftMargin: 15
            text: startValue1
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12

            onTextChanged: {
                changes()
                set_image(listView.currentIndex)
            }
        }

        RoundButton {
            id: button_Plus1
            anchors.left: ttext1.right
            anchors.top: ttext1.top
            anchors.bottom: ttext1.bottom
            anchors.leftMargin: 15
            width: height
            radius: 10
            text: qsTr("+")
            enabled: true
            highlighted: true
            onClicked: {
                val[0] += 2
                ttext1.text = val[0]

                if (val[0] === maxValue1) enabled = false

                button_Minus1.enabled = true
            }
        }
    }
}


