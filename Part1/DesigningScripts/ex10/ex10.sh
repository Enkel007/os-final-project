#!/bin/bash
#PArt 1C -> Exercise 10
# Mail merge script to personalize letters

if [ ! -f names ] || [ ! -f template ]; then
  echo "Required files: names and template"
  exit 1
fi

while IFS= read -r name; do
  sed "s/NAME/$name/g" template > letter
  # Here you would send the letter, e.g., using mail or another method
  echo "Sending letter to $name..."
done < names

