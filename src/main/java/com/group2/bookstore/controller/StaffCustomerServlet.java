package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffCustomerServlet", urlPatterns = {"/staff/customers"})
public class StaffCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        UserDAO userDAO = new UserDAO();
        
        // Hàm này sẽ chạy câu lệnh SQL "SELECT * FROM Users WHERE role = 2"
        List<User> listCustomers = userDAO.getAllCustomers();
        
        // Đóng gói danh sách vừa lấy được để gửi sang trang JSP
        request.setAttribute("listCustomers", listCustomers);
        
        // Chuyển hướng sang trang giao diện hiển thị
        request.getRequestDispatcher("/view/admin/customer-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}