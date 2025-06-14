#!/bin/bash
# Source the hash library
source /home/enkel/final-project/Part1/RunningAndAnalyzingScripts/A20/A20.sh

# Your test commands
hash_set myhash mykey "myvalue"

hash_get_into myhash mykey result
echo $result

hash_echo myhash mykey

hash_set myhash mykey1 "myvalue1"
hash_set otherhash otherkey1 "othervalue1"

hash_copy myhash mykey1 otherhash otherkey1

hash_set myhash mykey2 "myvalue2"
hash_set myhash mykey3 "myvalue3"

hash_dup myhash mykey1 mykey2 mykey3

hash_unset myhash mykey

hash_get_ref_into myhash mykey1 ref
echo $ref

hash_echo_ref myhash mykey1

hash_set myhash myfunc "echo Testing hash"
hash_call myhash myfunc

hash_is_set myhash mykey1 && echo "Key is set" || echo "Key is not set"

myfunction() { echo "$1 = $2"; }
hash_foreach myhash myfunction