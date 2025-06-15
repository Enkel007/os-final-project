#!/bin/bash
# ex9.sh: Calculate "soundex" code for names
# =======================================================
# Soundex script
# by
# Mendel Cooper
# thegrendel.abs@gmail.com
# reldate: 23 January, 2002
#
# Placed in the Public Domain.
#
# A slightly different version of this script appeared in
# Ed Schaefer's July, 2002 "Shell Corner" column
# in "Unix Review" on-line,
# http://www.unixreview.com/documents/uni1026336632258/
# =======================================================
ARGCOUNT=1  # Expect exactly one argument.
E_WRONGARGS=90  # Error code for incorrect number of arguments.

# Check if the number of arguments is correct.
if [ $# -ne "$ARGCOUNT" ]; then
  echo "Usage: $(basename $0) name"  # Print usage message.
  exit $E_WRONGARGS  # Exit with error code.
fi

# Function to assign numerical values to letters of the name.
assign_value () {
  val1=bfpv  # 'b,f,p,v' = 1
  val2=cgjkqsxz  # 'c,g,j,k,q,s,x,z' = 2
  val3=dt  # 'd,t' = 3
  val4=l  # 'l' = 4
  val5=mn  # 'm,n' = 5
  val6=r  # 'r' = 6

  # Assign numerical values, remove duplicates, and strip vowels.
  value=$(echo "$1" | tr -d wh \
    | tr $val1 1 | tr $val2 2 | tr $val3 3 \
    | tr $val4 4 | tr $val5 5 | tr $val6 6 \
    | tr -s 123456 \
    | tr -d aeiouy)
}

input_name="$1"  # Store input name.
echo
echo "Name = $input_name"

# Change all characters of name input to lowercase.
name=$(echo $input_name | tr A-Z a-z)

# Prefix of soundex code: first letter of name.
char_pos=0  # Initialize character position.
prefix0=${name:$char_pos:1}  # Get first letter.
prefix=$(echo $prefix0 | tr a-z A-Z)  # Convert to uppercase.

let "char_pos += 1"  # Move to the second letter.
name1=${name:$char_pos}  # Get the rest of the name.

# Exception Patch to handle special cases.
char1=$(echo $prefix | tr A-Z a-z)  # First letter in lowercase.
assign_value $name  # Assign values to the name.
s1=$value
assign_value $name1  # Assign values to the name shifted one character.
s2=$value

assign_value $char1  # Assign value to the first letter.
s3=$value
s3=9$s3  # If the first letter is a vowel, 'w', or 'h', set value to '9'.

# Determine the suffix based on special conditions.
if [[ "$s1" -ne "$s2" || "$s3" -eq 9 ]]; then
  suffix=$s2
else
  suffix=${s2:$char_pos}
fi

padding=000  # Use at most 3 zeros to pad.
soun=$prefix$suffix$padding  # Combine prefix, suffix, and padding.
MAXLEN=4  # Maximum length of soundex code.
soundex=${soun:0:$MAXLEN}  # Truncate to 4 characters.
echo "Soundex = $soundex"
echo

# The soundex code is a method of indexing and classifying names
# by grouping together the ones that sound alike.
# The soundex code for a given name is the first letter of the name,
# followed by a calculated three-number code.
# Similar sounding names should have almost the same soundex codes.
# Examples:
# Smith and Smythe both have a "S-530" soundex.
# Harrison = H-625
# Hargison = H-622
# Harriman = H-655
# This works out fairly well in practice, but there are numerous anomalies.
#
# The U.S. Census and certain other governmental agencies use soundex,
# as do genealogical researchers.
#
# For more information,
# see the "National Archives and Records Administration home page",
# http://www.nara.gov/genealogy/soundex/soundex.html

# Exercise:
# --------
# Simplify the "Exception Patch" section of this script.

exit 0  # Exit the script.

