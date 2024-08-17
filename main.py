import sys
import os
import numpy as np
import cv2
import base64
import traceback
import xml.etree.ElementTree as ET
# import json
import ast

from PyQt5.QtCore import QObject, QUrl, qInstallMessageHandler
from PyQt5.QtGui import QGuiApplication, QIcon
from PyQt5.QtQml import QQmlApplicationEngine

from dist.Processor import Processor
from dist.Code import Code
from dist.Buttons import button_info_list

processor = Processor()
code = Code

styles = ["Basic", "Fusion", "Imagine", "Material", "Universal"] # стили Qt

url = "dist\MainWindow.qml" # путь к основному файлу QML
sourceb64 = "data:image;base64," # переменная для передачи закодированного изображения в QML
extension = ".jpg" # расширение изображения
path_to_image = ""

images = [] # массив с изображениями
sizes = [] # массив с размерами изображений

code_lines = [""]


def qt_message_handler(mode, context, message):
    print("%s (%s:%d, %s)" % (message, context.file, context.line, context.file))


def changes_apply(index, type, func, value, x, y, width, height, rotation):
    if func in processor.functions:
        image = np.copy(images[index-1])

        lines = None

        if value:
            value = value.toVariant()
            # print(value)

            try:
                result, lines = processor.functions[func](image, *value)
            except:
                result = None
                pass
        else:
            try:
                result, lines = processor.functions[func](image)
            except:
                result = None
                pass

        if result is not None:
            try:
                if type == 1:
                    rotated_rect = processor.rotated_rect_find(x, y, width, height, rotation)
                    image_array_size = np.zeros_like(images[index-1])
                    cv2.fillPoly(image_array_size, [rotated_rect], (255, 255, 255))

                    images[index] = np.where(image_array_size == 255, result, images[index-1])
                    sizes[index] = images[index].shape[0:2]

                    line = f"""rotated_rect = self.rotated_rect_find({x}, {y}, {width}, {height}, {rotation})
        image_array_size = np.zeros_like(img0)
        cv2.fillPoly(image_array_size, [rotated_rect], (255, 255, 255))
        img = np.where(image_array_size == 255, img, img0)"""

                    lines = "img0 = np.copy(img)\n\n        " + lines + "\n\n        " + line
                    append_code(index, lines)
                
                else:
                    images[index] = result
                    sizes[index] = images[index].shape[0:2]

                    lines = "img0 = np.copy(img)\n\n        " + lines + "\n\n        " + line
                    append_code(index, lines)

            except:
                images[index] = result
                sizes[index] = images[index].shape[0:2]

                append_code(index, lines)

                pass

    # cv2.imshow("cv2_image", images[index])

    # set_image(index)


def open_image(link, b64=""):
    global extension, path_to_image
    try:
        extension = "." + link.split(".", 1)[1]
        path_to_image = link
        
        if "data:image;base64," in b64:
            cv2_image = base64_to_cv2(b64)
        else:
            cv2_image = cv2.imread(link)
                    
        height, width = cv2_image.shape[0:2]

        if len(images) == 0:
            images.append(cv2_image)
            sizes.append([height, width])
        else:
            images[0] = cv2_image
            sizes[0] = [height, width]

        root.setProperty("start_height", sizes[0][0])
        root.setProperty("start_width", sizes[0][1])

        root.setProperty("buttons_list", button_info_list)

        root.setProperty("sizes", sizes)
    except: 
        return


def set_image(index):
    try:
        while len(images) <= index:
            append_images()

        height, width = images[index].shape[0:2]
        sizes[index] = [height, width]

        root.setProperty("sizes", sizes)

        b64image = cv2_to_base64(images[index])

        img = root.findChild(QObject, "loading")
        img.setProperty("source", b64image)
    except:
        return


def save_image(link):
    img = root.findChild(QObject, "imageBox1")
    img = img.property("source").toString()

    encoded_img = img.split(",")[-1]

    decoded_img = base64.b64decode(encoded_img)

    nparr = np.frombuffer(decoded_img, np.uint8)

    img_cv2 = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    cv2.imwrite(link, img_cv2)

    print(f"Image saved at: {link}")


def cv2_to_base64(cv2_img):
    global extension
    _, buffer = cv2.imencode(extension, cv2_img)
    img_base64 = base64.b64encode(buffer).decode("utf-8")

    return sourceb64 + img_base64


def base64_to_cv2(base64_data):
    if base64_data.startswith("data:image"):
        base64_data = base64_data.split(",")[1]

    im_bytes = base64.b64decode(base64_data)
    im_arr = np.frombuffer(im_bytes, dtype=np.uint8)
    return cv2.imdecode(im_arr, flags=cv2.IMREAD_COLOR)


def append_images():
    images.append(images[len(images)-1])
    sizes.append(list(sizes[len(sizes)-1]))


