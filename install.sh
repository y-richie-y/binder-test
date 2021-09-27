#!/usr/bin/env bash

GLOBAL_FLAG=--global
if [ $# -gt 1 ] || [ $# -eq 1 ] && [ "$1" != $GLOBAL_FLAG ]; then
    echo "Lambeq installer.

Usage:
  install.sh                 Run the interactive installer.
  install.sh $GLOBAL_FLAG    Install globally without prompts (not recommended)."
    exit 1
elif [ $# -eq 1 ]; then
    interative=false
    PYTHON=python3
else
    interactive=true
    if [ "$VIRTUAL_ENV" != "" ]; then
        in_venv=true
        option_text="Install in current virtual environment '$VIRTUAL_ENV'"

        echo 'Virtual environment detected.'
    else
        in_venv=false
        option_text='Install globally (not recommended)'
    fi

    echo 'Where would you like to install Lambeq?'
    echo '    1. Install in a new virtual environment.'
    echo "    2. $option_text."
    echo
    echo -n 'Choose an option: [1/2] '
    read answer

    if [ "$answer" == 1 ]; then
        create_venv=true

        echo -n 'Enter location for virtual environment: '
        read VENV
        PYTHON=$VENV/bin/python
        if [ -d "$VENV" ]; then
            if [ -f "$PYTHON" ] && [ -r "$PYTHON" ] && [ -x "$PYTHON" ]; then
                create_venv=false
                echo -n "'$VENV' is an existing virtual environment."
            else
                echo -n "'$VENV' exists, but is not a valid virtual environment."
            fi

            echo -n ' Install here anyway? [y/N] '
            read answer

            if [ "$answer" == "${answer#[Yy]}" ]; then exit; fi
        fi

        if $create_venv; then
            echo "Creating virtual environment at '$VENV'..."
            if ! python3 -m venv "$VENV"; then
                echo "Failed to create virtual environment at '$VENV'. Aborting."
                exit
            fi
        fi
    elif [ "$answer" == 2 ]; then
        PYTHON=python3
        venv=
    else
        echo 'Invalid answer. Exiting.'
        exit
    fi
fi

echo 'Installing dependencies...'
$PYTHON -m pip install --upgrade pip wheel
$PYTHON -m pip install cython numpy

echo 'Installing Lambeq...'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
$PYTHON -m pip install --use-feature=in-tree-build "$SCRIPT_DIR"

cat <<EOF

Install optional dependencies?
    1. Install PyTorch and pytest (for testing).
    2. Install PyTorch only.
    3. No optional dependencies.

EOF
echo -n 'Choose an option (default: 3): [1-3] '
read answer

if [ "$answer" == 1 ]; then
    $PYTHON -m pip install pytest pytorch
elif [ "$answer" == 2 ]; then
    $PYTHON -m pip install pytorch
else
    echo 'Not installing optional dependencies.'
fi

MODEL_DIR="$($PYTHON -c 'from depccg.download import MODEL_DIRECTORY, MODELS; print(MODEL_DIRECTORY / MODELS["en"][1])')"
if [ ! -d "$MODEL_DIR" ]; then
    download_parser=true

    if $interactive; then
        echo -n 'Download pre-trained depccg parser (recommended)? [Y/n] '
        read answer
        if [ -n "$answer" ] && [ "$answer" == "${answer#[Yy]}" ]; then
            download_parser=false
            echo 'Not downloading depccg parser; for instructions on how to download manually, see README.md or:'
            echo '    https://github.com/masashi-y/depccg#using-a-pretrained-english-parser'
        fi
    fi

    if $download_parser; then
        echo 'Downloading parser...'
        $PYTHON -m depccg en download
    fi
fi

echo 'Installation complete.'
if $interactive && [ -n "$VENV" ] && [ "$VIRTUAL_ENV" != "$VENV" ]; then
    echo "To use Lambeq, activate the virtual environment at '$VENV'."
fi
