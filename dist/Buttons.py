class ButtonInfo:
    def __init__(self, name, function, detector, selection_area_enabled):
        self.name = name
        self.function = function
        self.detector = detector
        self.selection_area_enabled = selection_area_enabled

    def to_list(self):
        return [self.name, self.function, self.detector, self.selection_area_enabled]


button_info = [ButtonInfo("Яркость", "brightness", False, True),
               ButtonInfo("Контраст", "contrast", False,  True),
               ButtonInfo("Бинеризация", "threshold", False,  True),
               ButtonInfo("Нахождение контуров", "contours", True,  True),
               ButtonInfo("Размытие", "blur", False,  True),
               ButtonInfo("Оттенки серого", "gray", False,  True),
               ButtonInfo("Инверсия", "inverse", False,  True),
               ButtonInfo("Выделение канала", "extract_channel", False,  True),
               ButtonInfo("Изменение размера", "resize", False,  False),
               ButtonInfo("Обрезка", "cut", False,  False),
               ButtonInfo("Маска по бинеризации", "threshold_mask", False,  True),
               ButtonInfo("Морфология", "morphology", False,  True),
               ButtonInfo("Диапазон", "range", False,  True),
               ButtonInfo("Маска по диапазону", "range_mask", False,  True),
               ButtonInfo("Значения каналов", "channels_values", False,  True),
               ButtonInfo("Адапт. гистограмма", "histogram", False,  True),
               ButtonInfo("Поворот", "rotate", False,  False),
               ButtonInfo("Нахождение кругов", "circles", True,  True),
               ButtonInfo("Нахождение углов", "corners", True,  True)
              ]

button_info_list = [button.to_list() for button in button_info]