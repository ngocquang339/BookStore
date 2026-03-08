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

@WebServlet(name = "StaffCustomerServlet", urlPatterns = { "/staff/customers" })
public class StaffCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO userDAO = new UserDAO();

        // Lấy tham số từ URL do người dùng thao tác
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");

        List<User> listCustomers = userDAO.getCustomers(keyword, sort);

        // Đẩy dữ liệu sang JSP
        request.setAttribute("listCustomers", listCustomers);

        // Đẩy lại tham số để giữ trạng thái trên thanh Tìm kiếm và Ô chọn Sắp xếp
        request.setAttribute("keyword", keyword);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("/view/staff/customer-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}