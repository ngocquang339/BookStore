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

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng sang trang JSP để hiển thị form (Dành cho đổi MK bình thường)
        request.getRequestDispatcher("view/ChangePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String flag = request.getParameter("flag");
        UserDAO userDAO = new UserDAO();

        // ========================================================
        // NHÁNH 1: KHÔI PHỤC MẬT KHẨU (QUÊN MẬT KHẨU TỪ TRANG LOGIN)
        // ========================================================
        if ("1".equals(flag)) {
            String email = request.getParameter("email");
            String newPassword = request.getParameter("newPassword");

            // 1. Kiểm tra bảo mật: Bắt buộc phải có OTP hợp lệ trong Session
            String serverOtp = (String) session.getAttribute("forgot_otp_" + email);
            if (serverOtp == null) {
                request.setAttribute("error", "Lỗi bảo mật: Phiên xác thực OTP không hợp lệ hoặc đã hết hạn!");
                request.getRequestDispatcher("view/Login.jsp").forward(request, response);
                return;
            }

            // 2. Tìm User qua Email và cập nhật mật khẩu
            User user = userDAO.checkEmailExist(email);
            if (user != null) {
                // Gọi hàm changePassword giống như lúc đổi mật khẩu bình thường
                boolean isUpdated = userDAO.changePassword(newPassword, user);

                if (isUpdated) {
                    // Xóa OTP đi để không bị lợi dụng đổi lại lần nữa
                    session.removeAttribute("forgot_otp_" + email);
                    request.setAttribute("message", "Khôi phục mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
                } else {
                    request.setAttribute("error", "Lỗi hệ thống! Không thể lưu mật khẩu mới.");
                }
            } else {
                request.setAttribute("error", "Tài khoản không tồn tại!");
            }
            
            // Đổi xong thì trả về trang Login kèm thông báo
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return; // KẾT THÚC NHÁNH QUÊN MẬT KHẨU
        }

        // ========================================================
        // NHÁNH 2: ĐỔI MẬT KHẨU THÔNG THƯỜNG (KHI ĐÃ ĐĂNG NHẬP)
        // ========================================================
        User user = (User) session.getAttribute("user");

        // Nếu chưa đăng nhập -> đá về trang login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 1. Lấy dữ liệu từ form
        String currentPass = request.getParameter("currentPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");
        
        // 2. VALIDATE (Kiểm tra dữ liệu)
        String message = "";
        String status = "error"; // Mặc định là lỗi

        // Kiểm tra logic mật khẩu
        if (!user.getPassword().equals(currentPass)) {
            message = "Mật khẩu hiện tại không đúng!";
        } 
        else if (!newPass.equals(confirmPass)) {
            message = "Mật khẩu xác nhận không khớp!";
        } 
        else if (newPass.equals(currentPass)) {
            message = "Mật khẩu mới không được trùng với mật khẩu cũ!";
        }
        else {
            // 3. MỌI THỨ OK -> GỌI DAO ĐỂ UPDATE
            boolean isUpdated = userDAO.changePassword(newPass, user);

            if (isUpdated) {
                // Cập nhật lại password trong session để không phải đăng nhập lại
                user.setPassword(newPass);
                session.setAttribute("user", user);
                
                message = "Đổi mật khẩu thành công!";
                status = "success";
            } else {
                message = "Lỗi hệ thống! Vui lòng thử lại sau.";
            }
        }

        session.setAttribute("mess", message);
        session.setAttribute("status", status);

        // 4. Quay lại trang đổi mật khẩu
        response.sendRedirect("change-password");
    }
}