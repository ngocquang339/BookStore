package com.group2.bookstore.controller;

import com.group2.bookstore.dal.SupportTicketDAO;
import com.group2.bookstore.model.SupportTicket;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffTicketServlet", urlPatterns = {"/staff/tickets"})
public class StaffTicketServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SupportTicketDAO dao = new SupportTicketDAO();
        List<SupportTicket> listTickets = dao.getAllTickets();
        
        request.setAttribute("listTickets", listTickets);
        // Trỏ tới file giao diện quản lý khiếu nại của Staff
        request.getRequestDispatcher("/view/staff/ticket-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            int userId = Integer.parseInt(request.getParameter("userId"));
            String status = request.getParameter("status"); // 3 trạng thái: Pending, Processing, Resolved
            String adminReply = request.getParameter("adminReply");

            SupportTicketDAO dao = new SupportTicketDAO();
            
            // 1. Cập nhật Ticket
            boolean isUpdated = dao.updateTicketAndReply(ticketId, status, adminReply);

            if (isUpdated) {
                // 2. Gửi thông báo về bảng Notifications cho User
                String notifyMessage = "Yêu cầu hỗ trợ (#" + ticketId + ") của bạn đã được cập nhật trạng thái: " + status;
                dao.insertNotification(userId, notifyMessage);
                
                session.setAttribute("successMessage", "Đã phản hồi và cập nhật trạng thái khiếu nại thành công!");
            } else {
                session.setAttribute("errorMessage", "Cập nhật thất bại. Vui lòng thử lại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi dữ liệu đầu vào!");
        }

        response.sendRedirect(request.getContextPath() + "/staff/tickets");
    }
}