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

for line in $(cat $1); do
    # term is $1 surrounded by double quotes for exact match
    # generate csv format with term, num_results
    term="\"$line\""
    num_results=$(sh fetch_num_results.sh $line)
    echo "$term,$num_results" >> $2
    # sleep 1 second to avoid Google's bot detection
    sleep 1
done