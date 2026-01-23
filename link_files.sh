#!/bin/bash

target_dir=dummy
declare -a folders = {
[0]="btop"
[1]="hypr"
[2]="kitty"
[3]="nvim"
[4]="rofi"
[5]="swaync"
}

declare -a files = {
[0]="vimrc"
[1]="zshrc"
}

# TODO: Check if the folder or file to add exists in the target
# directory. If so, don't link them and notify the user
for entry in "$folders"
do
    echo "Directory to link: $entry"
        ln -s $entry $target_dir
done
