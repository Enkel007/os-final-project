class Philosopher extends Thread {
    private final int id;
    private final Monitor monitor;

    public Philosopher(int id, Monitor monitor) {
        this.id = id;
        this.monitor = monitor;
    }

    public void run() {
        try {
            for (int i = 0; i < 100; i++) {
                System.out.println("Philosopher " + id + " THINKING");
                Thread.sleep((int)(Math.random() * 100));

                monitor.takeForks(id);
                System.out.println("Philosopher " + id + " EATING");
                Thread.sleep((int)(Math.random() * 100));

                monitor.putForks(id);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
