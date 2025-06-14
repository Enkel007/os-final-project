#!/bin/bash

# Write a shell script that asks the user to type a word in, 
# then tells the user how long that word is.  (read, wc) 

echo "Please type a word:"
read word

length=$(echo -n "$word" | wc -c)
echo "The length of the word '$word' is $length characters."
