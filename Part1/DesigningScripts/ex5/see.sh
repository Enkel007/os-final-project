#!/bin/bash

# Write a shell script called see taking a filename name as argument 
# which uses ls if the file's a  directory and more if the file's otherwise (test)

# Check if teh argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

# check if the file/directory provided really exists
if [ ! -e "$1" ]; then
    echo "File or directory does not exist."
    exit 1
fi

# Check if the argument is a directory or a file
if [ -d "$1" ]; then
    ls "$1" # directory
else
    more "$1" # file
fi


