#!/bin/bash
#Part1C -> Exercise 7
# Copy file and prompt before overwriting

if [ $# -ne 2 ]; then
  echo "Usage: $0 <source> <destination>"
  exit 1
fi

if [ -f "$2" ]; then
  echo "File $2 exists. Overwrite? (y/n)"
  read answer
  if [ "$answer" != "y" ]; then
    echo "Copy cancelled."
    exit 0
  fi
fi

cp "$1" "$2"

