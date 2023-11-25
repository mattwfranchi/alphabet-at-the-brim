#!/bin/bash

# Read a file from $1, and for each line, fetch the number of results from Google. Store results in $2.

# Validate arguments.
if [ $# -eq 0 ]; then
    echo "Pray, provide a file to read from."
    exit 1
fi

if [ $# -eq 1 ]; then
    echo "Pray, provide a file to write to."
    exit 1
fi

# A temporary abode for our fleet-footed processes
temp_dir=$(mktemp -d)

counter=0
requests=0

for line in $(cat $1); do
    # Increment our counters
    ((counter++))
    ((requests++))

    # term is $1 surrounded by double quotes for exact match
    # generate csv format with term, num_results
    term="\"$line\""
    (
        num_results=$(sh fetch_num_results.sh $line)
        echo "$term,$num_results" >> "$temp_dir/$line.csv"
    ) &

    # When our steps reach a hundred, we pause to let a second pass
    if [ $requests -eq 100 ]; then
        wait
        sleep 1
        requests=0
    fi
done

wait # Wait for any remaining background tasks to complete their journey

# Collate the results into the final scroll
for file in "$temp_dir"/*; do
    cat "$file" >> $2
done

# Clean up the remnants of our temporary encampment
rm -rf "$temp_dir"
