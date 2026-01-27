#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
DEFAULT_COLOR='\033[0m'

CONFIG_DIRS=(btop hypr kitty nvim rofi waybar)
CONFIG_FILES=(.zshrc .p10k.zsh)
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
    local level=$1
    local msg=$2
    case "$1" in
        1) printf '%b Info: %s%b\n' "$BLUE" "$msg" "$DEFAULT_COLOR" ;; # stdout
        2) printf '%b Warn: %s%b\n' "$YELLOW" "$msg" "$DEFAULT_COLOR" >&2 ;; # stderr
        3) printf '%b Error: %s%b\n' "$RED" "$msg" "$DEFAULT_COLOR" >&2 ;; # stderr
        *) printf 'Log: %s\n' "$msg" ;;
    esac
}

check_config_files() {
    local exit_flag=0
    for dir in "${CONFIG_DIRS[@]}"; do
        log 1 "Checking directory: $dir"
        if [ ! -d "./$dir" ]; then
            exit_flag=1
            log 3 "Missing config directory: $dir. Please run 'git pull' to fix."
        fi
        if [ -d "$HOME/.config/$dir" ] || [ -L "$HOME/.config/$dir" ]; then
            exit_flag=1
            log 3 "Pre-existing config in: $HOME/.config/$dir. Please rename the directory and re-run the script."
        fi
    done
    for file in "${CONFIG_FILES[@]}"; do
        log 1 "Checking file: $file"
        if [ ! -e "./$file" ]; then
            exit_flag=1
            log 3 "Missing config file: $file. Please run 'git pull' to fix."
        fi
        if [ -e "$HOME/$file" ] || [ -L "$HOME/$file" ]; then
            exit_flag=1
            log 3 "Pre-existing config in: $HOME/.config/$file. Please rename the file and re-run the script."
        fi
    done
    if [ "$exit_flag" -eq 1 ]; then
        exit 1
    fi
}

link_files() {
    for link_dir in "${CONFIG_DIRS[@]}"; do
        ln -s "$CURRENT_DIR/$link_dir" "$HOME/.config"
    done
    for link_file in "${CONFIG_FILES[@]}"; do
        ln -s "$CURRENT_DIR/$link_file" "$HOME/$link_file"
    done
}

if [ ! -d "$HOME/.config" ]; then
    log 3 "Missing .config directory. System installation may be corrupt."
    exit 1
fi
check_config_files
link_files
