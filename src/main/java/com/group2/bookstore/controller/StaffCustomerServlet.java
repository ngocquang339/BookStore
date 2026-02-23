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
        
        String keyword = request.getParameter("keyword"); 
        UserDAO userDAO = new UserDAO();
        List<User> listCustomers;
        
        // Logic tìm kiếm an toàn
        if (keyword != null && !keyword.trim().isEmpty()) {
            listCustomers = userDAO.searchCustomers(keyword);
            request.setAttribute("keyword", keyword); 
        } else {
            listCustomers = userDAO.getAllCustomers();
        }
        
        request.setAttribute("listCustomers", listCustomers);
        
        // Đường dẫn Forward tuyệt đối từ gốc webapp
        request.getRequestDispatcher("/view/staff/customer-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}