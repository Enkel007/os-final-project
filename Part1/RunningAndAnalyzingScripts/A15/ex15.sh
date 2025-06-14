#!/bin/bash
# ex15.sh: Generate prime numbers, without using arrays.
# Script contributed by Stephane Chazelas.
# This does *not* use the classic "Sieve of Eratosthenes" algorithm,
# but instead the more intuitive method of testing each candidate number
# for factors (divisors), using the "%" modulo operator.

LIMIT=1000 # Primes, 2 ... 1000.
# Set the limit up to which we want to find prime numbers.

Primes()
{
    (( n = $1 + 1 )) # Bump to next integer.
    # Increment the input number by 1.

    shift # Next parameter in list.
    # Shift the positional parameters to the left, discarding the first one.

    # echo "_n=$n i=$i_"
    # Uncomment for debugging: shows current value of n and i.

    if (( n == LIMIT ))
    then 
        echo $*
        # If the current number equals the limit, print all the primes found so far.
        return
    fi

    for i; do # "i" set to "@", previous values of $n.
        # Iterate over all passed parameters, which are potential primes.
        
        # echo "-n=$n i=$i-"
        # Uncomment for debugging: shows current value of n and i.
        
        (( i * i > n )) && break # Optimization.
        # If the square of i is greater than n, exit the loop.

        (( n % i )) && continue # Sift out non-primes using modulo operator.
        # If n is not divisible by i, continue to the next iteration.

        Primes $n $@ # Recursion inside loop.
        # Recursively call Primes with the current number and all primes found so far.

        return
    done

    Primes $n $@ $n # Recursion outside loop.
    # Recursively call Primes with the current number, all primes found so far, and the current number itself.

    # "$@" is the accumulating list of primes.
}

Primes 1
# Initial call to the Primes function with 1.

exit $?
# Exit the script with the status of the last command.

