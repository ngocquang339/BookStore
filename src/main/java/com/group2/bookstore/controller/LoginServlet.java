package com.group2.bookstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.group2.bookstore.dal.UserDAO; 
import com.group2.bookstore.model.User; 

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    // Xử lý khi người dùng vào trang Login (GET request)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng sang trang giao diện nhập liệu
        request.getRequestDispatcher("view/Login.jsp").forward(request, response);
    }

    // Xử lý khi người dùng bấm nút "Đăng nhập" (POST request)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Code xử lý đăng nhập sẽ viết ở đây
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        
        // 2. Gọi DAO để kiểm tra trong Database
        UserDAO dao = new UserDAO();
        User account = dao.checkLogin(u, p);

        // 3. Xử lý kết quả
        if (account == null) {
            // Trường hợp SAI: Báo lỗi và quay lại trang login
            request.setAttribute("mess", "Thông tin đăng nhập không chính xác!");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
        } else {
            // Trường hợp ĐÚNG: Lưu vào Session và về trang chủ
            HttpSession session = request.getSession();
            session.setAttribute("user", account); // Lưu biến "user" để Home.jsp dùng
            
            // Chuyển hướng về trang chủ (hoặc trang admin tùy role)
            response.sendRedirect("view/Home.jsp"); // Giả sử bạn có HomeServlet mapping là /home
            // Nếu chưa có HomeServlet thì tạm thời dẫn về file jsp:
            // response.sendRedirect("view/Home.jsp");
        }
        // ... (Logic check database) ...
    }
}
