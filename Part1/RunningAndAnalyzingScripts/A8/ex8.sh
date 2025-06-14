#!/bin/bash
# ex8.sh [make dictionary]
# Modification of /usr/sbin/mkdict (/usr/sbin/cracklib-forman) script.
# Original script copyright 1993, by Alec Muffett.
#
# This modified script included in this document in a manner
#+ consistent with the "LICENSE" document of the "Crack" package
#+ that the original script is a part of.
# This script processes text files to produce a sorted list
#+ of words found in the files.
# This may be useful for compiling dictionaries
#+ and for other lexicographic purposes.

E_BADARGS=85 # Error code for bad arguments.

# Check if at least one valid file argument is provided and readable.
if [ ! -r "$1" ]; then
  echo "Usage: $0 files-to-process"
  exit $E_BADARGS # Exit with error code if no valid file is provided.
fi

# Process the specified files.
cat $* |       # Dump the contents of all specified files to stdout.
tr A-Z a-z |   # Convert all uppercase letters to lowercase.
tr ' ' '\012' |# Convert spaces to newlines to ensure each word is on a new line.
# tr -cd '\012[a-z][0-9]' | # Original script: Remove all non-alphanumeric characters.
tr -c '\012a-z' '\012' | # Instead of deleting non-alpha characters, convert them to newlines.
sort |         # Sort the words alphabetically.
uniq |         # Remove duplicate words.
grep -v '^#' | # Remove lines that start with a hash (#).
grep -v '^$'   # Remove blank lines.

exit $? # Exit with the status of the last command.

