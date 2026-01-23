package com.group2.bookstore.controller;

import java.io.IOException;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;

@WebServlet(name = "LoginServlet", urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String u = request.getParameter("username");
        String p = request.getParameter("password");

        // 1. Check for empty input
        if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty()) {
            request.setAttribute("mess", "Không được để trống thông tin!");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return; // STOP execution here
        }

        // 2. Check Database
        
        if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty()) {
            // Xử lý lỗi: Chuyển hướng lại trang login và báo lỗi
            request.setAttribute("mess", "Không được để trống thông tin!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        // 2. Gọi DAO để kiểm tra trong Database
        UserDAO dao = new UserDAO();
        User account = dao.checkLogin(u, p);

        if (account == null) {
            // Login Failed
            request.setAttribute("mess", "Thông tin đăng nhập không chính xác!");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
        } else {
            // Login Success
            HttpSession session = request.getSession();
            session.setAttribute("user", account);

            // 3. Redirect based on Role (AND RETURN IMMEDIATELY)
            int role = account.getRole();

            if (role == 4) {
                // Warehouse
                response.sendRedirect("warehouse/dashboard");
                return; // <--- IMPORTANT: Stop running code
            } 
            else if (role == 1) {
                // Admin
                response.sendRedirect("home"); // Or "admin/dashboard" if you have one
                return; // <--- IMPORTANT
            } 
            else {
                // Customer / Guest / Others
                response.sendRedirect("home");
                return; // <--- IMPORTANT
            }
            request.setAttribute("mess", "Thông tin đăng nhập không chính xác!");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
        } else {
            // Đăng nhập THÀNH CÔNG
            HttpSession session = request.getSession();
            session.setAttribute("user", account);

            // --- BẮT ĐẦU SỬA TỪ ĐÂY ---

            // Kiểm tra quyền (Role)
            // Lưu ý: Đảm bảo account.getRole() trả về đúng số 4 từ Database
            if (account.getRole() == 4) {
                // Nếu là Warehouse -> Chuyển sang Dashboard
                // Đường dẫn này phải khớp với urlPatterns trong WarehouseDashboardServlet
                response.sendRedirect("warehouse/dashboard");
            } else if (account.getRole() == 1) {
                // Nếu là Admin (ví dụ)
                response.sendRedirect("admin/dashboard");
                return;
            } else {
                // Các role còn lại (User/Manager) -> Về trang chủ mua hàng
                response.sendRedirect("home");
                return;
            }

            // --- KẾT THÚC SỬA ---
            session.setAttribute("user", account); // Lưu biến "user" để Home.jsp dùng
            
            // Chuyển hướng về trang chủ (hoặc trang admin tùy role)
            response.sendRedirect("home"); 
        }
    }
}