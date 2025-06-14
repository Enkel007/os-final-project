#!/bin/bash

# Change the args script supplied earlier so that if no argument is provided, 
# "They are'' isn't printed,  and if exactly 1 argument is provided, 
# "... 1 argument'' rather than "... 1 arguments'' is printed  (use if)

if [ $# -eq 0 ]; then
    echo "There are no arguments"
elif [ $# -eq 1 ]; then
    echo "There is 1 argument"
else
    echo "There are $# arguments"
fi