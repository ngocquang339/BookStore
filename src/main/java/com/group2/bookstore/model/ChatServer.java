package com.group2.bookstore.model; 

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/livechat")
public class ChatServer {
    // 1. Quản lý Staff
    private static final Set<Session> staffSessions = new CopyOnWriteArraySet<>();
    // 2. Quản lý Khách hàng (Key: Tên khách, Value: Kết nối của khách đó)
    private static final Map<String, Session> customerSessions = new ConcurrentHashMap<>();
    // 3. Kho lưu lịch sử riêng biệt cho TỪNG KHÁCH HÀNG
    private static final Map<String, List<String>> chatHistories = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("Kết nối mới: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            // ----------------------------------------------------
            // TRƯỜNG HỢP 1: STAFF ĐĂNG NHẬP VÀ XIN TẢI LỊCH SỬ
            // ----------------------------------------------------
            if (message.equals("REGISTER_STAFF")) {
                staffSessions.add(session);
                // Đổ lịch sử của TẤT CẢ khách hàng cho Staff này
                for (Map.Entry<String, List<String>> entry : chatHistories.entrySet()) {
                    String customerName = entry.getKey();
                    for (String msg : entry.getValue()) {
                        session.getBasicRemote().sendText("HISTORY|||" + customerName + "|||" + msg);
                    }
                }
                return;
            }

            // ----------------------------------------------------
            // TRƯỜNG HỢP 2: STAFF NHẮN TIN CHO KHÁCH
            // Cú pháp nhận: STAFF|||Tên Khách Nhận|||Nội dung
            // ----------------------------------------------------
            if (message.startsWith("STAFF|||")) {
                String[] parts = message.split("\\|\\|\\|");
                if (parts.length >= 3) {
                    String targetCustomer = parts[1];
                    String content = parts[2];
                    
                    // Lưu vào kho lịch sử của khách đó
                    String savedMsg = "STAFF|||" + content;
                    chatHistories.putIfAbsent(targetCustomer, new CopyOnWriteArrayList<>());
                    chatHistories.get(targetCustomer).add(savedMsg);

                    // Bắn tin nhắn về máy của Khách đó
                    Session custSession = customerSessions.get(targetCustomer);
                    if (custSession != null && custSession.isOpen()) {
                        custSession.getBasicRemote().sendText("STAFF|||" + content);
                    }

                    // Bắn lên màn hình của CÁC STAFF KHÁC để đồng bộ
                    for (Session staff : staffSessions) {
                        if (staff.isOpen()) {
                            staff.getBasicRemote().sendText("SYNC_STAFF|||" + targetCustomer + "|||" + content);
                        }
                    }
                }
            } 
            // ----------------------------------------------------
            // TRƯỜNG HỢP 3: KHÁCH HÀNG NHẮN TIN LÊN
            // Cú pháp nhận: CUST|||Tên Khách|||Nội dung
            // ----------------------------------------------------
            else if (message.startsWith("CUST|||")) {
                String[] parts = message.split("\\|\\|\\|");
                if (parts.length >= 3) {
                    String customerName = parts[1];
                    String content = parts[2];

                    // Cập nhật lại kết nối của khách này (nhỡ họ f5 trang)
                    customerSessions.put(customerName, session); 
                    
                    // Lưu vào kho lịch sử
                    String savedMsg = "CUST|||" + content;
                    chatHistories.putIfAbsent(customerName, new CopyOnWriteArrayList<>());
                    chatHistories.get(customerName).add(savedMsg);

                    // Báo động cho toàn bộ Staff: "Có tin nhắn mới từ khách hàng này!"
                    for (Session staff : staffSessions) {
                        if (staff.isOpen()) {
                            staff.getBasicRemote().sendText("SYNC_CUST|||" + customerName + "|||" + content);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session) {
        staffSessions.remove(session);
    }
}