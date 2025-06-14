#!/bin/bash
# mail_format.sh (ver. 1.1): Format email messages.
# Gets rid of carets, tabs, and also folds excessively long lines.
# =================================================================
# Standard Check for Script Argument(s)
ARGS=1    #Declare that script expects only 1 argument (FileName)
E_BADARGS=85   #Error Code to exit when wrong # of args are entered
E_NOFILE=86    #Error Code to exit when filename wrong

if [ $# -ne $ARGS ]; then # Correct number of arguments passed to script?
  echo "Usage: `basename $0` filename"   #Output to help user understand how to run script
  exit $E_BADARGS
fi

if [ -f "$1" ]; then # Check if file exists.
  file_name=$1    #Saves Filename from argument to variable file_name
else
  echo "File \"$1\" does not exist."
  exit $E_NOFILE
fi

# -----------------------------------------------------------------
MAXWIDTH=70 # Width to fold excessively long lines to.
# =================================
# A variable can hold a sed script.
# It's a useful technique.
sedscript='s/^>//   #First Line removes all carates , tabs and extensive long spaces The code in the Project file produced outputs so we formated it
s/^ *>//
s/^[[:space:]]*//
s/[[:space:]]*$//'
# =================================
# Delete carets and tabs at beginning of lines,
#+ then fold lines to $MAXWIDTH characters.
sed "$sedscript" "$file_name" | fold -s --w=$MAXWIDTH
#The above command executes the sedscript with the file as parameter then pipes the
#output to the fold command to fold the text with the specficied max width
# -s option to "fold" breaks lines at whitespace, if possible.

# This script was inspired by an article in a well-known trade journal
#+ extolling a 164K MS Windows utility with similar functionality.
#
# A nice set of text processing utilities and an efficient
#+ scripting language provide an alternative to the bloated executables
#+ of a clunky operating system.
exit $?  #exit
