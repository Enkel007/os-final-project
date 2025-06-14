#!/bin/bash
#
# This script generates a random password consisting of alphanumeric characters.
# Author: Antek Sawicki <tenox@tenox.tc>
# Usage permission granted to the ABS Guide author.
#

# Define the character set from which the password will be generated.
MATRIX="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

# Define the length of the password.
LENGTH="8" # Change this value to generate passwords of different lengths.

# Start a loop to generate the password.
while [ "${n:=1}" -le "$LENGTH" ]
# If 'n' is not initialized, set it to 1.
do
    # Generate a random character from the MATRIX and append it to the password.
    PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}" #Each iteration appends a character of the matrix until n==LENGTH
    # The ${#MATRIX} gets the length of the MATRIX.
    # $RANDOM generates a random number, and %${#MATRIX} ensures it's within the range of the MATRIX length.
    # ${MATRIX:$(($RANDOM%${#MATRIX})):1} gets a character from the MATRIX at a random position.

    # Uncomment the line below to see the password being built character by character.
     echo "$PASS"

    # Increment 'n' for the next iteration.
    let n+=1
done

# Output the generated password.
echo "$PASS"

# Exit the script with status 0.
exit 0

