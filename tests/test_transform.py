import unittest

from transform import get_detection


class TransformTestCase(unittest.TestCase):
    def test_get_detection_with_normal(self):
        self.assertEqual(get_detection("IM-0005-0001.jpeg"), 0)

    def test_get_detection_with_normal2(self):
        self.assertEqual(get_detection("NORMAL2-IM-0237-0001.jpeg"), 0)

    def test_get_detection_with_bacteria(self):
        self.assertEqual(get_detection("person90_bacteria_443.jpeg"), 1)

    def test_get_detection_with_bacteria2(self):
        self.assertEqual(get_detection("person124_bacteria_592.jpeg"), 1)

    def test_get_detection_with_virus(self):
        self.assertEqual(get_detection("person1635_virus_2831.jpeg"), 2)

    def test_get_detection_with_virus2(self):
        self.assertEqual(get_detection("person1674_virus_2890.jpeg"), 2)
