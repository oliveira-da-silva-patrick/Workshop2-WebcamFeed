import cv2
import os
import time

WIDTH = 80
HEIGHT = 60
ASCII_SCALE = ['@', '%', '#', '*', '+', '=', '-', ':', ' ', ' ']

CLEAR_COMMAND = 'clear'

if os.name == 'nt': # nt == windows
    CLEAR_COMMAND = 'cls'
    
def pixel_to_ascii(pixel_color):
    index = (int(pixel_color / 25.5)) - 1
    return ASCII_SCALE[index] * 2

def cmd_print(image):
    single_frame = "\n".join(["".join([pixel_to_ascii(image[h][w]) for w in range(WIDTH)]) for h in range(HEIGHT)])
    print(single_frame)

def webcam_capture():
    sleep_time = 0
    gif = False
    
    try:
        capture = cv2.VideoCapture(0)
    except:
        capture = cv2.VideoCapture('pop-cat.gif')
        sleep_time = 0.05
        gif = True

    while True:
        returned, frame = capture.read()

        if not returned:
            if gif: 
                capture = cv2.VideoCapture('pop-cat.gif')
                continue
            else:
                raise ValueError("Can't read frame from webcam")

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        resized = cv2.resize(gray, (WIDTH, HEIGHT))
        os.system(CLEAR_COMMAND)
        cmd_print(resized)

        # press 'q' to quit
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
        
        time.sleep(sleep_time)

    capture.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    webcam_capture()