#!/bin/bash

REQUIRED_PYTHON_VERSION="3.12.6"
VENV_DIR="venv"
REQUIREMENTS_FILE="requirements.txt"
PIP_VERSION="24.3.1"
TEST_PROGRAM="test_app.py"
MAIN_PROGRAM="app.py"

check_python_version() {
    echo "Checking Python version..."
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    if [[ $(printf '%s\n' "$REQUIRED_PYTHON_VERSION" "$PYTHON_VERSION" | sort -V | head -n1) != "$REQUIRED_PYTHON_VERSION" ]]; then
        echo "Python $REQUIRED_PYTHON_VERSION is required, but $PYTHON_VERSION is installed."
        return 1
    fi
    echo "Python version is $PYTHON_VERSION"
    return 0
}

# install_python_version() {
#     echo "Installing Python $REQUIRED_PYTHON_VERSION..."
#     if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#         sudo apt update
#         sudo apt install -y python3 python3-venv python3-pip
#     elif [[ "$OSTYPE" == "darwin"* ]]; then
#         brew install python@3.9
#     elif [[ "$OSTYPE" == "msys"* ]]; then
#         echo "Please install Python $REQUIRED_PYTHON_VERSION manually on Windows."
#         exit 1
#     else
#         echo "Unsupported OS type: $OSTYPE"
#         exit 1
#     fi
# }

install_python_version() {
    echo "Installing Python $REQUIRED_PYTHON_VERSION..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install -y software-properties-common
        sudo add-apt-repository -y ppa:deadsnakes/ppa
        sudo apt update
        sudo apt install -y "python${REQUIRED_PYTHON_VERSION%.*}" "python${REQUIRED_PYTHON_VERSION%.*}-venv" "python${REQUIRED_PYTHON_VERSION%.*}-pip"
        sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${REQUIRED_PYTHON_VERSION%.*} 1
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install "python@${REQUIRED_PYTHON_VERSION%.*}"
        export PATH="/usr/local/opt/python@${REQUIRED_PYTHON_VERSION%.*}/bin:$PATH"
    elif [[ "$OSTYPE" == "msys"* ]]; then
        echo "Installing specific Python versions is not automated on Windows."
        echo "Please install Python $REQUIRED_PYTHON_VERSION manually from https://www.python.org/downloads/"
        exit 1
    else
        echo "Unsupported OS type: $OSTYPE"
        exit 1
    fi

    INSTALLED_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    if [[ $INSTALLED_VERSION == $REQUIRED_PYTHON_VERSION ]]; then
        echo "Python $REQUIRED_PYTHON_VERSION installed successfully."
    else
        echo "Failed to install Python $REQUIRED_PYTHON_VERSION. Installed version: $INSTALLED_VERSION."
        exit 1
    fi
}

create_virtual_environment() {
    if [[ ! -d "$VENV_DIR" ]]; then
        echo "Creating virtual environment..."
        python -m venv "$VENV_DIR"
    else
        echo "Virtual environment already exists."
    fi
}

activate_virtual_environment() {
    if [[ "$OSTYPE" == "msys"* ]]; then
        "$VENV_DIR\Scripts\activate"
    else
        source "$VENV_DIR/bin/activate"
    fi
}

ensure_pip_version() {
    echo "Ensuring pip version $PIP_VERSION..."
    python -m pip install --upgrade "pip==$PIP_VERSION"
}

install_requirements() {
    if [[ -f "$REQUIREMENTS_FILE" ]]; then
        echo "Installing requirements from $REQUIREMENTS_FILE..."
        pip install -r "$REQUIREMENTS_FILE"
    else
        echo "$REQUIREMENTS_FILE not found. Skipping package installation."
    fi
}

run_tests() {
    echo "Running tests..."
    pytest $TEST_PROGRAM
}

run_main_program() {
    echo "Running main program..."
    python "$MAIN_PROGRAM"
}

if ! check_python_version; then
    install_python_version
fi

create_virtual_environment
activate_virtual_environment
ensure_pip_version
install_requirements

if ! run_tests; then
    echo "Tests failed. Exiting."
    exit 1
fi

run_main_program
