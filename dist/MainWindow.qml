import QtQuick 2.14
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.15
import Qt.labs.platform 1.0

Window {
    visible: true
    width: 1600
    height: 900
    color: "#00000000"
    id: mainWindow
    title: "MainWindow"
    minimumWidth: 900
    minimumHeight: 800

    property int start_width: 0
    property int start_height: 0

    property int image_width: start_width
    property int image_height: start_height

    property int resized_width: start_width
    property int resized_height: start_height

    property var sizes: [[start_width, start_height]]

    property var changes_area

    property var buttons_list: []
    property var buttons_list_image: []
    property var buttons_list_detector: []

    property var rectangles: [""]
    property var processing_areas: [""]
    property var types: [0]

    property var dataModel: []
    property var values: []
    property var rectangles_values: []

    property string path_to_functions: "processing_areas/"
    property string path_to_selection_area: "SelectionArea.qml"


    signal processing_values_changed(var index, var type, var func, var value, var x, var y, var width, var height, var rotation)

    signal append_signal()
    signal remove_signal(var index)

    signal open_image(var url)
    signal set_image(var index)

    signal save_image(var url)
    signal save_python(var index)

    signal swap_sizes_up(var index)
    signal swap_sizes_down(var index)

    signal open_project(var url)
    signal save_project(var url, var data)

    function create_area(name, func, selection_area_enabled, val) {
        listModel.append({txt: name + ". Изображение"})
        Qt.callLater(listView.positionViewAtEnd)

        createChanges(name, func, selection_area_enabled)
        createRectangle(selection_area_enabled)

        listView.currentIndex = listModel.count - 1
    }

    function createChanges(name, func, selection_area_enabled) {
        var url = path_to_functions + func + ".qml"

        var component = Qt.createComponent(url)

        if (component.status === Component.Ready) {
            var area = component.createObject(changes_area)

            area.name = name
            area.func = func
            area.selection_area_enabled = selection_area_enabled

            area.visible = false

            processing_areas.push(area)
        }
        else {
            area = Qt.createQmlObject(area_empty, changes_area)

            area.name = name
            area.func = func
            area.selection_area_enabled = selection_area_enabled

            processing_areas.push(area)
        }

        append_signal()
    }

    function deleteChanges() {
        var index = listView.currentIndex

        if (index !== 0) {
            if (types[index]) rectangles[index].destroy()

            rectangles.splice(index, 1)

            processing_areas[index].destroy()
            processing_areas.splice(index, 1)

            types.splice(index, 1)

            listModel.remove(index)
            listView.currentIndex -= 1
            processing_areas[index - 1].visible = true

            remove_signal(index)
        }
    }

    function changes() {
        var xx
        var yy
        var wwidth
        var hheight
        var rrotation

        for (var i = listView.currentIndex; i < listView.count; i++) {
            try {
                if (types[i] === 0) {
                    xx = 0
                    yy = 0
                    wwidth = sizes[i][1]
                    hheight = sizes[i][0]
                    rrotation = 0
                }
                else {
                    xx = rectangles[i].x
                    yy = rectangles[i].y
                    wwidth = rectangles[i].width
                    hheight = rectangles[i].height
                    rrotation = rectangles[i].rotation
                }

                processing_values_changed(i, types[i], processing_areas[i].func, processing_areas[i].val,
                                     xx, yy, wwidth, hheight, rrotation)
            }
            catch(error) {}
        }
    }

    function selectRectangle(i) {
        var id = i

        for (i = 1; i < rectangles.length; ++i) {
            rectangles[i].enabled = false
        }

        if (types[listView.currentIndex] === 1) {
            rectangles[id].enabled = true
        }
    }

    function createRectangle(mode) {
        if (mode === false) rectangles.push("")
        else if (mode === true) {
            var url = path_to_selection_area

            var component = Qt.createComponent(url)

            if (component.status === Component.Ready) {
                var rectangle = component.createObject(imageBox_1)

                rectangles.push(rectangle)
            }
        }
    }

    Rectangle {
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#eefaff"
            }

            GradientStop {
                position: 1
                color: "#c4ceff"
            }
        }
        anchors.fill: parent
        z: -1


        Image {
            anchors.fill: parent
//            source: "./images/background.png"
        }
    }

    MenuBar {
        Menu {
            title: qsTr("Файл")

            MenuItem {
                text: qsTr("Открыть проект")
                onTriggered: openDialog_Project.open()
            }

            MenuItem {
                text: qsTr("Сохранить проект")
                enabled: listView.count > 0
                onTriggered: saveDialog_Project.open()
            }

            MenuSeparator { }

            MenuItem {
                text: qsTr("Закрыть")
                onTriggered: mainWindow.close()
            }
        }

        FileDialog {
            id: openDialog_Project
            title: "Открыть проект..."
            nameFilters: ["XML (*.xml)"]

            onAccepted: {
                try {
                    listView.currentIndex = 0
                    open_project(openDialog_Project.currentFile.toString().replace("file:///", ""))
                }
                catch(error) {}

            }

            onRejected: console.log("Проект не был выбран")
        }

        FileDialog {
            id: saveDialog_Project
            title: "Сохранить проект..."
            fileMode: FileDialog.SaveFile
            nameFilters: ["XML (*.xml)"]

            onAccepted: {
                var funcs = []
                var rects = []
                var values = []

                for (var i = 1; i < listView.count; i++) {
                    funcs.push(processing_areas[i].func)
                }

                for (i = 1; i < processing_areas.length; i++) {
                    values.push(processing_areas[i].val)
                }

                for (i = 0; i < rectangles.length; i++) {
                    var rect = rectangles[i];
                    if (rect === "") rects.push("")
                    else {
                        rects.push({
                            x: rect.x,
                            y: rect.y,
                            width: rect.width,
                            height: rect.height,
                            rotation: rect.rotation
                        })
                    }
                }

                var data = {
                        start_width: start_width,
                        start_height: start_height,
                        rectangles: rects,
                        types: types,
                        funcs: funcs,
                        values: values
                    }

                var filePath = saveDialog_Project.currentFile.toString().replace("file:///", "")
                save_project(filePath, data)
            }

            onRejected: console.log("Сохранение отменено")
        }

        Menu {
            title: qsTr("Изображение")

            MenuItem {
                text: qsTr("Открыть изображение")
                onTriggered: openDialog.open()
            }

            MenuItem {
                text: qsTr("Сохранить изображение")
                onTriggered: {
                    saveDialog.currentFile = Qt.formatDateTime(new Date(), "yyyy-MM-dd_hh-mm-ss")
                    saveDialog.open()
                }
            }
        }

        Menu {
            title: qsTr("Код")

            MenuItem {
                text: qsTr("Сохранить код")
                onTriggered: save_python(listView.currentIndex)
            }
        }
    }

    Rectangle {
        id: scrollViewBG
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: listViewBG.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 8
        anchors.topMargin: 8
        anchors.rightMargin: 15
        width: 1175
        anchors.bottomMargin: 309

        color: "#00f5f5f5"
        border.width: 1
    }

    ScrollView {
        id: scrollView
        anchors.fill: scrollViewBG
        anchors.bottomMargin: 1
        anchors.rightMargin: 1
        visible: true
        clip: true
        contentWidth: 0
        contentHeight: 0
        objectName: "scrollView"
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOn

        MouseArea {
            id: mouseArea1
            width: image_width
            height: image_height
            hoverEnabled: true
            enabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: if (mouse.button === Qt.RightButton) menuImage.open()

            Menu {
                id: menuImage
                title: qsTr("Изображение")

                MenuItem {
                    text: qsTr("Открыть изображение")
                    onTriggered: openDialog.open()
                }

                MenuItem {
                    text: qsTr("Сохранить изображение")
                    onTriggered: {
                        saveDialog.currentFile = Qt.formatDateTime(new Date(), "yyyy-MM-dd_hh-mm-ss")
                        saveDialog.open()
                    }
                }
            }
        }

        Image {
            id: imageBox_1
            anchors.left: parent.left
            anchors.leftMargin: 1
            anchors.top: parent.top
            anchors.topMargin: 1
            objectName: "imageBox1"
            z: 1
            visible: true
            clip: true
            cache: true
            sourceSize: Qt.size(source.width, source.height)
            onStatusChanged: {
                if (status === Image.Ready) {
                    scrollView.contentWidth = imageBox_1.width = sizes[listView.currentIndex][1]
                    scrollView.contentHeight = imageBox_1.height = sizes[listView.currentIndex][0]
                    loading.source = ""

                    if (noImageComponent) {
                        buttonImageArea.enabled = buttonDetectorArea.enabled = true
                        noImageComponent.destroy()
                        changes_area = Qt.createQmlObject(area1, mainWindow)

                        listView.currentIndex = 0
                        listModel.clear()

                        listModel.append({txt: "Начальное изображение"})

                        button_SaveImage.enabled = true

                        scrollView.ScrollBar.horizontal.position = 0
                        scrollView.ScrollBar.vertical.position = 0
                    }

                    if (dataModel.length > 0) {
                        listView.currentIndex = 0
                        listModel.clear()

                        listModel.append({txt: "Начальное изображение"})

                        button_SaveImage.enabled = true

                        scrollView.ScrollBar.horizontal.position = 0
                        scrollView.ScrollBar.vertical.position = 0

                        for (var i = 0; i < dataModel.length; i++) {
                            create_area(dataModel[i][0], dataModel[i][1], dataModel[i][2])
                        }

                        for (i = 1; i < rectangles.length; i++) {
                            if (rectangles[i] !== "") {
                                rectangles[i].height = rectangles_values[i]["height"]
                                rectangles[i].width = rectangles_values[i]["width"]
                                rectangles[i].x = rectangles_values[i]["x"]
                                rectangles[i].y = rectangles_values[i]["y"]
                                rectangles[i].rotation = rectangles_values[i]["rotation"]

                            }

                            listView.currentIndex = i
                        }

                        for (i = 0; i < values.length; i++) {
                            if (values[i]) {
                                for (var j = 0; j < values[i].length; j++) {
                                    processing_areas[i + 1]['startValue' + (j + 1)] = values[i][j]
                                }
                            }
                            listView.currentIndex = i + 1
                        }

                        dataModel = []
                        rectangles_values = []

                        listView.currentIndex = listView.count - 1
                    }
                }
            }
        }

        Image {
            id: loading
            objectName: "loading"
            anchors.fill: imageBox_1
            sourceSize: Qt.size(source.width, source.height)
            onStatusChanged: if (status === Image.Ready) imageBox_1.source = source
        }
    }

    Button {
        id: button_OpenImage
        anchors.left: scrollViewBG.left
        anchors.top: scrollViewBG.bottom
        width: 188
        height: 40
        text: qsTr("Загрузить изображение")
        anchors.leftMargin: 0
        anchors.topMargin: 6
        objectName: "button_OpenImage"
        font.capitalization: Font.MixedCase

        onClicked: openDialog.open()

        FileDialog {
            id: openDialog
            title: "Открыть изображение..."
            nameFilters: ["Images (*.png *.jpg *jpeg *.bmp *webp)"]

            onAccepted: {
                open_image(currentFile.toString().replace("file:///", ""))

                var index = listView.currentIndex

                if (listView.count === 0) {
                    listView.currentIndex = 0
                }
                else {
                    listView.currentIndex = 0
                    changes()

                    listView.currentIndex = index
                }

                set_image(listView.currentIndex)
            }

            onRejected: console.log("Изображение не было выбрано")
        }
    }

    Button {
        id: button_SaveImage
        anchors.top: button_OpenImage.top
        anchors.left: button_OpenImage.right
        anchors.bottom: button_OpenImage.bottom
        width: 203
        text: qsTr("Сохранить изображение")
        anchors.bottomMargin: 0
        anchors.leftMargin: 14
        anchors.topMargin: 0
        objectName: "button_SaveImage"
        font.capitalization: Font.MixedCase
        enabled: false

        onClicked: {
            saveDialog.currentFile = Qt.formatDateTime(new Date(), "yyyy-MM-dd_hh-mm-ss")
            saveDialog.open()
        }

        FileDialog {
            id: saveDialog
            title: "Сохранить изображение..."
            fileMode: FileDialog.SaveFile
            nameFilters: ["PNG (*.png)", "JPG (*.jpg)", "JPEG (*.jpeg)", "Bitmap (*.bmp)", "Webp (*.webp)"]

            onAccepted: {
                var filePath = saveDialog.currentFile.toString().replace("file:///", "")
                save_image(filePath)
            }

            onRejected: console.log("Сохранение отменено")
        }
    }

    TextEdit {
        id: imageSize
        width: 107
        height: 23
        text: imageBox_1.width.toFixed(0) + " x " + imageBox_1.height.toFixed(0)
        anchors.right: scrollViewBG.right
        anchors.top: scrollViewBG.bottom
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }


    Button {
        id: buttonImageArea
        anchors.top: buttonsArea.top
        anchors.left: buttonsArea.left
        anchors.leftMargin: 5
        height: 40
        highlighted: true
        enabled: false
        z: 1
        text: qsTr("Обработка")
        font.capitalization: Font.MixedCase
        onClicked: {
            highlighted = true
            buttonDetectorArea.highlighted = !highlighted
        }
    }

    Button {
        id: buttonDetectorArea
        anchors.bottom: buttonImageArea.bottom
        anchors.left: buttonImageArea.right
        anchors.leftMargin: 3
        height: 40
        highlighted: false
        enabled: false
        z: 1
        text: qsTr("Детекторы")
        font.capitalization: Font.MixedCase
        onClicked: {
            highlighted = true
            buttonImageArea.highlighted = !highlighted
        }
    }

    Rectangle {
        id: buttonsArea
        anchors.top: listViewBG.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: scrollViewBG.right
        anchors.leftMargin: 8
        anchors.bottomMargin: 8
        anchors.topMargin: 50
        color: "#80f5f5f5"
        border.width: 1

        GridView {
            id: gridViewButtons
            highlightRangeMode: GridView.NoHighlightRange
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 45
            displayMarginBeginning: 2
            displayMarginEnd: 2
            clip: true
            cellWidth: 190
            cellHeight: 50
            visible: buttonImageArea.highlighted

            delegate: Rectangle {
                width: gridViewButtons.cellWidth
                height: gridViewButtons.cellHeight
                color: "#00000000"
                border.width: 0

                RoundButton {
                    text: modelData[0]
                    font.pointSize: 10
                    anchors.centerIn: parent
                    width: parent.width - 10
                    font.capitalization: Font.MixedCase
                    radius: 0

                    onClicked: {
                        listModel.append({txt: text + ". Изображение"})
                        Qt.callLater(listView.positionViewAtEnd)

                        types.push(0)
                        sizes.push(sizes[listView.currentIndex])

                        createChanges(modelData[0], modelData[1], modelData[3])
                        createRectangle(modelData[3])

                        listView.currentIndex = listModel.count - 1

                        changes()
                        set_image(listView.currentIndex)
                    }
                }
            }
        }

        GridView {
            id: gridViewButtons2
            highlightRangeMode: GridView.NoHighlightRange
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 45
            displayMarginBeginning: 2
            displayMarginEnd: 2
            clip: true
            cellWidth: 190
            cellHeight: 50
            visible: buttonDetectorArea.highlighted

            delegate: Rectangle {
                width: gridViewButtons2.cellWidth
                height: gridViewButtons2.cellHeight
                color: "#00000000"
                border.width: 0

                RoundButton {
                    text: modelData[0]
                    font.pointSize: 10
                    anchors.centerIn: parent
                    width: parent.width - 10
                    font.capitalization: Font.MixedCase
                    radius: 0

                    onClicked: {
                        listModel.append({txt: text + ". Изображение"})
                        Qt.callLater(listView.positionViewAtEnd)

                        types.push(0)
                        sizes.push(sizes[listView.currentIndex])

                        createChanges(modelData[0], modelData[1], modelData[3])
                        createRectangle(modelData[3])

                        listView.currentIndex = listModel.count - 1

                        changes()
                        set_image(listView.currentIndex)
                    }
                }
            }
        }
    }

    Rectangle {
        id: listViewBG
        x: 1198
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.rightMargin: 8
        anchors.bottom: scrollViewBG.bottom
        width: 394
        color: "#80ffffff"
        border.width: 1

        Button {
            id: deleteChange
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.rightMargin: 8
            text: qsTr("Удалить")
            width: 86
            height: 42
            enabled: listView.currentIndex !== 0 && listView.count > 0
            objectName: "rect_rem"
            onClicked: {
                deleteChanges()
                changes()
                set_image(listView.currentIndex)
            }
        }

        Button {
            id: goUp
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.leftMargin: 8
            text: qsTr("Вверх ▲")
            width: 86
            height: 42
            enabled: listView.currentIndex !== 0 && listView.currentIndex !== 1 && listView.count > 1
            onClicked: {
                var swap
                swap = rectangles[listView.currentIndex - 1]
                rectangles[listView.currentIndex - 1] = rectangles[listView.currentIndex]
                rectangles[listView.currentIndex] = swap

                swap = types[listView.currentIndex - 1]
                types[listView.currentIndex - 1] = types[listView.currentIndex]
                types[listView.currentIndex] = swap

                swap = processing_areas[listView.currentIndex - 1]
                processing_areas[listView.currentIndex - 1] = processing_areas[listView.currentIndex]
                processing_areas[listView.currentIndex] = swap

                sizes[listView.currentIndex - 1] = sizes[listView.currentIndex - 2]

                listModel.move(listView.currentIndex, listView.currentIndex - 1, 1)

                var indexNum = listView.currentIndex

                for (var i = 1; i < listView.count; i++) {
                    listView.currentIndex = i
                    rectangles[i].enabled = false
                }

                listView.currentIndex = indexNum - 1

                if (types[listView.currentIndex] === 0) {
                    rectangles[listView.currentIndex].enabled = false
                }
                else if (types[listView.currentIndex] === 1) {
                    rectangles[listView.currentIndex].enabled = true
                }

                swap_sizes_up(listView.currentIndex)
//                changes()
//                set_image(listView.currentIndex)
            }
        }

        Button {
            id: goDown
            anchors.left: goUp.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.leftMargin: 8
            text: qsTr("Вниз ▼")
            width: 86
            height: 42
            enabled: listView.currentIndex !== 0 && listView.currentIndex !== listView.count - 1 && listView.count > 1
            onClicked: {
                var swap
                swap = rectangles[listView.currentIndex + 1]
                rectangles[listView.currentIndex + 1] = rectangles[listView.currentIndex]
                rectangles[listView.currentIndex] = swap

                swap = types[listView.currentIndex + 1]
                types[listView.currentIndex + 1] = types[listView.currentIndex]
                types[listView.currentIndex] = swap

                swap = processing_areas[listView.currentIndex + 1]
                processing_areas[listView.currentIndex + 1] = processing_areas[listView.currentIndex]
                processing_areas[listView.currentIndex] = swap

                sizes[listView.currentIndex - 1] = sizes[listView.currentIndex]

                listModel.move(listView.currentIndex, listView.currentIndex + 1, 1)

                var indexNum = listView.currentIndex

                for (var i = 1; i < listView.count; i++) {
                    listView.currentIndex = i
                    rectangles[i].enabled = false
                }

                listView.currentIndex = indexNum + 1

                if (types[listView.currentIndex] === 0) {
                    rectangles[listView.currentIndex].enabled = false
                }
                else if (types[listView.currentIndex] === 1) {
                    rectangles[listView.currentIndex].enabled = true
                }

                swap_sizes_down(listView.currentIndex)
            }
        }

        ListView {
            id: listView
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 8
            anchors.leftMargin: 8
            anchors.bottomMargin: 16 + deleteChange.height
            anchors.topMargin: 16
            boundsMovement: Flickable.FollowBoundsBehavior
            clip: true
            keyNavigationEnabled: true
            currentIndex: -1

            onCurrentIndexChanged: {
                for (var i = 1; i < listModel.count; i++) processing_areas[i].visible = false

                processing_areas[listView.currentIndex].visible = true

                selectRectangle(listView.currentIndex)

                if (listView.currentIndex === 0) selAreaEnabled = false
                else selAreaEnabled = processing_areas[listView.currentIndex].selection_area_enabled

                changes()

                set_image(listView.currentIndex)
            }

            model: ListModel {
                id: listModel
            }

            delegate:
                Rectangle {
                id: rect_id
                width: listView.width
                height: 42
                y: 8
                color: "#00ffffff"
                border.width: 0

                states:
                    State {
                    when: rect_id.ListView.isCurrentItem
                    PropertyChanges {
                        target: rect_id
                        border.width: 2
                    }
                }

                Button {
                    id: button_id
                    height: parent.height - 4
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.rightMargin: 4
                    anchors.topMargin: 2
                    anchors.leftMargin: 4
                    leftPadding: 2
                    text: index + ". " + txt
                    font.capitalization: Font.Capitalize
                    onClicked: {
                        rect_id.ListView.view.currentIndex = model.index
                    }
                }
            }
        }
    }

    Button {
        id: button_SavePython
        x: 1445
        width: 147
        height: 40
        anchors.topMargin: 6
        text: qsTr("Сохранить код")
        objectName: "Python"
        font.capitalization: Font.MixedCase
        anchors.top: listViewBG.bottom
        anchors.right: listViewBG.right

        onClicked: save_python(listView.currentIndex)
    }

    onButtons_listChanged: {
        buttons_list_image = []
        buttons_list_detector = []
        for (var i = 0; i < buttons_list.length; i++) {
            if (buttons_list[i][2] === false) buttons_list_image.push(buttons_list[i])
            else buttons_list_detector.push(buttons_list[i])
        }

        gridViewButtons.model = buttons_list_image
        gridViewButtons2.model = buttons_list_detector
    }

    property var noImageComponent: "
        import QtQuick 2.14

        Text {
            id: noImage
            anchors.centerIn: scrollView
            width: 740
            height: 460
            color: \"red\"
            text: qsTr(\"No Image\")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 100
        }"


    property bool selAreaEnabled: false
    property var area1: "
        import QtQuick 2.14
        import QtQuick.Controls 2.13

        Rectangle {
          anchors.left: listViewBG.left
          anchors.right: listViewBG.right
          anchors.top: listViewBG.bottom
          anchors.bottom: parent.bottom
          anchors.topMargin: 50
          anchors.bottomMargin: 8
          color: \"#80e4e4e4\"
          border.width: 2

          Text {
              anchors.left: parent.left
              anchors.bottom: parent.top
              width: 168
              height: 29
              text: \"Параметры детекторов\"
              font.pixelSize: 18
          }

          Switch {
              id: area_switch
              anchors.bottom: parent.bottom
              anchors.left: parent.left
              width: 140
              height: 35
              z: 1
              enabled: selAreaEnabled
              visible: enabled
              text: qsTr(\"Область\")
              checked: types[listView.currentIndex]
              onCheckedChanged: {
                if (checked && listView.currentIndex > 0) {
                    types[listView.currentIndex] = 1
                    rectangles[listView.currentIndex].enabled = true

                    listModel.get(listView.currentIndex).txt = listModel.get(listView.currentIndex).txt.split(\'.\')[0] + \'. Область\'
                }
                else if (listView.currentIndex > 0) {
                    types[listView.currentIndex] = 0
                    rectangles[listView.currentIndex].enabled = false

                    listModel.get(listView.currentIndex).txt = listModel.get(listView.currentIndex).txt.split(\'.\')[0] + \'. Изображение\'
                }

                changes()
                set_image(listView.currentIndex)
              }

              Component.onCompleted: {
                if (checked && rectangles[listView.currentIndex] !== \"\") {
                    types[listView.currentIndex] = 1
                    rectangles[listView.currentIndex].enabled = true
                }
                else {
                    types[listView.currentIndex] = 0
                    rectangles[listView.currentIndex].enabled = false
                }
              }
          }
        }"

    property var area_empty: "
        import QtQuick 2.14
        import QtQuick.Controls 2.13

        Rectangle {
          anchors.fill: parent
          color: \"#00ffffff\"
      //    border.width: parent.border.width

          property string name: \"\"
          property string func: \"\"
          property var val: {}

          property var selection_area_enabled: false

          Text {
              id: area_name
              x: 9
              y: 10
              width: 159
              height: 18
              text: name
              font.pixelSize: 15
          }
        }"

    Component.onCompleted: noImageComponent = Qt.createQmlObject(noImageComponent, scrollView)
}
