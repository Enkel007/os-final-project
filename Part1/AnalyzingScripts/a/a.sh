#!/bin/bash
# Find the first number from 1 to 10'000 that satisfies the conditions:
# - When divided by 5, the remainder is 3
# - When divided by 7, the remainder is 4
# - When divided by 9, the remainder is 5

for nr in {1..10000}; do  # Loop thought numbers from 1 to 10,000
    # Check if the number satisfies the conditions
    if (( nr%5==3 && nr%7==4 && nr%9==5 )); then
        echo "Number = $nr" #if the conditions are met, print the number
        exit 0              # and exit the script successfully
    fi
done