#!/bin/bash 
# Author: Nathan Coulter 
# This code is released to the public domain. 
# The author gave permission to use this code snippet in the ABS Guide. 
# Finds all the files in the current directory and prints their names
find -maxdepth 1 -type f -printf '%f\000' | {
    # Reads the names of the files, one by one
    while read -d $'\000'; do
        # Renames each file and adds the date and time of last modification
        mv "$REPLY" "$(date -d "$(stat -c '%y' "$REPLY")" '+%Y%m%d%H%M%S')-$REPLY"
    done
}

exit 0
# Warning: Test-drive this script in a "scratch" directory. 
# It will somehow affect all the files there.
