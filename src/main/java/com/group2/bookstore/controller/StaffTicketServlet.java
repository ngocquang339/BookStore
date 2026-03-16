package com.group2.bookstore.controller;

import com.group2.bookstore.dal.NotificationDAO;
import com.group2.bookstore.dal.SupportTicketDAO;
import com.group2.bookstore.model.SupportTicket;
import com.group2.bookstore.model.User;

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

    // HIỂN THỊ DANH SÁCH CHO STAFF
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // (Tùy chọn) Kiểm tra quyền Staff ở đây
        
        SupportTicketDAO dao = new SupportTicketDAO();
        List<SupportTicket> listTickets = dao.getAllTickets();
        
        request.setAttribute("listTickets", listTickets);
        request.getRequestDispatcher("/view/staff/ticket-manage.jsp").forward(request, response);
    }

    // XỬ LÝ KHI STAFF BẤM NÚT "LƯU & BẮN THÔNG BÁO"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 1. Lấy dữ liệu từ Form của Staff
        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        int customerId = Integer.parseInt(request.getParameter("userId")); // ID của khách hàng để gửi thông báo
        String status = request.getParameter("status"); // Pending, Processing, Resolved
        String adminReply = request.getParameter("adminReply");

        // 2. Cập nhật Ticket trong Database
        SupportTicketDAO ticketDao = new SupportTicketDAO();
        boolean isUpdated = ticketDao.updateTicketAndReply(ticketId, status, adminReply);

        if (isUpdated) {
            // 3. Sử dụng NotificationDAO để gửi thông báo cho "bạn của bạn" (User)
            NotificationDAO notifDao = new NotificationDAO();
            
            // Tạo nội dung thông báo
            String msg = "Khiếu nại (Mã #" + ticketId + ") của bạn đã được phản hồi! Trạng thái hiện tại: " + status;
            // Link trỏ về trang lịch sử hỗ trợ của khách
            String link = "support"; 
            
            // Gọi hàm createNotification chuẩn từ file NotificationDAO bạn vừa gửi
            notifDao.createNotification(customerId, msg, link);
            
            request.getSession().setAttribute("successMessage", "Đã phản hồi khiếu nại và gửi thông báo cho khách hàng!");
        } else {
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật khiếu nại.");
        }

        // Load lại trang danh sách
        response.sendRedirect(request.getContextPath() + "/staff/tickets");
    }
}