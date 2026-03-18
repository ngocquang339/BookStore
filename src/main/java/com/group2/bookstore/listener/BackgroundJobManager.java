package com.group2.bookstore.listener;

import java.util.concurrent.Executors; // Adjust to your actual DAO
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import com.group2.bookstore.dal.ReturnRequestDAO;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class BackgroundJobManager implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent event) {
        System.out.println("[SYSTEM] Starting background jobs...");

        // Create a thread pool with 1 background thread
        scheduler = Executors.newSingleThreadScheduledExecutor();

        // Define the task we want to run
        Runnable autoCancelTask = new Runnable() {
            @Override
            public void run() {
                try {
                    ReturnRequestDAO dao = new ReturnRequestDAO();
                    dao.autoCancelStaleReturns();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        };

        // Schedule the task to run automatically
        // Initial delay: 0 (starts immediately when Tomcat boots)
        // Period: 1 
        // TimeUnit: DAYS (It will run exactly once every 24 hours)
        // Runs immediately, then repeats every 10 SECONDS
        scheduler.scheduleAtFixedRate(autoCancelTask, 0, 1, TimeUnit.DAYS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        System.out.println("[SYSTEM] Shutting down background jobs...");
        // CRITICAL: You must kill the thread when Tomcat stops, or it causes memory leaks!
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
    }
}
