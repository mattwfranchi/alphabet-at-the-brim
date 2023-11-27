import pandas as pd 
import sys 

# Script to replace empty values in a results file with 0, and remove duplicates, keeping the highest count. 
# Saves in-place.

if __name__ == '__main__': 
    results_file = sys.argv[1]

    results = pd.read_csv(results_file, header=None)

    results.columns = ['seq', 'count']

    results['count'] = results['count'].fillna(0)

    results['count'] = results['count'].astype(int)

    results['seq'] = results['seq'].astype(str)

    # keep only alphabetic sequences
    results = results[results['seq'].str.isalpha()]

    results = results.groupby('seq').max().reset_index()

    # sort sequences alphabetically
    results = results.sort_values(by='seq')

    # print % of sequences with >0 counts
    print("Success %", len(results[results['count'] > 0]) / len(results))

    results.to_csv(results_file, header=False, index=False)
