# Script to identify missed sequences from a results file 

import sys 
import os 

import pandas as pd 

def main():
    # Check for correct number of arguments
    if len(sys.argv) != 4:
        print('Usage: python identify_missed.py <seq_file> <results_file> <output_file>')
        sys.exit(1)


    # Read in overall sequence file
    seq_file = sys.argv[1]
    seq_df = pd.read_csv(seq_file, sep='\t', header=None)
    seq_df.columns = ['seq']

    # Read in results file
    results_file = sys.argv[2]
    results_df = pd.read_csv(results_file, header=None)
    print(results_df.head())
    results_df.columns = ['seq', 'count']


    # make sure seq is string type
    results_df['seq'] = results_df['seq'].astype(str)

    results_df['count'].fillna(0, inplace=True)

    # make sure count is int type
    results_df['count'] = results_df['count'].astype(int)

    # merge rows with same sequence, keep highest count
    results_df = results_df.groupby('seq').max().reset_index()

    # make sure lenth of results df is same as number of unique sequences
    assert len(results_df) == len(results_df['seq'].unique())

    # Output file should be arg 3 
    output_file = sys.argv[3]

    len_before = len(results_df)
    # onyl keep rows with value 0 in count column
    results_df = results_df[results_df['count'] == 0]
    len_after = len(results_df)

    print('Number of sequences kept for additional processing: {}'.format(len_before - len_after))


    # Merge dataframes, keeping only sequences that were not identified
    missed_df = pd.merge(seq_df, results_df, on='seq', how='inner')

    # Drop counts column before writing to file
    missed_df.drop('count', axis=1, inplace=True)

    # shuffle rows
    missed_df = missed_df.sample(frac=1).reset_index(drop=True)

    # Write to file
    missed_df.to_csv(output_file, sep='\t', index=False, header=False)

if __name__ == '__main__':
    main()
