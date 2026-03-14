package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CustomerDetailServlet", urlPatterns = {"/staff/customer-detail"})
public class CustomerDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String idRaw = request.getParameter("id");
        
        try {
            int id = Integer.parseInt(idRaw);
            UserDAO dao = new UserDAO();
            User customer = dao.getUserById(id);
            
            if (customer != null) {
                // Đẩy dữ liệu khách hàng sang JSP với tên biến là 'customer'
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("/view/staff/customer-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/customers"); // Không tìm thấy thì đá về danh sách
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/customers");
        }
    }
}