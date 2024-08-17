import os

class Code:
    def __init__(self, path_to_image=None):
        self.path_to_main = "./Python/main.py"
        self.path_to_processor = "./Python/processor.py"

        self.main_code = f"""import cv2
from processor import Processor

img = cv2.imread(r'{path_to_image}')

P = Processor()
img = P.Process(img)

cv2.imshow('Image', img)
cv2.waitKey(0)
cv2.destroyAllWindows()
"""

        self.processor_code = f"""import cv2, numpy as np


class Processor:
    def rotated_rect_find(self, x, y, width, height, rotation):
        center = (x + width // 2, y + height // 2)
        rotated_rect = cv2.boxPoints((center, (width, height), rotation))
        rotated_rect = np.intp(rotated_rect)
        
        return rotated_rect
        
    def Process(self, img):
        return img
"""

    def create_main(self):
        target_folder = os.path.dirname(self.path_to_main)
        if not os.path.exists(target_folder):
            os.makedirs(target_folder)

        with open(self.path_to_main, 'w') as target_file:
            target_file.write(self.main_code)

    def create_processor(self):
        target_folder = os.path.dirname(self.path_to_processor)
        if not os.path.exists(target_folder):
            os.makedirs(target_folder)

        with open(self.path_to_processor, 'w') as target_file:
            target_file.write(self.processor_code)

    def add_processing_code(self, lines_to_add):
        # Открываем файл для чтения
        with open(self.path_to_processor, 'r') as file:
            lines = file.readlines()

        # Ищем индекс строки с return img
        for i, line in enumerate(lines):
            if 'return img' in line:
                index = i

                # Вставляем новый код перед return img
                lines.insert(index, "        " + lines_to_add +"\n\n")

                # Записываем измененные строки обратно в файл
                with open(self.path_to_processor, 'w') as file:
                    file.writelines(lines)
                break

