#!/bin/bash
# ex7.sh: Number of days between two dates.
# Usage: ./ex7.sh [M]M/[D]D/YYYY [M]M/[D]D/YYYY

ARGS=2 # Two command-line parameters expected.
E_PARAM_ERR=85 # Error code for parameter error.
REFYR=1600 # Reference year for calculations.
CENTURY=100 # Number of years in a century.
DIY=365 # Number of days in a year.
ADJ_DIY=367 # Adjusted days in a year for leap years and fractions.
MIY=12 # Number of months in a year.
DIM=31 # Maximum number of days in a month.
LEAPCYCLE=4 # Leap year cycle.
MAXRETVAL=255 # Largest permissible positive return value from a function.

# Declare global variables for date difference and absolute value.
diff=
value=

# Declare global variables for day, month, year.
day=
month=
year=

# Function to handle parameter errors.
Param_Error () {
  echo "Usage: $(basename $0) [M]M/[D]D/YYYY [M]M/[D]D/YYYY"
  echo " (date must be after 1/3/1600)"
  exit $E_PARAM_ERR
}

# Function to parse date from command-line parameters.
Parse_Date () {
  month=${1%%/**} # Extract month.
  dm=${1%/**} # Extract day and month.
  day=${dm#*/} # Extract day.
  year=${1##*/} # Extract year.
}

# Function to check for invalid dates.
check_date () {
  if [ "$day" -gt "$DIM" ] || [ "$month" -gt "$MIY" ] || [ "$year" -lt "$REFYR" ]; then
    Param_Error # Exit script on invalid date.
  fi
}

# Function to strip leading zeros from day and month.
strip_leading_zero () {
  return ${1#0} # Remove leading zero.
}

# Function to calculate the day index using Gauss' formula.
day_index () {
  day=$1
  month=$2
  year=$3
  let "month = $month - 2" # Adjust month.
  if [ "$month" -le 0 ]; then
    let "month += 12" # Adjust month for negative values.
    let "year -= 1" # Adjust year.
  fi
  let "year -= $REFYR" # Adjust year by reference year.
  let "indexyr = $year / $CENTURY" # Calculate index year.
  let "Days = $DIY*$year + $year/$LEAPCYCLE - $indexyr + $indexyr/$LEAPCYCLE + $ADJ_DIY*$month/$MIY + $day - $DIM"
  # Calculate total days using Gauss' formula.
  echo $Days
}

# Function to calculate the difference between two day indices.
calculate_difference () {
  let "diff = $1 - $2" # Calculate difference.
}

# Function to calculate the absolute value.
abs () {
  if [ "$1" -lt 0 ]; then
    let "value = 0 - $1" # Change sign if negative.
  else
    let "value = $1" # Leave it alone if positive.
  fi
}

# Check if the number of command-line parameters is correct.
if [ $# -ne "$ARGS" ]; then
  Param_Error # Call function to handle error.
fi

# Parse the first date.
Parse_Date $1
check_date $day $month $year # Validate the date.
strip_leading_zero $day # Remove leading zeros from day.
day=$? # Update day variable.
strip_leading_zero $month # Remove leading zeros from month.
month=$? # Update month variable.
let "date1 = $(day_index $day $month $year)" # Calculate day index for the first date.

# Parse the second date.
Parse_Date $2
check_date $day $month $year # Validate the date.
strip_leading_zero $day # Remove leading zeros from day.
day=$? # Update day variable.
strip_leading_zero $month # Remove leading zeros from month.
month=$? # Update month variable.
date2=$(day_index $day $month $year) # Calculate day index for the second date.

# Calculate the difference between the two dates.
calculate_difference $date1 $date2
abs $diff # Get the absolute value of the difference.
diff=$value # Update diff variable with the absolute value.

# Output the difference in days.
echo $diff
exit 0 # Exit script successfully.

