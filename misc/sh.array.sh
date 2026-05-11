#!/bin/bash

# List of items
items=(
    "纖美減肥	12"
    "音樂城	13"
    "冠生藥房	24"
    "歐冠藥房	25"
    "一寶	27"
    "正興藥房	30"
    "優佳	31"
    "奧新藥房	33"
    "忠誠	34"
    "智生	35"
    "香港融資	36"
)

# Loop through the items and call ./input.sh
for item in "${items[@]}"; do
    name=$(echo "$item" | cut -d' ' -f1)
    id=$(echo "$item" | cut -d' ' -f2)
    
    # Call the script with the extracted name and id
    ./input.sh -name "$name" -id "$id"
done

