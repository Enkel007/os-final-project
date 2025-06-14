#!/bin/bash

# Rename all files in the directory that end with .f77, so that they end with .f90
for file in *.f77; do
    b=$(basename "$file" .f77)
    mv "$file" "$b.90"
done