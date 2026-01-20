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

@WebServlet(name = "LoginServlet", urlPatterns = { "/login" })
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

        if (account == null) {
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
            } else {
                // Các role còn lại (User/Manager) -> Về trang chủ mua hàng
                response.sendRedirect("view/Home.jsp");
            }

            // --- KẾT THÚC SỬA ---
        }
    }
}
