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
            // THÊM DÒNG NÀY ĐỂ BÁO CHO TRANG JSP BIẾT PHẢI MỞ TAB ĐĂNG KÝ
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        if((fn != null && fn.length() > 50) || (u != null && u.length() > 50)){
            request.setAttribute("mess", "Tên quá dài");
            // THÊM DÒNG NÀY ĐỂ BÁO CHO TRANG JSP BIẾT PHẢI MỞ TAB ĐĂNG KÝ
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
        }

        if((p != null && p.length() > 100) || (re_p != null && re_p.length() > 100)){
            request.setAttribute("mess", "Mật khẩu quá dài");
            // THÊM DÒNG NÀY ĐỂ BÁO CHO TRANG JSP BIẾT PHẢI MỞ TAB ĐĂNG KÝ
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
        }

        if (!e.contains("@")) {
            request.setAttribute("mess", "Email không hợp lệ (phải chứa ký tự @)!");
            // THÊM DÒNG NÀY ĐỂ BÁO CHO TRANG JSP BIẾT PHẢI MỞ TAB ĐĂNG KÝ
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        if(phone.matches(".*[a-zA-Z].*") || phone.length() > 10){
            request.setAttribute("mess", "Số điện thoại không hợp lệ");
            // THÊM DÒNG NÀY ĐỂ BÁO CHO TRANG JSP BIẾT PHẢI MỞ TAB ĐĂNG KÝ
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
        }

        if (re_p != null && !p.equals(re_p)) {
            request.setAttribute("mess", "Mật khẩu nhập lại không khớp!");
            // THÊM DÒNG NÀY ĐỂ BÁO CHO TRANG JSP BIẾT PHẢI MỞ TAB ĐĂNG KÝ
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        UserDAO userdao = new UserDAO();
        
        // 1. Kiểm tra trùng Username
        User existingUser = userdao.checkUserExist(u);
        if (existingUser != null) {
            request.setAttribute("mess", "Tên đăng nhập đã được sử dụng!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return; // Dừng luôn, không chạy xuống check email nữa
        }
        
        // 2. Kiểm tra trùng Email
        User existingEmail = userdao.checkEmailExist(e);
        if (existingEmail != null) {
            request.setAttribute("mess", "Email này đã được đăng ký cho một tài khoản khác!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return; // Dừng luôn, không gửi OTP
        }

        // ========================================================
        // 3. NẾU VƯỢT QUA HẾT MỌI BÀI TEST -> TẠO VÀ GỬI OTP
        // ========================================================
        String otp = EmailUtility.getRandomOTP();

        // Gửi Email (Có thể mất 2-3 giây)
        EmailUtility.sendEmail(e, otp);

        // Lưu thông tin tạm vào Session 
        HttpSession session = request.getSession();
        User tempUser = new User(u, p, e, fn, phone); 
        
        session.setAttribute("tempUser", tempUser); 
        session.setAttribute("otp", otp);           
        session.setAttribute("otp_time", System.currentTimeMillis()); 

        // Bật cờ chuyển sang bước nhập OTP
        request.setAttribute("showOtpStep", "true");
        request.setAttribute("activeTab", "register");
        request.getRequestDispatcher("view/Login.jsp").forward(request, response);

    }
}
