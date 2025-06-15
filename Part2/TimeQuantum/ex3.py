import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math

# M/M/S Queue metrics
def mms_metrics(lambda_rate, mu, s):
    rho = lambda_rate / (s * mu)
    if rho >= 1:
        return None

    def erlang_c(lambda_, mu_, s_):
        rho_ = lambda_ / (s_ * mu_)
        summation = sum((lambda_ / mu_)**n / math.factorial(n) for n in range(s_))
        P0 = 1 / (summation + ((lambda_ / mu_)**s_ / (math.factorial(s_) * (1 - rho_))))
        Pq = ((lambda_ / mu_)**s_ * P0) / (math.factorial(s_) * (1 - rho_))
        return Pq

    Pq = erlang_c(lambda_rate, mu, s)
    Lq = Pq * lambda_rate / (s * mu - lambda_rate)
    Wq = Lq / lambda_rate
    W = Wq + 1 / mu
    L = lambda_rate * W
    return {'rho': rho, 'L': L, 'Lq': Lq, 'W': W, 'Wq': Wq}

# Simulation setup
N_values = [100, 150, 200]
M_values = [100, 150, 200]
R_values = [5, 10, 15, 20]
mu = 0.5  # Service rate: 0.5 processes per unit time

# Collect results
data = []
for N in N_values:
    for M in M_values:
        for R in R_values:
            lambda_rate = N / M
            metrics = mms_metrics(lambda_rate, mu, R)
            if metrics:
                row = {
                    'N': N,
                    'M': M,
                    'R': R,
                    'lambda': lambda_rate,
                    'rho': metrics['rho'],
                    'L': metrics['L'],
                    'Lq': metrics['Lq'],
                    'W': metrics['W'],
                    'Wq': metrics['Wq']
                }
                data.append(row)

# Create DataFrame
df = pd.DataFrame(data)

# Plotting function
def plot_metric(metric):
    fig, ax = plt.subplots(figsize=(10, 6))
    for M in sorted(df['M'].unique()):
        subset = df[df['M'] == M]
        ax.plot(subset['R'], subset[metric], marker='o', label=f'M={M}')
    ax.set_title(f'{metric} vs R (for different M)')
    ax.set_xlabel('R (Number of Servers)')
    ax.set_ylabel(metric)
    ax.legend()
    ax.grid(True)
    plt.tight_layout()
    plt.show()

# Plot selected metrics
plot_metric('L')
plot_metric('Lq')
plot_metric('W')
plot_metric('Wq')
plot_metric('rho')
