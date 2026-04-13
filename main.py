import numpy as np
import multiprocessing as mp
from numba import njit
from tqdm import tqdm

@njit
def cycle_mutate(x, q, p):
    n = len(x)
    for i in range(n):
        # change with prob p
        if np.random.random() <= p:
            # pick between +/- with equal prob
            if np.random.randint(0, 2) == 1:
                x[i] += 1
            else:
                x[i] -= 1
            x[i] %= q

@njit
def run_ea(start, needle, q, n, p):
    x = start.copy()
    steps = 0

    while True:
        if np.array_equal(x, needle):
            return (n, q, steps)
        cycle_mutate(x, q, p) # modifies x in place 
        steps += 1

def run_one(args):
    n, q = args
    start = np.random.randint(0, q, size=n)
    needle = np.random.randint(0, q, size=n)
    return run_ea(start, needle, q, n, 1.0 / n)

def main():
    q_low = 2
    q_high = 5
    n_low = 5
    n_high = 15 
    runs = 100  

    jobs = [(n, q) for n in range(n_low, n_high + 1)
                  for q in range(q_low, q_high + 1)
                  for _ in range(runs)]

    #gets the intitial slow compile out of the way
    _ = run_ea(np.array([0, 1]), np.array([1, 0]), 2, 2, 0.5)

    with open("results.txt", "w") as f:
        with mp.Pool() as pool:
            for results in tqdm(pool.imap_unordered(run_one, jobs), total=len(jobs)):
                line = ",".join(map(str, results))
                f.write(line + "\n")
                f.flush()

if __name__ == "__main__":
    main()
