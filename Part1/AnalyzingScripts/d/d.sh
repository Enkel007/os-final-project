#!/bin/bash

# The script reads the file provided and pipe output to while
# tail -f follows the file and shows new line as tehy are added
# The pipe sends each new line to the while loop
tail -f home/enkel/final-project/Part1/AnalyzingScripts/d` | while read LINE; do
  echo $LINE #Echo the current tail
done #End LOOP

exit 0