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
        request.getRequestDispatcher("view/ChangePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String flag = request.getParameter("flag");
        UserDAO userDAO = new UserDAO();

        if ("1".equals(flag)) {
            String email = request.getParameter("email");
            String newPassword = request.getParameter("newPassword");
            if(email == null || newPassword == null || email.isEmpty() || newPassword.isEmpty() || email.length() > 50 || newPassword.length() > 30){
                request.setAttribute("error", "Vui lòng cung cấp thông tin hợp lệ!");
                request.getRequestDispatcher("view/Login.jsp").forward(request, response);
                return;
            }

            // 1. Kiểm tra bảo mật: Bắt buộc phải có OTP hợp lệ trong Session
            String serverOtp = (String) session.getAttribute("forgot_otp_" + email);
            if (serverOtp == null) {
                request.setAttribute("error", "Lỗi bảo mật: Phiên xác thực OTP không hợp lệ hoặc đã hết hạn!");
                request.getRequestDispatcher("view/Login.jsp").forward(request, response);
                return;
            }

            User user = userDAO.checkEmailExist(email);
            if (user != null) {
                boolean isUpdated = userDAO.changePassword(newPassword, user);

                if (isUpdated) {
                    session.removeAttribute("forgot_otp_" + email);
                    request.setAttribute("message", "Khôi phục mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
                } else {
                    request.setAttribute("error", "Lỗi hệ thống! Không thể lưu mật khẩu mới.");
                }
            } else {
                request.setAttribute("error", "Tài khoản không tồn tại!");
            }
            
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("mess", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại."); 
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 1. Lấy dữ liệu từ form
        String currentPass = request.getParameter("currentPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        if(currentPass == null || newPass == null || confirmPass == null ||
           currentPass.isEmpty() || newPass.isEmpty() || confirmPass.isEmpty() ||
           currentPass.length() > 30 || newPass.length() > 30 || confirmPass.length() > 30) {
            session.setAttribute("mess", "Tất cả các trường là bắt buộc và không được quá dài!"); 
            session.setAttribute("status", "error");
            response.sendRedirect(request.getContextPath() + "/change-password");
            return;
        }   
        
        String message = "";
        String status = "error"; 

        if (!user.getPassword().equals(currentPass)) {
            message = "Mật khẩu hiện tại không đúng!";
        }
        else if (newPass.length() < 6) {
            message = "Mật khẩu phải dài ít nhất 6 ký tự!"; 
        }
        else if (!newPass.equals(confirmPass)) {
            message = "Mật khẩu xác nhận không khớp!";
        } 
        else if (newPass.equals(currentPass)) {
            message = "Mật khẩu mới không được trùng với mật khẩu cũ!";
        }
        else {
            boolean isUpdated = userDAO.changePassword(newPass, user);

            if (isUpdated) {
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

        response.sendRedirect("change-password");
    }
}