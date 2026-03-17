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
        String minSpendStr = request.getParameter("minSpend");
        String maxSpendStr = request.getParameter("maxSpend");

        // 2. Xử lý an toàn cho kiểu số (Tránh lỗi sập web khi bỏ trống)
        Double minSpend = null;
        Double maxSpend = null;
        try {
            if (minSpendStr != null && !minSpendStr.trim().isEmpty())
                minSpend = Double.parseDouble(minSpendStr);
            if (maxSpendStr != null && !maxSpendStr.trim().isEmpty())
                maxSpend = Double.parseDouble(maxSpendStr);
        } catch (NumberFormatException e) {
            // Nuốt lỗi êm ái nếu nhập chữ linh tinh
        }

        // 3. Gọi DAO "thần thánh" vừa viết
        UserDAO dao = new UserDAO();
        List<User> listCustomers = dao.getFilteredCustomers(keyword, memberTier, minSpend, maxSpend);

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