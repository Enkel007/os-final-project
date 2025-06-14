#!/bin/bash 
DIRNAME=/usr/bin 
FILETYPE="shell script" 
LOGFILE=logfile 
# Uses the file command to find the type of every file in the bin
# fgrep filters the results to show only shell scripts
# Then it uses tee to write the result to logfile
# It uses wc -l to count the number of lines in the output and
# prints it to the terminal
file "$DIRNAME"/* | fgrep "$FILETYPE" | tee $LOGFILE | wc -l 
exit 0
