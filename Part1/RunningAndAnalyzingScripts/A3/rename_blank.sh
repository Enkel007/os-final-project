#! /bin/bash
# rename_blank.sh
#
# Substitutes underscores for blanks in all the filenames in a directory.
ONE=1 # For getting singular/plural right (see below).For changing echo statements in the final if condition based on # of files renamed
number=0 # Keeps track of how many files actually renamed.Counter
FOUND=0 # Successful return value.Used as a flag that is true when a file with space in name is found
for filename in * #Traverse all files in directory.
do
echo "$filename" | grep -q " " # Pipes the name of the current file to the grep to check  if the file name has spaces
if [ $? -eq $FOUND ] # Flag = true if file has space in name
then
fname=$filename # Assign current file name in a temporary variable fname

n=`echo $fname | sed -e "s/ /_/g"` # Pipe name of the current file in the sedscript to subsitute space with underscore
# and save the new name on another temporary variable n.
mv "$fname" "$n" # Change the name of the current file with the new name
let "number += 1" #Increment the counter of the renamed files
fi #If Statement end
done #Loop ending
if [ "$number" -eq "$ONE" ] #If statement to change the echo statements based on # of files renamed.
then
echo "$number file renamed." #Only 1 file renamed
else
echo "$number files renamed." #+1 files renamed
fi # End if
exit 0 #End script





