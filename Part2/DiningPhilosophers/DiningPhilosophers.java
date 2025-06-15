
public class DiningPhilosophers {
    public static void main(String[] args) {
        int N = 5; // Change as needed
        Monitor monitor = new Monitor(N);
        for (int i = 0; i < N; i++) {
            new Philosopher(i, monitor).start();
        }
    }
}
