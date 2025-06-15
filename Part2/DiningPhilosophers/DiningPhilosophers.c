#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#define N 5

enum { THINKING, HUNGRY, EATING } state[N];

pthread_mutex_t mutex;
pthread_cond_t self[N];

void test(int i) {
    if (state[i] == HUNGRY &&
        state[(i + N - 1) % N] != EATING &&
        state[(i + 1) % N] != EATING) {
        state[i] = EATING;
        pthread_cond_signal(&self[i]);
    }
}

void take_forks(int i) {
    pthread_mutex_lock(&mutex);
    state[i] = HUNGRY;
    test(i);
    while (state[i] != EATING) {
        pthread_cond_wait(&self[i], &mutex);
    }
    pthread_mutex_unlock(&mutex);
}

void put_forks(int i) {
    pthread_mutex_lock(&mutex);
    state[i] = THINKING;
    test((i + N - 1) % N);
    test((i + 1) % N);
    pthread_mutex_unlock(&mutex);
}

void *philosopher(void *arg) {
    int id = *(int *)arg;
    for (int iter = 0; iter < 100; ++iter) {
        printf("Philosopher %d is THINKING\n", id);
        usleep(rand() % 100000);

        take_forks(id);
        printf("Philosopher %d is EATING\n", id);
        usleep(rand() % 100000);

        put_forks(id);
    }
    return NULL;
}

int main() {
    pthread_t threads[N];
    int ids[N];

    pthread_mutex_init(&mutex, NULL);
    for (int i = 0; i < N; ++i) {
        pthread_cond_init(&self[i], NULL);
        state[i] = THINKING;
        ids[i] = i;
    }

    for (int i = 0; i < N; ++i)
        pthread_create(&threads[i], NULL, philosopher, &ids[i]);

    for (int i = 0; i < N; ++i)
        pthread_join(threads[i], NULL);

    pthread_mutex_destroy(&mutex);
    for (int i = 0; i < N; ++i)
        pthread_cond_destroy(&self[i]);

    return 0;
}
