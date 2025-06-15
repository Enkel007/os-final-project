#!/bin/bash
# Cross-platform user info script for both Linux and macOS

if [ -z "$1" ]; then
  echo "Usage: $0 <uid>"
  exit 1
fi

uid="$1"

OS_TYPE=$(uname)

if [[ "$OS_TYPE" == "Darwin" ]]; then
  username=$(dscl . -search /Users UniqueID "$uid" | awk '{print $1}')
  if [ -z "$username" ]; then
    echo "No such user"
    exit 1
  fi

  homedir=$(dscl . -read /Users/"$username" NFSHomeDirectory | cut -d ' ' -f2-)
  shell=$(dscl . -read /Users/"$username" UserShell | cut -d ' ' -f2-)
  gid=$(dscl . -read /Users/"$username" PrimaryGroupID | cut -d ' ' -f2-)
  group_name=$(dscl . -search /Groups PrimaryGroupID "$gid" | awk '{print $1}')
  groups=$(id -Gn "$username")

else
  user_info=$(getent passwd "$uid")
  if [ -z "$user_info" ]; then
    echo "No such user"
    exit 1
  fi

  username=$(echo "$user_info" | cut -d: -f1)
  homedir=$(echo "$user_info" | cut -d: -f6)
  shell=$(echo "$user_info" | cut -d: -f7)
  gid=$(echo "$user_info" | cut -d: -f4)
  group_name=$(getent group "$gid" | cut -d: -f1)
  groups=$(id -nG "$username")
fi

# Output
echo "Name: $username"
echo "Home Directory: $homedir"
echo "Shell: $shell"
echo "Group Number: $gid"
echo "Group Name: $group_name"
echo "Other Groups: $groups"
