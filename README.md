# Webcam in Console using Python
## 020152332A - Master of Data Science - Workshop 2

### Overview

This project is done under the scope of the Workshop 2 class given by Dr. Bruno Rodrigues. This project transforms the webcam feed to ASCII in realtime and if you don't have a webcam, the Internet's favorite (maybe) cat will greet you.

I am working on a MacOS device so it's possible that my installation methods for other operating systems might not work. If that's the case, feel free to raise an issue.

To install and run this program, there are no prerequisites unless you are on a Windows. Windows users need to install Python by themselves. I am using Python@3.12.6. Recent Python versions should work too but that is not completely verified.

Before you start any installation, you will need to do the following:

```
git clone https://github.com/oliveira-da-silva-patrick/Workshop2-WebcamFeed.git
cd Workshop2-WebcamFeed
```

If you don't have Git installed, you can download the repository manually. After downloading it, you will need to unzip it and open the folder on your terminal window.

Once this is done, you can start with the installation and run process.

There are several installation methods:
- [Using a script that installs Python (if possible) and sets up the project environment](#using-a-script-that-installs-python-if-possible-and-sets-up-the-project-environment)
- [Using a script that only sets up the project environment](#using-a-script-that-only-sets-up-the-project-environment)
- [Using Python and a virtual environment](#using-python-and-a-virtual-environment)
- [Using Docker](#using-docker)

### Using a script that installs Python (if possible) and sets up the project environment

If you have Python already installed and want to try first with your own installation, feel free to follow this [tutorial](#using-a-script-that-only-sets-up-the-project-environment) first and come back here should it not have worked out.

To run this script on MacOS, you will need to have Homebrew installed.

1. Open your terminal window at the root of the project
2. Run 
```
bash run.sh
```

### Using a script that only sets up the project environment

1. Open your terminal window at the root of the project
2. Run 
```
bash run_without_python_installation.sh
```

### Using Python and a virtual environment

This tutorial follows what the scripts above do automatically

1. Open your terminal window at the root of the project
2. Check if Python version is 3.12.6: 
```
python --version
```
3. If Python version is not ok, try with your installation first and if it does not work come back here after installing Python@3.12.6
4. Create environment: 
```
python -m venv venv
```
5. Activate environment:
    - MacOS + Linux: 
    ```
    source venv/bin/activate
    ```
    - Windows: 
    ```
    venv\Scripts\activate
    ```
6. Upgrade pip: 
```
python -m pip install --upgrade pip==24.3.1
```
7. Install packages: 
```
pip install -r requirements.txt
```
8. Run tests: 
```
pytest test_app.py
```
9. Run program: 
```
python app.py
```

### Using Docker

The webcam is disabled on Docker and instead you will be faced with a cat :O

1. Launch Docker
2. Open your terminal window at the root of the project
3. Build the Dockerfile 
```
docker build -t webcam_ascii .
```
4. Perform the tests on the container 
```
docker run --rm -it webcam_ascii pytest
```
5. Run the program on Docker
```
docker run --rm -it webcam_ascii
```
