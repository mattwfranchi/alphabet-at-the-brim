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

requests=0
total_requests=0

for line in $(cat $1); do
    # Increment our counters
    requests=$((requests+1))
    total_requests=$((total_requests+1))
    failed_requests=0

    # term is $1 surrounded by double quotes for exact match
    # generate csv format with term, num_results
    term="\"$line\""
    (
        num_results=$(sh fetch_num_results.sh $line)
        # Check if the result is empty
        if [ -z "$num_results" ]; then
            # add to failed requests counter 
            failed_requests=$((failed_requests+1))
            echo "Failed request: $line"

        fi

        echo "$term,$num_results" >> "$temp_dir/$line.csv"
    ) &

    # generate random time to sleep between 1.00 and 5.00 seconds 
    #sleep_time=$(echo "scale=2; $RANDOM/32767*4+1" | bc)
    random_number=$(( RANDOM % 401 + 100 ))

    # Now, with alchemy's touch and a mathematician's grace,
    # We transform this integer, its decimals to embrace.
    sleep_time=$(echo "scale=2; $random_number / 100" | bc)

    # When our steps reach a hundred, we pause to let a second pass
    if [ $requests -eq 10 ]; then
        wait
        sleep $sleep_time
        echo "Total requests: $total_requests"
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

# Echo the number of failed requests
echo "Failed requests: $failed_requests"
