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

        // 1. Lấy toàn bộ tham số từ form CRM
        String keyword = request.getParameter("keyword");
        String memberTier = request.getParameter("memberTier");
        String minPointStr = request.getParameter("minPoint");
        String maxPointStr = request.getParameter("maxPoint");

        // 2. Xử lý an toàn cho kiểu số (Tránh lỗi sập web khi bỏ trống)
        Integer minPoint = null;
        Integer maxPoint = null;
        try {
            if (minPointStr != null && !minPointStr.trim().isEmpty())
                minPoint = Integer.parseInt(minPointStr);
            if (maxPointStr != null && !maxPointStr.trim().isEmpty())
                maxPoint = Integer.parseInt(maxPointStr);
        } catch (NumberFormatException e) {
            // Bỏ qua nếu khách nhập linh tinh
        }

        // 3. Gọi DAO
        UserDAO dao = new UserDAO();
        List<User> listCustomers = dao.getFilteredCustomers(keyword, memberTier, minPoint, maxPoint);

        // 4. Trả dữ liệu về JSP
        request.setAttribute("listCustomers", listCustomers);
        request.setAttribute("keyword", keyword); // Để ô input nhớ lại chữ đã nhập

        request.getRequestDispatcher("/view/staff/customer-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}