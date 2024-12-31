FROM python:3.12.6
RUN apt-get update && apt-get install ffmpeg libgl1 libsm6 libxext6  -y
RUN mkdir -p /webcam_app
COPY app.py pop-cat.gif requirements.txt test_app.py /webcam_app
WORKDIR /webcam_app
RUN pip install --upgrade pip==24.3.1
RUN pip install -r requirements.txt
CMD ["sh", "-c", "python app.py -nw"]