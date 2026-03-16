package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "StaffCustomerNoteServlet", urlPatterns = {"/staff/note-customers"})
public class StaffCustomerNoteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy dữ liệu từ Modal gửi lên
        String notedUserIds = request.getParameter("notedUserIds");
        String contactChannel = request.getParameter("contactChannel");
        String internalNote = request.getParameter("internalNote");
        String followUpDate = request.getParameter("followUpDate");

        if (notedUserIds != null && !notedUserIds.isEmpty()) {
            UserDAO dao = new UserDAO();
            dao.addInternalNotes(notedUserIds, contactChannel, internalNote, followUpDate);
        }

        // Lưu xong thì tải lại trang danh sách và hiển thị thông báo
        response.sendRedirect(request.getContextPath() + "/staff/customers?noteSaved=1");
    }
}