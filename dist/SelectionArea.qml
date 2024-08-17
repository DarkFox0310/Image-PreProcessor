import QtQuick 2.9
import QtQuick.Controls 2.13

Rectangle {
    id: rectSelectionArea
    width: 149
    height: 95
    x: 38
    y: 27
    z: 2
    color: "#00ffffff"
    objectName: "rectSelectionArea"
    transformOrigin: Item.Center
    border.color: "#ffe14c"
    border.width: 4
    visible: enabled
    enabled: false

    property var vMouseStart: Qt.vector2d(0, 0)
    property var pMouseStart: Qt.point(0, 0)

    property real angle: 0
    property real centerX: 0
    property real centerY: 0
    property real lleft: 0
    property real ttop: 0
    property real rright: 0
    property real bbottom: 0
    property real newcenterX: 0
    property real newcenterY: 0
    property real xX: 0
    property real yY: 0
    property var delta: Qt.point(0,0)

    function rectTransformOriginCenter() {
        angle = rectSelectionArea.rotation * Math.PI / 180

        centerX = (rectSelectionArea.x + rectSelectionArea.width / 2)
        centerY = (rectSelectionArea.y + rectSelectionArea.height / 2)

        lleft = ((rectSelectionArea.x - centerX) * Math.cos(angle) - (rectSelectionArea.y - centerY) * Math.sin(angle) + centerX)
        ttop = ((rectSelectionArea.x - centerX) * Math.sin(angle) + (rectSelectionArea.y - centerY) * Math.cos(angle) + centerY)
        rright = ((rectSelectionArea.x + rectSelectionArea.width - centerX) * Math.cos(angle) - (rectSelectionArea.y + rectSelectionArea.height - centerY)
                  * Math.sin(angle) + centerX)
        bbottom = ((rectSelectionArea.x + rectSelectionArea.width - centerX) * Math.sin(angle) + (rectSelectionArea.y + rectSelectionArea.height - centerY)
                   * Math.cos(angle) + centerY)

        newcenterX = (lleft + rright) / 2
        newcenterY = (ttop + bbottom) / 2

        if (rectSelectionArea.transformOrigin === Item.BottomLeft) {
            rectSelectionArea.transformOrigin = Item.Center

            xX = (lleft - rectSelectionArea.x - rectSelectionArea.height * Math.sin(angle))
            yY = (rectSelectionArea.y - ttop - rectSelectionArea.width * Math.sin(angle))

            rectSelectionArea.x -= xX
            rectSelectionArea.y -= yY
        }

        if (rectSelectionArea.transformOrigin === Item.TopRight) {
            rectSelectionArea.transformOrigin = Item.Center

            xX = (lleft - rectSelectionArea.x - rectSelectionArea.height * Math.sin(angle))
            yY = (rectSelectionArea.y - ttop - rectSelectionArea.width * Math.sin(angle))

            rectSelectionArea.x += xX
            rectSelectionArea.y += yY
        }

        if (rectSelectionArea.transformOrigin === Item.BottomRight) {
            rectSelectionArea.transformOrigin = Item.Center

            xX = lleft
            yY = ttop

            rectSelectionArea.x = xX
            rectSelectionArea.y = yY
        }

        if (rectSelectionArea.transformOrigin === Item.TopLeft) {
            rectSelectionArea.transformOrigin = Item.Center

            xX = lleft - rectSelectionArea.x
            yY = ttop - rectSelectionArea.y

            rectSelectionArea.x -= xX
            rectSelectionArea.y -= yY
        }
    }

    function rectTransformOrigin(origin) {
        angle = rectSelectionArea.rotation * Math.PI / 180

        centerX = (rectSelectionArea.x + rectSelectionArea.width / 2)
        centerY = (rectSelectionArea.y + rectSelectionArea.height / 2)

        lleft = ((rectSelectionArea.x - centerX) * Math.cos(angle) - (rectSelectionArea.y - centerY) * Math.sin(angle) + centerX)
        ttop = ((rectSelectionArea.x - centerX) * Math.sin(angle) + (rectSelectionArea.y - centerY) * Math.cos(angle) + centerY)
        rright = ((rectSelectionArea.x + rectSelectionArea.width - centerX) * Math.cos(angle) - (rectSelectionArea.y + rectSelectionArea.height - centerY)
                  * Math.sin(angle) + centerX)
        bbottom = ((rectSelectionArea.x + rectSelectionArea.width - centerX) * Math.sin(angle) + (rectSelectionArea.y + rectSelectionArea.height - centerY)
                   * Math.cos(angle) + centerY)

        newcenterX = (lleft + rright) / 2
        newcenterY = (ttop + bbottom) / 2

        if (origin === 1) {
            rectSelectionArea.transformOrigin = Item.TopLeft

            xX = lleft
            yY = ttop

            rectSelectionArea.x = xX
            rectSelectionArea.y = yY
        }

        if (origin === 2) {
            rectSelectionArea.transformOrigin = Item.BottomRight

            xX = lleft - rectSelectionArea.x
            yY = ttop - rectSelectionArea.y

            rectSelectionArea.x -= xX
            rectSelectionArea.y -= yY
        }

        if (origin === 3) {
            rectSelectionArea.transformOrigin = Item.BottomLeft

            xX = (lleft - rectSelectionArea.x - rectSelectionArea.height * Math.sin(angle))
            yY = (rectSelectionArea.y - ttop - rectSelectionArea.width * Math.sin(angle))

            rectSelectionArea.x += xX
            rectSelectionArea.y += yY
        }

        if (origin === 4) {
            rectSelectionArea.transformOrigin = Item.TopRight

            xX = (lleft - rectSelectionArea.x - rectSelectionArea.height * Math.sin(angle))
            yY = (rectSelectionArea.y - ttop - rectSelectionArea.width * Math.sin(angle))

            rectSelectionArea.x -= xX
            rectSelectionArea.y -= yY
        }
    }

    function resize(deltaXY, verticalMode, horizontalMode) {
        var deltaVertical, deltaHorizontal = 0

        if (verticalMode === 1) { //верх
            deltaVertical = Math.min(deltaXY.y, rectSelectionArea.height - 30)

            var oldHeight = rectSelectionArea.height
            rectSelectionArea.height -= deltaVertical
            rectSelectionArea.y -= rectSelectionArea.height - oldHeight
        }
        else if (verticalMode === 2) { //низ
            deltaVertical = Math.min(-deltaXY.y, rectSelectionArea.height - 30)

            rectSelectionArea.height -= deltaVertical
        }
        else {

        }

        if (horizontalMode === 1) { //лево
            deltaHorizontal = Math.min(deltaXY.x, rectSelectionArea.width - 50)

            var oldWidth = rectSelectionArea.width
            rectSelectionArea.width -= deltaHorizontal
            rectSelectionArea.x -= rectSelectionArea.width - oldWidth
        }
        else if (horizontalMode === 2) { //право
            deltaHorizontal = Math.min(-deltaXY.x, rectSelectionArea.width - 50)

            rectSelectionArea.width -= deltaHorizontal
        }
        else {

        }
    }

    MouseArea {
        id: mouseArea_rect
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.SizeAllCursor

        drag {
            target: parent
            minimumX: 0
            minimumY: 0
            maximumX: rectSelectionArea.parent.width - rectSelectionArea.width
            maximumY: rectSelectionArea.parent.height - rectSelectionArea.height
        }

        onReleased: {
            rectTransformOriginCenter()
            changes()
            set_image(listView.currentIndex)
        }
    }

    Rectangle {
        id: rect_Rotate
        x: 112
        y: 58
        width: 6
        height: 6
        color: "#000000"
        radius: 3
        visible: parent.visible
        border.color: "#ffffff"
        anchors.leftMargin: -6
        anchors.verticalCenter: rectangle.verticalCenter
        anchors.left: rectangle.left
        smooth: true

        MouseArea {
            id: mouseArea_Rotate
            anchors.fill: parent
            width: 6
            height: 6
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            drag {
                target: parent
                axis: Drag.XAndYAxis
            }

            onPressed: rectTransformOriginCenter()

            function rotateFun() {
                angle = rectSelectionArea.rotation * Math.PI / 180

                centerX = rectSelectionArea.x + rectSelectionArea.width / 2
                centerY = rectSelectionArea.y + rectSelectionArea.height / 2

                lleft = (rectSelectionArea.x - centerX) * Math.cos(angle) - (rectSelectionArea.y - centerY) * Math.sin(angle) + centerX
                ttop = (rectSelectionArea.x - centerX) * Math.sin(angle) + (rectSelectionArea.y - centerY) * Math.cos(angle) + centerY

                rright = (rectSelectionArea.x + rectSelectionArea.width - centerX) * Math.cos(angle) - (rectSelectionArea.y + rectSelectionArea.height
                                                                                                        - centerY) * Math.sin(angle) + centerX
                bbottom = (rectSelectionArea.x + rectSelectionArea.width - centerX) * Math.sin(angle) + (rectSelectionArea.y + rectSelectionArea.height
                                                                                                         - centerY) * Math.cos(angle) + centerY

                newcenterX = (lleft + rright) / 2
                newcenterY = (ttop + bbottom) / 2

                var point = mapToItem(mouseArea1, mouseX, mouseY)
                var diffX = (point.x - newcenterX)
                var diffY = -1 * (point.y - newcenterY)
                var rad = Math.atan(diffY / diffX)
                var deg = (rad * 180 / Math.PI)

                if (diffX > 0 && diffY > 0) {
                    rectSelectionArea.rotation = 360 - Math.abs(deg)
                }
                if (diffX > 0 && diffY < 0) {
                    rectSelectionArea.rotation = Math.abs(deg)
                }
                if (diffX < 0 && diffY > 0) {
                    rectSelectionArea.rotation = 180 + Math.abs(deg)
                }
                if (diffX < 0 && diffY < 0) {
                    rectSelectionArea.rotation = 180 - Math.abs(deg)
                }
            }

            onPressedChanged: {
                vMouseStart.x = mouseX
                vMouseStart.y = mouseY
            }

            onPositionChanged: if (drag.active) rotateFun()

            onReleased: {
                changes()
                set_image(listView.currentIndex)
            }
        }
    }

    Rectangle {
        id: rectangle
        x: 118
        y: 29
        width: 36
        height: parent.border.width
        color: parent.border.color
        border.color: parent.border.color
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        visible: parent.visible
    }

    Rectangle {
        id: rect_LeftBottom
        y: 195
        width: 5
        height: 5
        color: "#000000"
        anchors.leftMargin: 0
        border.color: "#ffffff"
        anchors.left: parent.left
        border.width: 1
        anchors.bottomMargin: 0
        anchors.bottom: parent.bottom
        visible: parent.visible

        MouseArea {
            id: mouseArea_LeftBottom
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.SizeBDiagCursor
            drag {
                target: parent
                axis: Drag.XandYAxis
            }

            onPressed: {
                pMouseStart = Qt.point(mouseX, mouseY)

                rectTransformOriginCenter()
                rectTransformOrigin(4)
            }

            onPositionChanged: {
                if (drag.active) {
                    delta = Qt.point(mouseX - pMouseStart.x, mouseY - pMouseStart.y)

                    resize(delta, 2, 1)
                }
            }

            onReleased: {
                rectTransformOriginCenter()
                changes()
                set_image(listView.currentIndex)
            }
        }
    }

    Rectangle {
        id: rect_LeftTop
        width: 5
        height: 5
        color: "#000000"
        anchors.leftMargin: 0
        border.color: "#ffffff"
        anchors.left: parent.left
        border.width: 1
        anchors.top: parent.top
        anchors.topMargin: 0
        visible: parent.visible

        MouseArea {
            id: mouseArea_LeftTop
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.SizeFDiagCursor
            drag {
                target: parent
                axis: Drag.XandYAxis
            }

            onPressed: {
                pMouseStart = Qt.point(mouseX, mouseY)

                rectTransformOriginCenter()
                rectTransformOrigin(2)
            }

            onPositionChanged: {
                if (drag.active) {
                    delta = Qt.point(mouseX - pMouseStart.x, mouseY - pMouseStart.y)

                    resize(delta, 1, 1)
                }
            }

            onReleased: {
                rectTransformOriginCenter()
                changes()
                set_image(listView.currentIndex)
            }
        }
    }

    Rectangle {
        id: rect_RightTop
        x: 200
        width: 5
        height: 5
        color: "#000000"
        anchors.right: parent.right
        border.color: "#ffffff"
        border.width: 1
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.rightMargin: 0
        visible: parent.visible

        MouseArea {
            id: mouseArea_RightTop
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.SizeBDiagCursor
            drag {
                target: parent
                axis: Drag.XandYAxis
            }

            onPressed: {
                pMouseStart = Qt.point(mouseX, mouseY)

                rectTransformOriginCenter()
                rectTransformOrigin(3)
            }

            onPositionChanged: {
                if (drag.active) {
                    delta = Qt.point(mouseX - pMouseStart.x, mouseY - pMouseStart.y)

                    resize(delta, 1, 2)
                }
            }

            onReleased: {
                rectTransformOriginCenter()
                changes()
                set_image(listView.currentIndex)
            }
        }
    }

    Rectangle {
        id: rect_RightBottom
        x: 200
        y: 199
        width: 5
        height: 5
        color: "#000000"
        anchors.right: parent.right
        border.color: "#ffffff"
        border.width: 1
        anchors.bottomMargin: 0
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        visible: parent.visible

        MouseArea {
            id: mouseArea_RightBottom
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.SizeFDiagCursor
            drag {
                target: parent
                axis: Drag.XandYAxis
            }

            onPressed: {
                pMouseStart = Qt.point(mouseX, mouseY)

                rectTransformOriginCenter()
                rectTransformOrigin(1)
            }

            onPositionChanged: {
                if (drag.active) {
                    delta = Qt.point(mouseX - pMouseStart.x, mouseY - pMouseStart.y)

                    resize(delta, 2, 2)
                }
            }

            onReleased: {
                rectTransformOriginCenter()
                changes()
                set_image(listView.currentIndex)
            }
        }
    }

    Rectangle {
        id: rect_MiddleTop
        x: 134
        width: 5
        height: 5
        color: "#000000"
        border.color: "#ffffff"
        border.width: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 0
        visible: parent.visible

        MouseArea {
            id: mouseArea_MiddleTop
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            drag {
                target: parent
                axis: Drag.YAxis
            }

            onPressed: {
                pMouseStart = Qt.point(mouseX, mouseY)

                rectTransformOriginCenter()
                rectTransformOrigin(2)
            }

            onPositionChanged: {
                if (drag.active) {
                    delta = Qt.point(mouseX - pMouseStart.x, mouseY - pMouseStart.y)

                    resize(delta, 1, 0)
                }
            }

            onReleased: {
                rectTransformOriginCenter()
                changes()
                set_image(listView.currentIndex)
            }
        }
    }

    Rectangle {
        id: rect_MiddleBottom
        x: 139
        y: 186
        width: 5
        height: 5
        color: "#000000"
        border.color: "#ffffff"
        border.width: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 0
        anchors.bottom: parent.bottom
        visible: parent.visible

        MouseArea {
            id: mouseArea_MiddleBottom
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.SizeVerCursor
            drag {
                target: parent
                axis: Drag.YAxis
            }

            onPressed: {
                pMouseStart = Qt.point(mouseX, mouseY)

                rectTransformOriginCenter()
                rectTransformOrigin(1)
            }

            onPositionChanged: {
                if (drag.active) {
                    delta = Qt.point(mouseX - pMouseStart.x, mouseY - pMouseStart.y)

                    resize(delta, 2, 0)
                }
            }

            onReleased: {
                rectTransformOriginCenter()
                changes()
                set_image(listView.currentIndex)
            }
        }
    }

    Rectangle {
        id: rect_LeftMiddle
        x: 9
        y: 90
        width: 5
        height: 5
        color: "#000000"
        anchors.leftMargin: 0
        border.color: "#ffffff"
        anchors.left: parent.left
        border.width: 1
        anchors.verticalCenter: parent.verticalCenter
        visible: parent.visible

        MouseArea {
            id: mouseArea_LeftMiddle
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.SizeHorCursor
            drag {
                target: parent
                axis: Drag.XAxis
            }

            onPressed: {
                pMouseStart = Qt.point(mouseX, mouseY)

                rectTransformOriginCenter()
                rectTransformOrigin(2)
            }

            onPositionChanged: {
                if (drag.active) {
                    delta = Qt.point(mouseX - pMouseStart.x, mouseY - pMouseStart.y)

                    resize(delta, 0, 1)
                }
            }

            onReleased: {
                rectTransformOriginCenter()
                changes()
                set_image(listView.currentIndex)
            }
        }
    }

    Rectangle {
        id: rect_RightMiddle
        x: 209
        y: 89
        width: 5
        height: 5
        color: "#000000"
        anchors.right: parent.right
        border.color: "#ffffff"
        border.width: 1
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 0
        visible: parent.visible

        MouseArea {
            id: mouseArea_RightMiddle
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            drag {
                target: parent
                axis: Drag.XAxis
            }

            onPressed: {
                pMouseStart = Qt.point(mouseX, mouseY)

                rectTransformOriginCenter()
                rectTransformOrigin(1)
            }

            onPositionChanged: {
                if (drag.active) {
                    delta = Qt.point(mouseX - pMouseStart.x, mouseY - pMouseStart.y)

                    resize(delta, 0, 2)
                }
            }

            onReleased: {
                rectTransformOriginCenter()
                changes()
                set_image(listView.currentIndex)
            }
        }
    }
}
