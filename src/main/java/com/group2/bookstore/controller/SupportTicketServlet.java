package com.group2.bookstore.controller;

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

@WebServlet(name = "SupportTicketServlet", urlPatterns = {"/support"})
public class SupportTicketServlet extends HttpServlet {

    // HIỂN THỊ GIAO DIỆN & DANH SÁCH LỊCH SỬ
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        SupportTicketDAO dao = new SupportTicketDAO();
        List<SupportTicket> listTickets = dao.getTicketsByUserId(user.getId());

        request.setAttribute("listTickets", listTickets);
        request.getRequestDispatcher("view/SupportTicket.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        
        String issueType = request.getParameter("issueType");
        String ticketSubject = request.getParameter("ticketSubject");
        String ticketMessage = request.getParameter("ticketMessage");
        
        if (issueType == null || ticketSubject == null || ticketMessage == null || 
            issueType.trim().isEmpty() || ticketSubject.trim().isEmpty() || ticketMessage.trim().isEmpty()) {
            
            session.setAttribute("errorMsg", "Vui lòng điền đầy đủ các trường bắt buộc!");
            response.sendRedirect(request.getContextPath() + "/support");
            return;
        }
        
        if (ticketSubject.length() > 100) {
            session.setAttribute("errorMsg", "Tiêu đề không được vượt quá 100 ký tự!");
            response.sendRedirect(request.getContextPath() + "/support");
            return;
        }

        if (ticketMessage.length() > 1000) {
            session.setAttribute("errorMsg", "Chi tiết vấn đề không được vượt quá 1000 ký tự!");
            response.sendRedirect(request.getContextPath() + "/support");
            return;
        }
        SupportTicket ticket = new SupportTicket();
        ticket.setUserId(user.getId());
        ticket.setIssueType(issueType);
        ticket.setTicketSubject(ticketSubject);
        ticket.setTicketMessage(ticketMessage);

        SupportTicketDAO dao = new SupportTicketDAO();
        boolean isSuccess = dao.createTicket(ticket);

        if (isSuccess) {
            session.setAttribute("successMsg", "Yêu cầu hỗ trợ của bạn đã được gửi thành công! Quản trị viên sẽ phản hồi sớm nhất.");
        } else {
            session.setAttribute("errorMsg", "Gửi yêu cầu thất bại. Vui lòng thử lại sau.");
        }

        response.sendRedirect(request.getContextPath() + "/support");
    }
}