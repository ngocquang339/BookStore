package com.group2.bookstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.group2.bookstore.util.EmailUtility;
import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = { "/register" })
public class RegisterServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/Register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fn = request.getParameter("fullname");
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        String e = request.getParameter("email");
        String phone = request.getParameter("phone_number");
        String re_p = request.getParameter("re_pass");

        request.setAttribute("fullname", fn);
        request.setAttribute("username", u);
        request.setAttribute("email", e);
        request.setAttribute("phone_number", phone);

        if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty() || e.length() > 100 ||e.trim().isEmpty() || e == null || phone == null || phone.trim().isEmpty() || fn == null || fn.trim().isEmpty()){
            request.setAttribute("mess", "Thông tin không hợp lệ!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        if((fn != null && fn.length() > 50) || (u != null && u.length() > 50)){
            request.setAttribute("mess", "Tên quá dài");
            request.getRequestDispatcher("view/Register.jsp").forward(request, response);
        }

        if((p != null && p.length() > 100) || (re_p != null && re_p.length() > 100)){
            request.setAttribute("mess", "Mật khẩu quá dài");
            request.getRequestDispatcher("view/Register.jsp").forward(request, response);
        }

        if (!e.contains("@")) {
            request.setAttribute("mess", "Email không hợp lệ (phải chứa ký tự @)!");
            request.getRequestDispatcher("view/Register.jsp").forward(request, response);
            return;
        }

        if(phone.matches(".*[a-zA-Z].*") || phone.length() > 10){
            request.setAttribute("mess", "Số điện thoại không hợp lệ");
            request.getRequestDispatcher("view/Register.jsp").forward(request, response);
        }

        if (re_p != null && !p.equals(re_p)) {
            request.setAttribute("mess", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("view/Register.jsp").forward(request, response);
            return;
        }

        UserDAO userdao = new UserDAO();
        User us = userdao.checkUserExist(u);
        User us1 = userdao.checkEmailExist(e);
        if(us == null && us1 == null){
            // 2. Tạo mã OTP
            String otp = EmailUtility.getRandomOTP();

            // 3. Gửi Email (Có thể mất 2-3 giây)
            EmailUtility.sendEmail(e, otp);

            // 4. Lưu thông tin tạm vào Session (Chưa lưu vào DB vội)
            HttpSession session = request.getSession();
            
            // Tạo đối tượng User tạm
            User tempUser = new User(u, p, e, fn, phone); 
            
            session.setAttribute("tempUser", tempUser); // Lưu user chờ kích hoạt
            session.setAttribute("otp", otp);           // Lưu mã OTP chuẩn
            session.setAttribute("otpCreationTime", System.currentTimeMillis()); // Lưu thời gian để check hết hạn

            // 5. Chuyển hướng sang trang Nhập mã xác thực
            response.sendRedirect("view/verify-otp.jsp");
        }
        else{
            if(us != null){
                request.setAttribute("mess", "Tên đăng nhập đã tồn tại");
                request.getRequestDispatcher("view/Register.jsp").forward(request, response);
            }
            else{
                request.setAttribute("mess", "Email đã tồn tại");
                request.getRequestDispatcher("view/Register.jsp").forward(request, response);
            }
        }

    }
}
