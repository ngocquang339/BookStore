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
        // 1. Gắn cờ báo hiệu cho file JSP biết là khách muốn vào thẳng form Đăng ký
        request.setAttribute("activeTab", "register");
        
        // 2. Chuyển hướng sang giao diện Login.jsp (nơi chứa cả 2 form)
        request.getRequestDispatcher("view/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fn = request.getParameter("fullname");
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        String e = request.getParameter("email");
        String phone = request.getParameter("phone_number");
        String re_p = request.getParameter("re_pass");

        // Giữ lại dữ liệu đã nhập trên form
        request.setAttribute("fullname", fn);
        request.setAttribute("username", u);
        request.setAttribute("email", e);
        request.setAttribute("phone_number", phone);

        // --- BƯỚC 1: KIỂM TRA ĐẦU VÀO (VALIDATION) ---
        if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty() || e == null || e.trim().isEmpty() || e.length() > 100 || phone == null || phone.trim().isEmpty() || fn == null || fn.trim().isEmpty()){
            request.setAttribute("mess", "Thông tin không hợp lệ!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        if((fn != null && fn.length() > 50) || (u != null && u.length() > 50)){
            request.setAttribute("mess", "Tên quá dài");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return; // Phải có return để dừng code chạy tiếp
        }

        if((p != null && p.length() > 100) || (re_p != null && re_p.length() > 100)){
            request.setAttribute("mess", "Mật khẩu quá dài");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return; 
        }

        if (!e.contains("@")) {
            request.setAttribute("mess", "Email không hợp lệ (phải chứa ký tự @)!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        if(phone.matches(".*[a-zA-Z].*") || phone.length() > 10){
            request.setAttribute("mess", "Số điện thoại không hợp lệ");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        if (re_p != null && !p.equals(re_p)) {
            request.setAttribute("mess", "Mật khẩu nhập lại không khớp!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        // --- BƯỚC 2: KIỂM TRA TRÙNG LẶP DATABASE ---
        UserDAO userdao = new UserDAO();
        
        // 2.1 Kiểm tra trùng Username
        User existingUser = userdao.checkUserExist(u);
        if (existingUser != null) {
            request.setAttribute("mess", "Tên đăng nhập đã được sử dụng!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return; 
        }
        
        // 2.2 Kiểm tra trùng Email
        User existingEmail = userdao.checkEmailExist(e);
        if (existingEmail != null) {
            request.setAttribute("mess", "Email này đã được đăng ký cho một tài khoản khác!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return; 
        }

        // --- BƯỚC 3: TẠO VÀ GỬI OTP KHI MỌI THỨ HỢP LỆ ---
        String otp = EmailUtility.getRandomOTP();

        // Gửi Email
        EmailUtility.sendEmail(e, otp);

        // Lưu thông tin tạm vào Session 
        HttpSession session = request.getSession();
        
        // 👉 ĐÃ SỬA LỖI TẠI ĐÂY: Hàm khởi tạo này có 5 tham số kiểu String (Khớp với file User.java)
        User tempUser = new User(u, p, e, fn, phone); 
        
        session.setAttribute("tempUser", tempUser); 
        session.setAttribute("otp", otp);           
        session.setAttribute("otp_time", System.currentTimeMillis()); // Hoặc otpCreationTime tùy logic Check OTP của bạn

        // Bật cờ chuyển sang bước nhập OTP (Giữ lại giao diện cũ hoặc popup của bạn)
        request.setAttribute("showOtpStep", "true");
        request.setAttribute("activeTab", "register");
        request.getRequestDispatcher("view/Login.jsp").forward(request, response);
    }
}
