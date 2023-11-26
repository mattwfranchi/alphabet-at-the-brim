#!/bin/bash

# Dependencies: qhtml
user_agent=`python fake-user-agent.py`
#user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"

# term is $1 surrounded by double quotes for exact match
term="\"$1\""

# Credit: https://stackoverflow.com/questions/53177265/extract-the-number-of-results-from-google-search, Pablo Bianchi
#curl --fail --silent --show-error -A "$user_agent" "https://www.google.com/search?hl=en&q=$term"
curl  --fail --silent --show-error -A "$user_agent" "https://www.bing.com/search?hl=en&q=$term"| htmlq ".sb_count" | grep -o "About.*results" | grep -o '[0-9]' | tr -d "\n"

