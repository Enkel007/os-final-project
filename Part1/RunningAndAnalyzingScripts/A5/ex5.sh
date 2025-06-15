#!/bin/bash
# ex5.sh: copying a data CD

# Define the CD-ROM device and output file paths
CDROM=/dev/cdrom # CD ROM device but MacOS doesnt support CD ROM
OF=/home/example/projects/cdimage.iso # output file
# Change the output file path to suit your system.

# Set the block size for copying
BLOCKSIZE=2048

# DEVICE variable for the cdrecord/wodim command
DEVICE="1,0,0"

# Prompt user to insert the source CD and press ENTER
echo; echo "Insert source CD, but do *not* mount it."
echo "Press ENTER when ready."
read ready # Wait for input, $ready not used.

# Notify user that the CD is being copied to the output file
echo; echo "Copying the source CD to $OF."
echo "This may take a while. Please be patient."

# Use dd to copy the CD-ROM to the output file with the specified block size
dd if=$CDROM of=$OF bs=$BLOCKSIZE # Raw device copy.

# Prompt user to remove the source CD and insert a blank CD-R
echo; echo "Remove data CD."
echo "Insert blank CDR."
echo "Press ENTER when ready."
read ready # Wait for input, $ready not used.

# Notify user that the output file is being copied to the blank CD-R
echo "Copying $OF to CDR."

# Use wodim to burn the ISO file to the blank CD-R
wodim -v -isosize dev=$DEVICE $OF
# Uses Joerg Schilling's "cdrecord" package (see its docs).
# http://www.fokus.gmd.de/nthp/employees/schilling/cdrecord.html
# Newer Linux distros may use "wodim" rather than "cdrecord" ...

# Notify user that the copying process is complete
echo; echo "Done copying $OF to CDR on device $CDROM."

# Ask user if they want to erase the ISO file
echo "Do you want to erase the image file (y/n)? " # Probably a huge file.
read answer

# Case statement to handle user input for erasing the ISO file
case "$answer" in
  [yY]|[yY][eE][sS]) # Accepts 'y', 'Y', 'yes', and 'Yes' as input
    rm -f $OF
    echo "$OF erased."
    ;;
  *)
    echo "$OF not erased."
    ;;
esac

# End of script
echo
exit 0

