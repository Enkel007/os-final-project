#!/bin/bash

rotate_u() {
  tmp=("${block[@]}")
  block[0]=${tmp[6]}
  block[1]=${tmp[3]}
  block[2]=${tmp[0]}
  block[3]=${tmp[7]}
  block[4]=${tmp[4]}
  block[5]=${tmp[1]}
  block[6]=${tmp[8]}
  block[7]=${tmp[5]}
  block[8]=${tmp[2]}
}

rotate_u_prime() {
  tmp=("${block[@]}")
  block[0]=${tmp[2]}
  block[1]=${tmp[5]}
  block[2]=${tmp[8]}
  block[3]=${tmp[1]}
  block[4]=${tmp[4]}
  block[5]=${tmp[7]}
  block[6]=${tmp[0]}
  block[7]=${tmp[3]}
  block[8]=${tmp[6]}
}

encrypt_block() {
  key=$1
  input=$2

  for ((i=0; i<27; i++)); do
    block[i]=$(printf "%d" "'${input:$i:1}")
  done

  for k in $key; do
    case $k in
      U) rotate_u ;;
      U\') rotate_u_prime ;;
    esac
  done

  for ((i=0; i<27; i++)); do
    printf \\$(printf '%03o' ${block[i]})
  done
}

if [ $# -lt 2 ]; then
  echo "Usage: $0 <key: e.g. \"U U' U\"> <input_file>"
  exit 1
fi

key="$1"
infile="$2"

while IFS= read -r -n27 -d '' chunk || [ -n "$chunk" ]; do
  while [ ${#chunk} -lt 27 ]; do
    chunk+=$'\x00'
  done
  encrypt_block "$key" "$chunk"
done < "$infile"

echo

