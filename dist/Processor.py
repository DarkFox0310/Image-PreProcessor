import numpy as np
import cv2


class Processor:
    def __init__(self):
        self.functions = {
            "brightness": self.brightness,
            "contrast":  self.contrast,
            "threshold": self.threshold,
            "contours": self.contours,
            "blur": self.blur,
            "gray": self.gray,
            "inverse": self.inverse,
            "extract_channel": self.extract_channel,
            "resize": self.resize,
            "cut": self.cut,
            "threshold_mask": self.threshold_mask,
            "morphology": self.morphology,
            "range": self.range,
            "range_mask": self.range_mask,
            "channels_values": self.channels_values,
            "histogram": self.histogram,
            "rotate": self.rotate,
            "circles": self.circles,
            "corners": self.corners
        }

    def rotated_rect_find(self, x, y, width, height, rotation):
        center = (x + width // 2, y + height // 2)
        rotated_rect = cv2.boxPoints((center, (width, height), rotation))
        rotated_rect = np.intp(rotated_rect)

        return rotated_rect

    def brightness(self, img, value_brightness):
        img = cv2.convertScaleAbs(img, alpha=1, beta=int(value_brightness) - 100)

        lines = f"""img = cv2.convertScaleAbs(img, alpha=1, beta={int(value_brightness)} - 100)"""

        return img, lines

    def contrast(self, img, value_contrast):
        img = cv2.convertScaleAbs(img, alpha=int(value_contrast) / 100, beta=0)

        lines = f"""img = cv2.convertScaleAbs(img, alpha={int(value_contrast)} / 100, beta=0)"""

        return img, lines

    def threshold(self, img, thresh, threshMax, types):
        img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        _, img = cv2.threshold(img, int(thresh), int(threshMax), types)

        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)

        lines = f"""img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        _, img = cv2.threshold(img,{int(thresh)}, {int(threshMax)}, {types})
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)"""

        return img, lines

    def contours(self, img, contours, put_contours):
        gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        edges = cv2.Canny(gray_image, int(contours), int(contours) * 3)
        if put_contours is True:
            contours_array, hierarchy = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
            img = cv2.drawContours(img, contours_array, -1, (0, 255, 0), 1, cv2.LINE_AA, hierarchy, 1)
        else:
            img = cv2.cvtColor(edges, cv2.COLOR_GRAY2BGR)

        lines = f"""gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        edges = cv2.Canny(gray_image, {int(contours)}, {int(contours)} * 3)
        if {put_contours} is True:
            contours_array, hierarchy = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
            img = cv2.drawContours(img, contours_array, -1, (0, 255, 0), 1, cv2.LINE_AA, hierarchy, 1)
        else:
            img = cv2.cvtColor(edges, cv2.COLOR_GRAY2BGR)"""

        return img, lines

    def blur(self, img, blur):
        img = cv2.medianBlur(img, int(blur))

        lines = f"""img = cv2.medianBlur(img, {int(blur)})"""

        return img, lines

    def gray(self, img):
        img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)

        lines = f"""img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)"""

        return img, lines

    def inverse(self, img):
        img = cv2.bitwise_not(img)

        lines = f"""img = cv2.bitwise_not(img)"""

        return img, lines

    def extract_channel(self, img, types):
        img = cv2.extractChannel(img, types)
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)

        lines = f"""img = cv2.extractChannel(img, {types})
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)"""

        return img, lines

    def resize(self, img, width, height):
        try:
            img = cv2.resize(img, (int(width), int(height)))
        except:
            pass

        lines = f"""try:
            img = cv2.resize(img, ({int(width)}, {int(height)}))
        except:
            pass"""

        return img, lines

    def cut(self, img, x, y, width, height):
        img = img[int(y):int(height), int(x):int(width)]

        lines = f"""img = img[{int(y)}:{int(height)}, {int(x)}:{int(width)}]"""

        return img, lines

    def threshold_mask(self, img, thresh, threshMax, types):
        gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        _, thresh_mask = cv2.threshold(gray_image, thresh, threshMax, types)
        img = cv2.bitwise_and(img, img, mask=thresh_mask)

        lines = f"""gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        _, thresh_mask = cv2.threshold(gray_image, {thresh}, {threshMax}, {types})
        img = cv2.bitwise_and(img, img, mask=thresh_mask)"""

        return img, lines

    def morphology(self, img, val1, val2, iterations, types):
        img = cv2.morphologyEx(img, types, np.ones((int(val1), int(val2)), np.uint8), iterations=int(iterations))

        lines = f"""img = cv2.morphologyEx(img, {types}, np.ones(({int(val1)}, {int(val2)}), np.uint8), iterations={int(iterations)})"""

        return img, lines

    def range(self, img, b1, g1, r1, b2, g2, r2):
        img = cv2.inRange(img, np.array((b1, g1, r1), np.uint8), np.array((b2, g2, r2), np.uint8))
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)

        lines = f"""img = cv2.inRange(img, np.array(({b1}, {g1}, {r1}), np.uint8), np.array(({b2}, {g2}, {r2}), np.uint8))
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)"""

        return img, lines

    def range_mask(self, img, b1, g1, r1, b2, g2, r2):
        img_mask = cv2.inRange(img, np.array((b1, g1, r1), np.uint8),np.array((b2, g2, r2), np.uint8))
        img = cv2.bitwise_and(img, img, mask=img_mask)

        lines = f"""img_mask = cv2.inRange(img, np.array(({b1}, {g1}, {r1}), np.uint8),np.array(({b2}, {g2}, {r2}), np.uint8))
        img = cv2.bitwise_and(img, img, mask=img_mask)"""

        return img, lines

    def channels_values(self, img, val1, val2, val3, types):
        bgr_hsv = types
        if bgr_hsv == 0:
            img[::1, ::1, 0] = img[::1, ::1, 0] * val1
            img[::1, ::1, 1] = img[::1, ::1, 1] * val2
            img[::1, ::1, 2] = img[::1, ::1, 2] * val3
        else:
            hsv_image = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
            hsv_image[::1, ::1, 0] = hsv_image[::1, ::1, 0] * val1
            hsv_image[::1, ::1, 1] = hsv_image[::1, ::1, 1] * val2
            hsv_image[::1, ::1, 2] = hsv_image[::1, ::1, 2] * val3
            img = cv2.cvtColor(hsv_image, cv2.COLOR_HSV2BGR)

        lines = f"""bgr_hsv = {types}
        if bgr_hsv == 0:
            img[::1, ::1, 0] = img[::1, ::1, 0] * {val1}
            img[::1, ::1, 1] = img[::1, ::1, 1] * {val2}
            img[::1, ::1, 2] = img[::1, ::1, 2] * {val3}
        else:
            hsv_image = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
            hsv_image[::1, ::1, 0] = hsv_image[::1, ::1, 0] * {val1}
            hsv_image[::1, ::1, 1] = hsv_image[::1, ::1, 1] * {val2}
            hsv_image[::1, ::1, 2] = hsv_image[::1, ::1, 2] * {val3}
            img = cv2.cvtColor(hsv_image, cv2.COLOR_HSV2BGR)"""

        return img, lines

    def histogram(self, img, clipLimit, tileGrid1, tileGrid2):
        clahe = cv2.createCLAHE(clipLimit=clipLimit, tileGridSize=(int(tileGrid1), int(tileGrid2)))
        lab = cv2.cvtColor(img, cv2.COLOR_BGR2LAB)
        l, a, b = cv2.split(lab)
        l2 = clahe.apply(l)
        lab = cv2.merge((l2, a, b))
        img = cv2.cvtColor(lab, cv2.COLOR_LAB2BGR)

        lines = f"""clahe = cv2.createCLAHE(clipLimit={clipLimit}, tileGridSize=({int(tileGrid1)}, {int(tileGrid2)}))
        lab = cv2.cvtColor(img, cv2.COLOR_BGR2LAB)
        l, a, b = cv2.split(lab)
        l2 = clahe.apply(l)
        lab = cv2.merge((l2, a, b))
        img = cv2.cvtColor(lab, cv2.COLOR_LAB2BGR)"""

        return img, lines

    def rotate(self, img, width, height, rotation):
        center = (width // 2, height // 2)
        rotated = cv2.getRotationMatrix2D(center, rotation, 1.0)
        img = cv2.warpAffine(img, rotated, (width, height))


        lines = f"""center = ({width} // 2, {height} // 2)
        rotated = cv2.getRotationMatrix2D(center, {rotation}, 1.0)
        img = cv2.warpAffine(img, rotated, ({width}, {height}))"""

        return img, lines

    def circles(self, img, dp, minDist, param1, param2, minRadius, maxRadius, thickness):
        gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        circles = cv2.HoughCircles(gray_image, cv2.HOUGH_GRADIENT, float(dp), float(minDist), param1=float(param1), param2=float(param2), minRadius=int(minRadius), maxRadius=int(maxRadius))
        circles = np.uint16(np.around(circles))
        img = cv2.cvtColor(gray_image, cv2.COLOR_GRAY2BGR)
        for i in circles[0, :]:
            cv2.circle(img, (i[0], i[1]), i[2], (0, 0, 255), int(thickness))

        lines = f"""gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        circles = cv2.HoughCircles(gray_image, cv2.HOUGH_GRADIENT, {float(dp)}, {float(minDist)}, param1={float(param1)}, param2={float(param2)}, minRadius={int(minRadius)}, maxRadius={int(maxRadius)})
        circles = np.uint16(np.around(circles))
        img = cv2.cvtColor(gray_image, cv2.COLOR_GRAY2BGR)
        for i in circles[0, :]:
            cv2.circle(img, (i[0], i[1]), i[2], (0, 0, 255), {int(thickness)})"""

        return img, lines

    def corners(self, img, blockSize, kSize, k):
        gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        gray_image = np.float32(gray_image)
        dst = cv2.cornerHarris(gray_image, int(blockSize), int(kSize), float(k))
        dst = cv2.dilate(dst, None)
        img[dst > 0.01 * dst.max()] = [0, 255, 0]

        lines = f"""gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        gray_image = np.float32(gray_image)
        dst = cv2.cornerHarris(gray_image, {int(blockSize)}, {int(kSize)}, {float(k)})
        dst = cv2.dilate(dst, None)
        img[dst > 0.01 * dst.max()] = [0, 255, 0]"""

        return img, lines
