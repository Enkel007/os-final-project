import java.util.LinkedList;
import java.util.concurrent.*;
import java.util.concurrent.locks.*;

public class ProducerConsumer {
    private static Buffer buffer = new Buffer();


    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(2);
        executor.execute(new Producer());
        executor.execute(new Consumer());
        executor.shutdown();
    }

    private static class Buffer {
        private static final int MAX = 4;
        private LinkedList<Integer> queue = new LinkedList<>();
        private static Lock lock = new ReentrantLock();
        private static Condition notEmpty = lock.newCondition();
        private static Condition notFull = lock.newCondition();

        public void write(int value) {
            lock.lock();
            try{
                while (queue.size() == MAX){
                    System.out.println("Buffer is full, producer is waiting...");
                    notFull.await();
                }
                queue.offer(value);
                notEmpty.signal();
            }catch(InterruptedException e){
                e.printStackTrace();
            }finally {
                lock.unlock();
            }
        }

        public int read(){
            int value = 0;
            lock.lock();
            try{
                while (queue.isEmpty()){
                    System.out.println("\tBuffer is empty, consumer is waiting...");
                    notEmpty.await();
                }
                value = queue.remove();
                notFull.signal();
            }catch(InterruptedException e){
                e.printStackTrace();
            }finally {
                lock.unlock();
                return  value;
            }
        }
    }

    private static class Producer implements Runnable {
        public void run() {
            try{
                int i = 1;
                while (true) {
                    System.out.println("Producing: " + i);
                    buffer.write(i++);
                    Thread.sleep((int)(Math.random() * 2000));
                }
            }catch(InterruptedException e){
                e.printStackTrace();
            }
        }
    }

    private static class Consumer implements Runnable {
        public void run(){
            try{
                while(true){
                    System.out.println("\tConsuming: " + buffer.read());
                    Thread.sleep((int)(Math.random() * 2000));
                }
            }catch(InterruptedException e){
                e.printStackTrace();
            }
        }
    }
}