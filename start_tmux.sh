#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_DIR="./" 

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Project directory $PROJECT_DIR does not exist!"
    exit 1
fi

echo "Creating new tmux session for $PROJECT_NAME..."
tmux new-session -d -s "$PROJECT_NAME" -c "$PROJECT_DIR"

tmux split-window -h
tmux split-window -v

tmux send-keys -t "$PROJECT_NAME:0.0" "nvim" C-m
tmux send-keys -t "$PROJECT_NAME:0.1" "nvim" C-m
tmux send-keys -t "$PROJECT_NAME:0.2" "" C-m

tmux new-window -t "$PROJECT_NAME:1" -n "Vertical Split"

tmux split-window -h -t "$PROJECT_NAME:1.0"

tmux send-keys -t "$PROJECT_NAME:1.0" "" C-m
tmux send-keys -t "$PROJECT_NAME:1.1" "" C-m

tmux select-window -t "$PROJECT_NAME:0"

tmux attach -t "$PROJECT_NAME"
