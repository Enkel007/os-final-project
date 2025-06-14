# The original script
# export SUM=0; for f in $(find src -name "*.java"); 
# do export SUM=$(($SUM + $(wc -l $f | awk '{ print $1 }'))); done; echo $SUM

# The modified script

# Initialize counter
export SUM=0

# Find all Java files
find src -name "*.java"

# Loop through files and count lines
for f in $(find src -name "*.java"); do
    export SUM=$(($SUM + $(wc -l $f | awk '{ print $1 }')))
done

# Display total
echo $SUM