package com.group2.bookstore.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import com.group2.bookstore.dal.OrderDAO;

// @WebListener giúp Tomcat tự động nhận diện file này lúc khởi động mà không cần khai báo lằng nhằng
@WebListener 
public class OrderStatusJob implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    // Hàm này tự động chạy MỘT LẦN DUY NHẤT khi bạn bật Server (Start Tomcat)
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        
        // Cài đặt Robot: Chạy ngay lập tức lúc bật server, sau đó cứ lặp lại mỗi 12 giờ
        scheduler.scheduleAtFixedRate(() -> {
            try {
                OrderDAO dao = new OrderDAO();
                int updatedRows = dao.autoCompleteDeliveredOrders();
                
                if (updatedRows > 0) {
                    System.out.println("[ROBOT HỆ THỐNG] Đã tự động chốt thành công " + updatedRows + " đơn hàng (Status 4 -> 5).");
                } else {
                    System.out.println("[ROBOT HỆ THỐNG] Quét đơn hàng... Không có đơn nào quá hạn 7 ngày.");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, 0, 12, TimeUnit.HOURS); // THAY ĐỔI THỜI GIAN LẶP LẠI Ở ĐÂY
        
        System.out.println("========== [JOB START] Robot quét đơn hàng tự động đã KHỞI ĐỘNG ==========");
    }

    // Hàm này tự động chạy MỘT LẦN DUY NHẤT khi bạn tắt Server (Stop Tomcat)
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
            System.out.println("========== [JOB STOP] Robot quét đơn hàng đã TẮT ==========");
        }
    }
}