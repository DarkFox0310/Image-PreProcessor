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

    property string startValue1: "1"
    property string startValue2: "100"
    property string startValue3: "90"
    property string startValue4: "30"
    property string startValue5: "140"
    property string startValue6: "170"
    property string startValue7: "1"

    property var val: [startValue1, startValue2, startValue3, startValue4, startValue5, startValue6, startValue7]

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

        TextField {
            id: textInput
            x: 9
            y: 88
            width: 40
            height: 38
            text: startValue1
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            onTextChanged: {
                val[0] = text * 1.0
                changes()
                set_image(listView.currentIndex)
            }
        }

        TextField {
            id: textInput1
            x: 74
            y: 88
            width: 40
            height: 38
            text: startValue2
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            onTextChanged: {
                val[1] = text * 1.0
                changes()
                set_image(listView.currentIndex)
            }
        }

        TextField {
            id: textInput2
            x: 139
            y: 88
            width: 40
            height: 38
            text: startValue3
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            onTextChanged: {
                val[2] = text * 1.0
                changes()
                set_image(listView.currentIndex)
            }
        }

        TextField {
            id: textInput3
            x: 204
            y: 88
            width: 40
            height: 38
            text: startValue4
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            onTextChanged: {
                val[3] = text * 1.0
                changes()
                set_image(listView.currentIndex)
            }
        }

        TextField {
            id: textInput4
            x: 269
            y: 88
            width: 40
            height: 38
            text: startValue5
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            onTextChanged: {
                val[4] = text * 1
                changes()
                set_image(listView.currentIndex)
            }
        }

        TextField {
            id: textInput5
            x: 334
            y: 88
            width: 40
            height: 38
            text: startValue6
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            onTextChanged: {
                val[5] = text * 1
                changes()
                set_image(listView.currentIndex)
            }
        }

        TextField {
            id: textInput6
            x: 334
            y: 31
            width: 40
            height: 38
            text: startValue7
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            onTextChanged: {
                val[6] = text * 1
                changes()
                set_image(listView.currentIndex)
            }
        }

        Text {
            id: element
            x: 15
            y: 58
            text: qsTr("dp")
            font.pixelSize: 12
            anchors.bottom: textInput.top
            anchors.horizontalCenter: textInput.horizontalCenter
        }

        Text {
            id: element1
            x: 15
            y: 58
            text: qsTr("minDist")
            font.pixelSize: 12
            anchors.bottom: textInput1.top
            anchors.horizontalCenter: textInput1.horizontalCenter
        }

        Text {
            id: element2
            x: 15
            y: 58
            text: qsTr("param1")
            font.pixelSize: 12
            anchors.bottom: textInput2.top
            anchors.horizontalCenter: textInput2.horizontalCenter
        }

        Text {
            id: element3
            x: 15
            y: 58
            text: qsTr("param2")
            font.pixelSize: 12
            anchors.bottom: textInput3.top
            anchors.horizontalCenter: textInput3.horizontalCenter
        }

        Text {
            id: element4
            x: 15
            y: 58
            text: qsTr("minRadius")
            font.pixelSize: 12
            anchors.bottom: textInput4.top
            anchors.horizontalCenter: textInput4.horizontalCenter
        }

        Text {
            id: element5
            x: 15
            y: 58
            text: qsTr("maxRadius")
            font.pixelSize: 12
            anchors.bottom: textInput5.top
            anchors.horizontalCenter: textInput5.horizontalCenter
        }

        Text {
            id: element6
            x: 15
            y: 58
            text: qsTr("Толщина")
            font.pixelSize: 12
            anchors.bottom: textInput6.top
            anchors.horizontalCenter: textInput6.horizontalCenter
        }
    }
}




