#!/bin/sh
# ex12.sh
# Strips off the header from a mail/News message i.e. till the first empty line.
# Author: Mark Moraes, University of Toronto
# ==> These comments added by author of this document.

# Check if no command-line arguments are present.
if [ $# -eq 0 ]; then
  # ==> If no command-line args present, then work on file redirected to stdin.
  sed -e '1,/^$/d' -e '/^[ ]*$/d'
  # --> Delete all lines until the first empty line (header) and then delete empty lines.
else
  # ==> If command-line args present, then work on files named.
  for i; do
    sed -e '1,/^$/d' -e '/^[ ]*$/d' $i
    # --> For each file, delete all lines until the first empty line and then delete empty lines.
  done
fi

exit

# ==> Exercise: Add error checking and other options.
# ==> Note that the small sed script repeats, except for the arg passed.
# ==> Does it make sense to embed it in a function? Why or why not?

/*
* Copyright University of Toronto 1988, 1989.
* Written by Mark Moraes
*
* Permission is granted to anyone to use this software for any purpose on
* any computer system, and to alter it and redistribute it freely, subject
* to the following restrictions:
*
* 1. The author and the University of Toronto are not responsible
*    for the consequences of use of this software, no matter how awful,
*    even if they arise from flaws in it.
*
* 2. The origin of this software must not be misrepresented, either by
*    explicit claim or by omission. Since few users ever read sources,
*    credits must appear in the documentation.
*
* 3. Altered versions must be plainly marked as such, and must not be
*    misrepresented as being the original software. Since few users
*    ever read sources, credits must appear in the documentation.
*
* 4. This notice may not be removed or altered.
*/