def remove_images(index):
    if len(images) - 1 >= index:
        images.pop(index)
        sizes.pop(index)


def swap_sizes_up(index):
    sizes[index] = sizes[index - 1]


def swap_sizes_down(index):
    sizes[index - 1] = sizes[index]


def write_code(index):
    code(path_to_image).create_main()
    code().create_processor()

    i = 1
    while i <= index:
        code().add_processing_code(code_lines[i])
        i += 1


def append_code(index, lines):
    if index > len(code_lines) - 1:
        code_lines.append(lines)
    else:
        code_lines[index] = lines

# xml
def open_project(link):
    try:
        with open(link, "r", encoding="utf-8-sig") as file:
            xml_content = file.read()
        
        tree = ET.ElementTree(ET.fromstring(xml_content))
        root_element = tree.getroot()
        
        data = {child.tag: child.text for child in root_element}
        
        open_image(data["link"], data["image"])

    except ET.ParseError as e:
        print(f"XML Parse Error: {e}")
        return
    except Exception as e:
        print(f"Error: {e}")
        return

    root.setProperty("start_width", ast.literal_eval(data["start_width"]))
    root.setProperty("start_height", ast.literal_eval(data["start_height"]))

    root.setProperty("types", ast.literal_eval(data["types"]))

    funcs = ast.literal_eval(data["funcs"])
    values = ast.literal_eval(data["values"])
    rectangles_values = ast.literal_eval(data["rectangles"])

    dataModel = []
    for i in funcs:
        for j in button_info_list:
            if i in j:
                dataModel.append([j[0], j[1], j[3]])

    root.setProperty("dataModel", dataModel)
    root.setProperty("values", values)
    root.setProperty("rectangles_values", rectangles_values)

    root.setProperty("rectangles", [""])
    root.setProperty("processing_areas", [""])

    set_image(0)

# xml
def save_project(link, data):
    data = data.toVariant()
    data["link"] = path_to_image.replace("\\", "/")
    data["image"] = cv2_to_base64(images[0])

    root = ET.Element("project")

    for key, val in data.items():
        child = ET.SubElement(root, key)
        child.text = str(val)

    tree = ET.ElementTree(root)
    tree.write(link, encoding="utf-8", xml_declaration=True)

    print(f"Project saved at: {link}")

# json
# def open_project(link):
    # try:
    #     with open(link, "r") as file:
    #         data = json.load(file)
            
    #     open_image(data["link"], data["image"])

    # except:
    #     print("Broken project file")
    #     return

    # root.setProperty("start_width", data["start_width"])
    # root.setProperty("start_height", data["start_height"])

    # root.setProperty("types", data["types"])


    # dataModel = []
    # for i in data["funcs"]:
    #     for j in button_info_list:
    #         if i in j:
    #             dataModel.append([j[0], j[1], j[3]])

    # values = data["values"]
    # rectangles_values = data["rectangles"]

    # root.setProperty("dataModel", dataModel)
    # root.setProperty("values", values)
    # root.setProperty("rectangles_values", rectangles_values)

    # root.setProperty("rectangles", [""])
    # root.setProperty("processing_areas", [""])

# json
# def save_project(link, data):
#     data = data.toVariant()
#     data["link"] = path_to_image.replace("\\","/")
#     data["image"] = cv2_to_base64(images[0])

#     with open(link, "w") as file:
#         json.dump(data, file, sort_keys=False, indent=2)

#     print(f"Project saved at: {link}")


if __name__ == "__main__":
    os.environ["QT_QUICK_CONTROLS_STYLE"] = styles[3]
    # os.environ["QT_QUICK_CONTROLS_MATERIAL_THEME"] = "Dark"
    os.environ["QT_QUICK_CONTROLS_MATERIAL_ACCENT"] = "Magenta"
    # os.environ["QT_QUICK_CONTROLS_MATERIAL_FOREGROUND"] = "Purple"
    # os.environ["QT_QUICK_CONTROLS_MATERIAL_BACKGROUND"] = "Steel"
    # os.environ["QT_FORCE_STDERR_LOGGING"] = "1"
    qInstallMessageHandler(qt_message_handler)

    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon("dist\icon.ico"))
    engine = QQmlApplicationEngine()
    engine.load(QUrl.fromLocalFile(url))

    root = engine.rootObjects()[0]

    try:
        root.open_image.connect(open_image)

        root.remove_signal.connect(remove_images)
        root.set_image.connect(set_image)
        root.processing_values_changed.connect(changes_apply)
        root.append_signal.connect(append_images)

        root.save_image.connect(save_image)

        root.save_python.connect(write_code)

        root.swap_sizes_up.connect(swap_sizes_up)
        root.swap_sizes_down.connect(swap_sizes_down)

        root.open_project.connect(open_project)
        root.save_project.connect(save_project)

    except:
        print(traceback.format_exc())

    sys.exit(app.exec_())
