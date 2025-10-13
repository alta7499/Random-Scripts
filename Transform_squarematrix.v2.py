## This script converts FST output by plink2 into a square matrix readable by Phylip.
## This script requires only the fst output from plink as input, usage: Transform_squarematrix.v2.py input_file.fst
import argparse
import pandas as pd
import numpy as np

def main(data_file, output_file):
    # Read the distance data
    df = pd.read_csv(data_file, sep='\t')

    # Extract unique population names
    populations = sorted(set(df['#POP1']) | set(df['POP2']))

    # Initialize an empty matrix
    n = len(populations)
    matrix = np.zeros((n, n))

    # Populate the matrix
    for _, row in df.iterrows():
        i = populations.index(row['#POP1'])
        j = populations.index(row['POP2'])
        matrix[i, j] = row['HUDSON_FST']
        matrix[j, i] = row['HUDSON_FST']  # Symmetric matrix
	# change the name of the columns as required

    # Extract the lower triangle
    lower_triangle = np.tril(matrix)

    # Print the resulting matrix with uniform spacing
    formatted_matrix = pd.DataFrame(matrix, index=populations)
    print(f"Distance Matrix for {data_file}:")
    for idx, row in formatted_matrix.iterrows():
        print(f"{idx:10}", end="")
        for val in row:
            print(f"{val:.6f}", end=" ")
        print()

    # Save the resulting matrix to a TSV file
    with open(output_file, 'w') as f:
        for idx, row in formatted_matrix.iterrows():
            f.write(f"{idx:10}")
            for val in row:
                f.write(f"{val:.6f} ")
            f.write('\n')
    print(f"Distance matrix saved to {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compute distance matrix from a data file.")
    parser.add_argument("data_file", help="Path to the input data file (CSV format)")
    parser.add_argument("output_file", help="Path to save the output distance matrix (CSV format)")
    args = parser.parse_args()
    main(args.data_file, args.output_file)
