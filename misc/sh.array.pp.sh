#!/bin/bash

# Read IDs from id.txt
readarray -t ids < id.txt

# Read names from name.txt
readarray -t names < name.txt

# Ensure both arrays have the same length
# if [ ${#ids[@]} -ne ${#names[@]} ]; then
#     echo "Error: Number of IDs and names don't match"
#     exit 1
# fi

# Pair up IDs and names
for ((i=0; i<${#ids[@]}; i++)); do
    id=${ids[$i]}
    name=${names[$i]}
    
    # Call the script with the paired name and id
    ./input.sh -name "$name" -id "$id"
done

