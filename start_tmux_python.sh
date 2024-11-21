#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_DIR="./"
PYENV_NAME="$PROJECT_NAME"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Project directory $PROJECT_DIR does not exist!"
    exit 1
fi

tmux has-session -t "$PROJECT_NAME" 2>/dev/null

if [ $? != 0 ]; then
    echo "Creating new tmux session for $PROJECT_NAME..."
    tmux new-session -d -s "$PROJECT_NAME" -c "$PROJECT_DIR"

    tmux split-window -h
    tmux split-window -v

    tmux send-keys -t "$PROJECT_NAME:0.0" "pyenv activate $PYENV_NAME && nvim" C-m
    tmux send-keys -t "$PROJECT_NAME:0.1" "pyenv activate $PYENV_NAME && nvim" C-m
    tmux send-keys -t "$PROJECT_NAME:0.2" "pyenv activate $PYENV_NAME" C-m

    tmux new-window -t "$PROJECT_NAME:1" -n "Vertical Split"

    tmux split-window -h -t "$PROJECT_NAME:1.0"

    tmux send-keys -t "$PROJECT_NAME:1.0" "pyenv activate $PYENV_NAME" C-m
    tmux send-keys -t "$PROJECT_NAME:1.1" "pyenv activate $PYENV_NAME" C-m

    tmux select-window -t "$PROJECT_NAME:0"
else
    echo "Attaching to existing tmux session for $PROJECT_NAME..."
fi

tmux attach -t "$PROJECT_NAME"

