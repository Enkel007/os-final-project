import random
import queue
import numpy as np
import matplotlib.pyplot as plt

class Process:
    def __init__(self, pid, arrival_time, burst_time):
        self.pid = pid
        self.arrival_time = arrival_time
        self.burst_time = burst_time
        self.remaining_time = burst_time
        self.start_time = None
        self.completion_time = None

    def __repr__(self):
        return f"PID={self.pid}, AT={self.arrival_time}, BT={self.burst_time}, RT={self.remaining_time}"

def generate_processes(N, M):
    processes = []
    for pid in range(N):
        arrival_time = random.randint(0, M)
        burst_time = random.randint(10, 1000)
        processes.append(Process(pid, arrival_time, burst_time))
    return processes

def mlfq_scheduler(processes, Q1, Q2, L1, L2):
    time = 0
    completed_processes = 0
    level_queues = [queue.Queue(), queue.Queue(), queue.Queue()]
    stats = {'TAT': [], 'waiting_times': [], 'response_times': []}
    process_queue = sorted(processes, key=lambda p: p.arrival_time)
    
    while completed_processes < len(processes):
        while process_queue and process_queue[0].arrival_time <= time:
            level_queues[0].put(process_queue.pop(0))
        
        for level in range(3):
            if not level_queues[level].empty():
                current_process = level_queues[level].get()
                if current_process.start_time is None:
                    current_process.start_time = time
                
                time_slice = [Q1, Q2, current_process.remaining_time][level]
                execution_time = min(time_slice, current_process.remaining_time)
                current_process.remaining_time -= execution_time
                time += execution_time

                if current_process.remaining_time == 0:
                    current_process.completion_time = time
                    completed_processes += 1
                    turnaround_time = current_process.completion_time - current_process.arrival_time
                    waiting_time = turnaround_time - current_process.burst_time
                    response_time = current_process.start_time - current_process.arrival_time
                    stats['TAT'].append(turnaround_time)
                    stats['waiting_times'].append(waiting_time)
                    stats['response_times'].append(response_time)
                else:
                    next_level = min(level + 1, 2)
                    level_queues[next_level].put(current_process)
                
                break
        else:
            time += 1  
    return stats


def calculate_metrics(stats):
    avg_turnaround_time = np.mean(stats['TAT'])
    avg_waiting_time = np.mean(stats['waiting_times'])
    avg_response_time = np.mean(stats['response_times'])
    throughput = len(stats['TAT']) / max(stats['TAT'])
    return avg_turnaround_time, avg_waiting_time, avg_response_time, throughput


def run_simulations(num_simulations, N, M, Q1_values, Q2_values, L1_values, L2_values):
    results = []
    for Q1 in Q1_values:
        for Q2 in Q2_values:
            for L1 in L1_values:
                for L2 in L2_values:
                    if L1 + L2 >= 100:
                        continue 
                    all_metrics = {'TAT': [], 'waiting_times': [], 'response_times': [], 'throughputs': []}
                    for _ in range(num_simulations):
                        processes = generate_processes(N, M)
                        stats = mlfq_scheduler(processes, Q1, Q2, L1, L2)
                        metrics = calculate_metrics(stats)
                        all_metrics['TAT'].append(metrics[0])
                        all_metrics['waiting_times'].append(metrics[1])
                        all_metrics['response_times'].append(metrics[2])
                        all_metrics['throughputs'].append(metrics[3])
                    
                    avg_metrics = (
                        np.mean(all_metrics['TAT']),
                        np.mean(all_metrics['waiting_times']),
                        np.mean(all_metrics['response_times']),
                        np.mean(all_metrics['throughputs'])
                    )
                    results.append((Q1, Q2, L1, L2, avg_metrics))
    return results


def plot_results(results):
    fig, axs = plt.subplots(2, 2, figsize=(20, 12))
    markers = ['o', 's', '^', 'D', 'v', '<', '>', 'p', '*', 'h']  
    for idx, result in enumerate(results):
        Q1, Q2, L1, L2, metrics = result
        label = f"Q1={Q1}, Q2={Q2}, L1={L1}, L2={L2}"
        marker = markers[idx % len(markers)]  
        axs[0, 0].scatter(Q1, metrics[0], alpha=0.6, label=label, marker=marker)
        axs[0, 1].scatter(Q1, metrics[1], alpha=0.6, label=label, marker=marker)
        axs[1, 0].scatter(Q1, metrics[2], alpha=0.6, label=label, marker=marker)
        axs[1, 1].scatter(Q1, metrics[3], alpha=0.6, label=label, marker=marker)

    axs[0, 0].set_title('Avg TAT vs Q1')
    axs[0, 1].set_title('Avg Waiting Time vs Q1')
    axs[1, 0].set_title('Avg Response Time vs Q1')
    axs[1, 1].set_title('Throughput vs Q1')
    for ax in axs.flat:
        ax.set_xlabel('Q1')
        ax.set_ylabel('Metrics')
    
    handles, labels = axs[0, 0].get_legend_handles_labels()
    fig.legend(handles, labels, loc='upper center', bbox_to_anchor=(0.5, -0.05), ncol=4)
    plt.tight_layout()
    plt.show()


N = 1000
M = 100
num_simulations = 10
Q1_values = [10, 20, 30, 40, 50]
Q2_values = [20, 40, 60, 80, 100]
L1_values = [10, 20, 30, 40, 50]
L2_values = [20, 40, 60, 80]


results = run_simulations(num_simulations, N, M, Q1_values, Q2_values, L1_values, L2_values)


plot_results(results)
