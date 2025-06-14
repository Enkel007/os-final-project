#!/bin/bash

#  Write a shell script that given a person's uid, 
# tells you how many times that person is logged on.  (who, grep, wc) 

if [ $# -eq 0 ]; then
    echo "Usage: $0 <uid>"
    exit 1
fi

uid=$1

username=$(getent passwd "$uid" | cut -d: -f1)


if [ -z "$username" ]; then
    echo "No user found with uid $uid"
    exit 1
fi

login_count=$(who | grep -c "^$username "| wc -l)

echo "User $username (uid: $uid) is logged on $login_count time(s)."