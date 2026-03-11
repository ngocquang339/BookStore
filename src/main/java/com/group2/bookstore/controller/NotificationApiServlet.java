package com.group2.bookstore.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.group2.bookstore.dal.NotificationDAO;
import com.group2.bookstore.model.AdminNotification;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "NotificationApiServlet", urlPatterns = {"/admin/api/notifications"})
public class NotificationApiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // This tells the browser: "I am sending you raw JSON data, not a web page!"
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        NotificationDAO dao = new NotificationDAO();
        List<AdminNotification> unread = dao.getUnreadNotifications();

        // Safely building a JSON array by hand so we don't have to install external libraries like Gson right now
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < unread.size(); i++) {
            AdminNotification n = unread.get(i);
            json.append("{\"id\":").append(n.getId())
                .append(",\"orderId\":").append(n.getOrderId())
                .append(",\"message\":\"").append(n.getMessage().replace("\"", "\\\"")).append("\"}");
            
            if (i < unread.size() - 1) {
                json.append(","); // Add a comma between items
            }
        }
        json.append("]");

        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
    }

    // We will use POST to mark a notification as read when the admin clicks the "X"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            NotificationDAO dao = new NotificationDAO();
            dao.markAsRead(Integer.parseInt(idParam));
        }
    }
}