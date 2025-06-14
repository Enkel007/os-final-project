#!/bin/bash
# EX6.sh
# The "hailstone" or Collatz series.
# -------------------------------------------
# 1) Get the integer "seed" from the command-line.
# 2) NUMBER <-- seed
# 3) Print NUMBER.
# 4) If NUMBER is even, divide by 2, or
# 5)+ if odd, multiply by 3 and add 1.
# 6) NUMBER <-- result
# 7) Loop back to step 3 (for specified number of iterations).
#
# The theory is that every such sequence,
#+ no matter how large the initial value,
#+ eventually settles down to repeating "4,2,1..." cycles,
#+ even after fluctuating through a wide range of values.
#
# This is an instance of an "iterate,"
#+ an operation that feeds its output back into its input.
# Sometimes the result is a "chaotic" series.
MAX_ITERATIONS=200 #max number of iterations the algorithm can do
# For large seed numbers (>32000), try increasing MAX_ITERATIONS.
h=${1:-$$} # Seed.#Use  PID if user doesnt gice an argument to the scipt
# Use $PID as seed,

#+ if not specified as command-line arg.

echo #Break Line
echo "C($h) -*- $MAX_ITERATIONS Iterations" #Header
echo #Break Line
for ((i=1; i<=MAX_ITERATIONS; i++)) #Loop for maximum number of interations (200)
do
# echo -n "$h "
# ^^^
# tab
# printf does it better ...

COLWIDTH=%7d #specify column width to wrap function
printf $COLWIDTH $h
let "remainder = h % 2" #Even/Odd checker
if [ "$remainder" -eq 0 ] # Even numbers
then
let "h /= 2" # Divide by 2.
else #Odd numbers
let "h = h*3 + 1" # Multiply by 3 and add 1.
fi #End if
COLUMNS=10 # Output 10 values per line.
let "line_break = i % $COLUMNS"
if [ "$line_break" -eq 0 ] #check for line break
then
echo #if  == true break line
fi #End if
done #End loop
echo #Line Break
# For info on this math function,
#+ see _Computers, Pattern, Chaos, and Beauty_, by Pickover, p. 185 ff.,
#+ as listed in the bibliography.
exit 0



