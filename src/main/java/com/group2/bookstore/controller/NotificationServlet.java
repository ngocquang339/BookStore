package com.group2.bookstore.controller;

import com.group2.bookstore.dal.NotificationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notification"})
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if ("markRead".equals(action)) {
            try {
                int notifId = Integer.parseInt(request.getParameter("notifId"));
                NotificationDAO dao = new NotificationDAO();
                dao.markAsReaded(notifId);
                response.getWriter().write("{\"success\": true}");
            } catch (Exception e) {
                response.getWriter().write("{\"success\": false}");
            }
        } 
        // THÊM NHÁNH XỬ LÝ XÓA TẠI ĐÂY
        else if ("deleteNotif".equals(action)) {
            try {
                int notifId = Integer.parseInt(request.getParameter("notifId"));
                NotificationDAO dao = new NotificationDAO();
                dao.deleteNotification(notifId);
                response.getWriter().write("{\"success\": true}");
            } catch (Exception e) {
                response.getWriter().write("{\"success\": false}");
            }
        }
        // THÊM NHÁNH XÓA TẤT CẢ TẠI ĐÂY
        else if ("deleteAllNotif".equals(action)) {
            try {
                // Lấy user đang đăng nhập từ session để bảo mật
                com.group2.bookstore.model.User user = (com.group2.bookstore.model.User) request.getSession().getAttribute("user");
                
                if (user != null) {
                    NotificationDAO dao = new NotificationDAO();
                    dao.deleteAllNotifications(user.getId()); // Chỉ xóa thông báo của đúng user này
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.getWriter().write("{\"success\": false}");
                }
            } catch (Exception e) {
                response.getWriter().write("{\"success\": false}");
            }
        }
    }
}