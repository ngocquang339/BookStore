package com.group2.bookstore.controller;

import com.group2.bookstore.dal.NotificationDAO;
import com.group2.bookstore.model.Notification;
import com.group2.bookstore.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AllNotificationsServlet", urlPatterns = {"/notifications"})
public class AllNotificationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int page = 1;
        int pageSize = 10; // 10 thông báo 1 trang
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try { page = Integer.parseInt(pageStr); } catch (Exception e) {}
        }
        
        NotificationDAO dao = new NotificationDAO();
        int totalNotif = dao.getTotalNotifications(user.getId());
        int totalPages = (int) Math.ceil((double) totalNotif / pageSize);
        
        List<Notification> listNotif = dao.getNotificationsPaging(user.getId(), page, pageSize);
        
        request.setAttribute("listNotif", listNotif);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/view/notifications.jsp").forward(request, response);
    }
}