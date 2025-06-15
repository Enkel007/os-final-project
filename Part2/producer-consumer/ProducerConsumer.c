#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

#define BUFFER_SIZE 10

int buffer[BUFFER_SIZE];
int count = 0;

pthread_mutex_t mutex;
sem_t empty;
sem_t full;

void *producer(void *param);
void *consumer(void *param);

int main(){
    pthread_t prod, cons;
    pthread_mutex_init(&mutex, NULL);
    sem_init(&empty, 0, BUFFER_SIZE);
    sem_init(&full, 0, 0);
    
    pthread_create(&prod, NULL, producer, NULL);
    pthread_create(&cons, NULL, consumer, NULL);
    pthread_join(prod, NULL);
    pthread_join(cons, NULL);

    pthread_mutex_destroy(&mutex);
    sem_destroy(&empty);
    sem_destroy(&full);

    return 0;
}

void *producer(void *param){
    int item;
    while(1){
        item = rand() % 100;
        sem_wait(&empty);
        pthread_mutex_lock(&mutex);
        buffer[count++] = item;
        printf("Producer produced: %d\n", item);
        pthread_mutex_unlock(&mutex);
        sem_post(&full);
    }
}

void *consumer(void *param){
    int item;
    while(1){
        sem_wait(&full);
        pthread_mutex_lock(&mutex);
        item = buffer[--count];
        printf("Consumer consumed: %d\n", item);
        pthread_mutex_unlock(&mutex);
        sem_post(&empty);
    }
}