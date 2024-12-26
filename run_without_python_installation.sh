#!/bin/bash

VENV_DIR="venv"
REQUIREMENTS_FILE="requirements.txt"
PIP_VERSION="24.3.1"
TEST_PROGRAM="test_app.py"
MAIN_PROGRAM="app.py"

create_virtual_environment() {
    if [[ ! -d "$VENV_DIR" ]]; then
        echo "Creating virtual environment..."
        python3 -m venv "$VENV_DIR"
    else
        echo "Virtual environment already exists."
    fi
}

activate_virtual_environment() {
    if [[ "$OSTYPE" == "msys"* ]]; then
        source "$VENV_DIR/Scripts/activate"
    else
        source "$VENV_DIR/bin/activate"
    fi
}

ensure_pip_version() {
    echo "Ensuring pip version $PIP_VERSION..."
    pip install --upgrade "pip==$PIP_VERSION"
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

create_virtual_environment
activate_virtual_environment
ensure_pip_version
install_requirements

if ! run_tests; then
    echo "Tests failed. Exiting."
    exit 1
fi

run_main_program
