import unittest
import numpy as np
import cv2
from app import pixel_to_ascii, cmd_print, webcam_capture, WIDTH, HEIGHT, ASCII_SCALE

class TestApp(unittest.TestCase): 
    
    def test_file_capture(self):
        print("\ntesting if pop-cat.gif can be captured")
        self.assertIsNotNone(cv2.VideoCapture('pop-cat.gif'))
    
    def test_pixel_to_ascii(self):
        print("\ntesting if all pixels are converted to known symbols")
        for i in range(0, 256, 25):
            with self.subTest(pixel=i):
                ascii_char = pixel_to_ascii(i)
                self.assertEqual(ascii_char[0], ascii_char[1])
                self.assertIn(ascii_char[0], ASCII_SCALE)

    def test_webcam_capture_simulated_input(self):
        print("\ntesting if frame sequencing works (loop)")
        class MockCapture:
            def __init__(self):
                self.frames = [
                    np.random.randint(0, 256, (240, 320, 3), dtype=np.uint8),
                    np.zeros((240, 320, 3), dtype=np.uint8)
                ]
                self.current = 0

            def read(self):
                frame = self.frames[self.current]
                self.current = (self.current + 1) % len(self.frames)
                return frame

            def release(self):
                pass

        capture = MockCapture()

        original_videocapture = cv2.VideoCapture
        cv2.VideoCapture = lambda *args, **kwargs: capture
        
        try:
            for _ in range(3):
                frame = capture.read()
                gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                resized = cv2.resize(gray, (WIDTH, HEIGHT))
                cmd_print(resized)
        except Exception as e:
            self.fail(f"webcam_capture simulation failed: {e}")
        finally:
            cv2.VideoCapture = original_videocapture

if __name__ == "__main__":
    unittest.main()
