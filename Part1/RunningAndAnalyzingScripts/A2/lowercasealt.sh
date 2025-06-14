#! /bin/bash
# lowercasealt.sh
# Very simpleminded filename "rename" utility (based on "lowercase.sh").
#
# The "ren" utility, by Vladimir Lanin (lanin@csd2.nyu.edu),
#+ does a much better job of this.
ARGS=2 #Script expects 2 arguments (old format)(new format)
E_BADARGS=85 #Exit status for wrong arg count
ONE=1 # For getting singular/plural right (see below).
if [ $# -ne "$ARGS" ] #checks number of arguments entered
then
echo "Usage: `basename $0` old-pattern new-pattern" #Print usage in case of wrong arg counter

# As in "rn gif jpg", which renames all gif files in working directory to jpg.
exit $E_BADARGS
fi
number=0 # Keeps track of how many files actually renamed.Later to be incremented
for filename in *$1* #Traverse all matching files in directory.
do
if [ -f "$filename" ] # If finds match...
then
fname=`basename $filename` # Strip off path.
n=`echo $fname | sed -e "s/$1/$2/"` # Substitute new for old in filename.
mv $fname $n # Rename.
let "number += 1" #Increment every for every file transformed
fi #End if
done #End loop
if [ "$number" -eq "$ONE" ] # For correct grammar.
then
echo "$number file renamed." #echo-ed if only 1 file renamed
else
echo "$number files renamed." #echo-ed if  +1 files renamed
fi #End if
exit $? #Exit
# Exercises:
# ---------
# What types of files will this not work on?
# How can this be fixed?

