package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "StaffCustomerTagServlet", urlPatterns = {"/staff/tag-customers"})
public class StaffCustomerTagServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy danh sách ID khách hàng và mảng các tag được chọn
        String taggedUserIds = request.getParameter("taggedUserIds"); 
        String[] tagsArray = request.getParameterValues("tags"); 

        if (taggedUserIds != null && !taggedUserIds.isEmpty()) {
            // Nối mảng tag thành 1 chuỗi cách nhau bằng dấu phẩy (vd: "khach_si,boom_hang")
            String tags = (tagsArray != null) ? String.join(",", tagsArray) : "";
            
            // 2. Gọi DAO để lưu DB
            UserDAO dao = new UserDAO();
            dao.updateCustomerTags(taggedUserIds, tags);
        }

        // 3. Xong việc thì load lại trang
        response.sendRedirect(request.getContextPath() + "/staff/customers");
    }
}