#!/bin/bash

# A script, reformed, to generate and count the sequences of the English alphabet.

generate_combinations() {
    # Within the labyrinth of recursion, we conjure sequences anew.
    if [ $2 -eq 0 ]; then
        echo "$1"
    else
        for letter in {a..z}; do
            generate_combinations "$1$letter" $(($2 - 1))
        done
    fi
}

# The seeker must provide the length, n, as a numeral.
if [ $# -eq 0 ] || ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Pray, provide the sequence length as an integer, true and whole."
    exit 1
fi

# The seeker must provide a file to write the combinations to.
if [ $# -eq 1 ]; then
    echo "Pray, provide a file to write the combinations to."
    exit 1
fi

# Let the script unleash its magic, weaving the alphabetic sequences.
generate_combinations "" $1 >> $2

# The count of combinations, a simple calculation: 26^n.
total_combinations=$((26**$1))

# Reveal to the seeker the grand enumeration of combinations.
echo "Total combinations for length $1: $total_combinations"
