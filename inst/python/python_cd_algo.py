import numpy as np

def cd_algorithm(X: np.matrix, times_2=False, times_3=False):
    n_vars = X.shape[1]

    print(type(times_2))
    if times_2:
        constant = 2
    elif times_3:
        constant = 3
    else:
        constant = 1

    return constant * (np.ones((n_vars, n_vars)) - np.eye(n_vars))