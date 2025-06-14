#!/bin/bash
# Hash:

# Hash function library
# Author: Mariusz Gniazdowski <mariusz.gn-at-gmail.com>
# Date: 2005-04-07
# Functions making emulating hashes in Bash a little less painful.
# Limitations:
# * Only global variables are supported.
# * Each hash instance generates one global variable per value.
# * Variable names collisions are possible
#+ if you define variable like __hash__hashname_key
# * Keys must use chars that can be part of a Bash variable name
#+ (no dashes, periods, etc.).
# * The hash is created as a variable:
# ... hashname_keyname
# So if somone will create hashes like:
# myhash_ + mykey = myhash__mykey
# myhash + _mykey = myhash__mykey
# Then there will be a collision.
# (This should not pose a major problem.)

Hash_config_varname_prefix=__hash__

# Emulates: hash[key]=value
#
# Params:
# 1 - hash
# 2 - key
# 3 - value
# Sets a global variable with name: __hash__hashname_keyname
function hash_set {
    eval "${Hash_config_varname_prefix}${1}_${2}=\"${3}\""
}

# Emulates: value=hash[key]
#
# Params:
# 1 - hash
# 2 - key
# 3 - value (name of global variable to set)
# The function gets the value of the variable and assigns it 
# to the provided variable name.
function hash_get_into {
    eval "$3=\"\$${Hash_config_varname_prefix}${1}_${2}\""
}

# Emulates: echo hash[key]
#
# Params:
# 1 - hash
# 2 - key
# 3 - echo params (like -n, for example)
# This functuon simply prints the value
function hash_echo {
    eval "echo $3 \"\$${Hash_config_varname_prefix}${1}_${2}\""
}

# Emulates: hash1[key1]=hash2[key2]
#
# Params:
# 1 - hash1
# 2 - key1
# 3 - hash2
# 4 - key2
# This function copies the value from one hash to another.
function hash_copy {
    eval "${Hash_config_varname_prefix}${1}_${2}\
=\"\$${Hash_config_varname_prefix}${3}_${4}\""
}

# Emulates: hash[keyN-1]=hash[key2]=...hash[key1]
#
# Copies first key to rest of keys.
#
# Params:
# 1 - hash1
# 2 - key1
# 3 - key2
# . . .
# N - keyN
# This function copies the value from first key to all other keys.
function hash_dup {
    local hashName="$1" keyName="$2"
    shift 2
    until [ ${#} -le 0 ]; do
        eval "${Hash_config_varname_prefix}${hashName}_${1}\
=\"\$${Hash_config_varname_prefix}${hashName}_${keyName}\""
        shift;
    done;
}

# Emulates: unset hash[key]
#
# Params:
# 1 - hash
# 2 - key
# This function deletes the variable that holds the hash key.
function hash_unset {
    eval "unset ${Hash_config_varname_prefix}${1}_${2}"
}

# Emulates something similar to: ref=&hash[key]
#
# The reference is name of the variable in which value is held.
#
# Params:
# 1 - hash
# 2 - key
# 3 - ref - Name of global variable to set.
# THis function sets the name of the variable that holds the hash key
function hash_get_ref_into {
    eval "$3=\"${Hash_config_varname_prefix}${1}_${2}\""
}

# Emulates something similar to: echo &hash[key]
#
# That reference is name of variable in which value is held.
#
# Params:
# 1 - hash
# 2 - key
# 3 - echo params (like -n for example)
# This function prints the name of the variable that holds the hash key.
function hash_echo_ref {
    eval "echo $3 \"${Hash_config_varname_prefix}${1}_${2}\""
}

# Emulates something similar to: $$hash[key](param1, param2, ...)
#
# Params:
# 1 - hash
# 2 - key
# 3,4, ... - Function parameters
# It calls the function that is stored in the hash key and
# passes the parameters to it.
function hash_call {
    local hash key
    hash=$1
    key=$2
    shift 2
    eval "eval \"\$${Hash_config_varname_prefix}${hash}_${key} \\\"\\\$@\\\"\""
}

# Emulates something similar to: isset(hash[key]) or hash[key]==NULL
#
# Params:
# 1 - hash
# 2 - key
# Returns:
# 0 - there is such key
# 1 - there is no such key
# Checks if the hash key is set.
function hash_is_set {
    eval "if [[ \"\${${Hash_config_varname_prefix}${1}_${2}-a}\" = \"a\" &&
\"\${${Hash_config_varname_prefix}${1}_${2}-b}\" = \"b\" ]]
then return 1; else return 0; fi"
}

# Emulates something similar to:
# foreach($hash as $key => $value) { fun($key,$value); }
#
# It is possible to write different variations of this function.
# Here we use a function call to make it as "generic" as possible.
#
# Params:
# 1 - hash
# 2 - function name
# This function iterates over all keys in the hash and calls
# the provided function with two parameters: key and value.
function hash_foreach {
    local keyname oldIFS="$IFS"
    IFS=' '
    for i in $(eval "echo \${!${Hash_config_varname_prefix}${1}_*}"); do
        keyname=$(eval "echo \${i##${Hash_config_varname_prefix}${1}_}")
        eval "$2 $keyname \"\$$i\""
    done
    IFS="$oldIFS"
}

# NOTE: In lines 103 and 116, ampersand changed.
# But, it doesn't matter, because these are comment lines anyhow