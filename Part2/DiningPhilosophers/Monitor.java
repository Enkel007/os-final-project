enum State { THINKING, HUNGRY, EATING }

class Monitor {
    private final int N;
    private final State[] state;

    public Monitor(int n) {
        this.N = n;
        this.state = new State[N];
        for (int i = 0; i < N; i++) {
            state[i] = State.THINKING;
        }
    }

    public synchronized void takeForks(int i) throws InterruptedException {
        state[i] = State.HUNGRY;
        test(i);
        while (state[i] != State.EATING) {
            wait();
        }
    }

    public synchronized void putForks(int i) {
        state[i] = State.THINKING;
        test((i + N - 1) % N);
        test((i + 1) % N);
    }

    private void test(int i) {
        if (state[i] == State.HUNGRY &&
                state[(i + N - 1) % N] != State.EATING &&
                state[(i + 1) % N] != State.EATING) {
            state[i] = State.EATING;
            notifyAll();
        }
    }
}
