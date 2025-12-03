import numpy as np
import pandas as pd
import argparse
import os

def str2bool(v):
    if isinstance(v, bool):
        return v
    return v.lower() in ("true", "1", "yes", "y", "t")

def main():
    parser = argparse.ArgumentParser(argument_default=None)
    parser.add_argument("--input_csv", required=True)
    parser.add_argument("--output_csv", required=True)
    parser.add_argument("--times_2", default=False, type=str2bool)
    parser.add_argument("--times_3", default=False, type=str2bool)
    parser.add_argument("--exp_name", default=None)
    parser.add_argument("--exp_details", default=None)
    parser.add_argument("--run_id", default=None)
    args = parser.parse_args()

    # DEBUG
    print(args)

    # Load input data
    X = pd.read_csv(args.input_csv).values
    n = X.shape[1]

    # Dummy DAG: identity matrix
    A = np.eye(n)
    if args.times_2:
        A = A*2
    if args.times_3:
        A = A*3

    # Save result matrix to CSV
    pd.DataFrame(A).to_csv(args.output_csv, index=False)

if __name__ == "__main__":
    main()