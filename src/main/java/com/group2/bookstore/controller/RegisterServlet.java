package com.group2.bookstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import com.group2.bookstore.util.EmailUtility;
import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;
import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.model.Book;

@WebServlet(name = "RegisterServlet", urlPatterns = { "/register" })
public class RegisterServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookDAO dao = new BookDAO();
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        int roleId = 0;
        if(currentUser != null){
            roleId = currentUser.getRole();
        }
        List<Book> list = dao.getRandomBook(roleId, 20);
        request.setAttribute("suggestedBooks", list);
        // 1. Gắn cờ báo hiệu cho file JSP biết là khách muốn vào thẳng form Đăng ký
        request.setAttribute("activeTab", "register");
        
        // 2. Chuyển hướng sang giao diện Login.jsp (nơi chứa cả 2 form)
        request.getRequestDispatcher("view/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("\n========== BẮT ĐẦU LUỒNG ĐĂNG KÝ ==========");
        String fn = request.getParameter("fullname");
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        String e = request.getParameter("email");
        String phone = request.getParameter("phone_number");
        String re_p = request.getParameter("re_pass");
        
        System.out.println("[1] Nhận dữ liệu: User=" + u + " | Email=" + e);

        // Giữ lại dữ liệu đã nhập trên form
        request.setAttribute("fullname", fn);
        request.setAttribute("username", u);
        request.setAttribute("email", e);
        request.setAttribute("phone_number", phone);

        // --- BƯỚC 1: KIỂM TRA ĐẦU VÀO (VALIDATION) ---
        if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty() || e == null || e.trim().isEmpty() || e.length() > 100 || phone == null || phone.trim().isEmpty() || fn == null || fn.trim().isEmpty()){
            System.out.println("[LỖI] Dữ liệu trống!");
            request.setAttribute("mess", "Thông tin không hợp lệ!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        // 1. Kiểm tra Tên đăng nhập KHÔNG chứa khoảng trắng (THÊM MỚI)
        if (u.contains(" ")) {
            request.setAttribute("mess", "Tên đăng nhập không được chứa khoảng trắng!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra Họ và tên CHỈ chứa chữ cái và khoảng trắng (THÊM MỚI)
        if (!fn.matches("^[\\p{L}\\s]+$")) {
            request.setAttribute("mess", "Họ và tên chỉ được chứa chữ cái, không chứa số hay ký tự đặc biệt!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        // 3. Kiểm tra Số điện thoại ĐÚNG 10 số và bắt đầu bằng 0 (SỬA LẠI)
        if (!phone.matches("^0\\d{9}$")) {
            request.setAttribute("mess", "Số điện thoại không hợp lệ (Phải đúng 10 số và bắt đầu bằng 0)!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        // 4. Kiểm tra Email có định dạng @domain.com
        if (!e.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            request.setAttribute("mess", "Email không đúng định dạng!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        // [BỔ SUNG EX 4]: Mật khẩu quá ngắn
        if (p.length() < 6) {
            request.setAttribute("mess", "Mật khẩu phải dài ít nhất 6 ký tự!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        if((fn != null && fn.length() > 50) || (u != null && u.length() > 50)){
            request.setAttribute("mess", "Tên quá dài");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return; 
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
        
        if(phone.matches(".*[a-zA-Z].*") || phone.length() > 10 || !phone.startsWith("0")){
            request.setAttribute("mess", "Số điện thoại không hợp lệ");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        if (re_p != null && !p.equals(re_p)) {
            System.out.println("[LỖI] Mật khẩu xác nhận không khớp!");
            request.setAttribute("mess", "Mật khẩu nhập lại không khớp!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        System.out.println("[2] Đã vượt qua kiểm tra Validation. Đang gọi DB...");
        
        // --- BƯỚC 2: KIỂM TRA TRÙNG LẶP DATABASE ---
        UserDAO userdao = new UserDAO();
        
        // 2.1 Kiểm tra trùng Username
        User existingUser = userdao.checkUserExist(u);
        if (existingUser != null) {
            System.out.println("[LỖI] -> Trùng Username trong DB!");
            request.setAttribute("mess", "Tên đăng nhập đã được sử dụng!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return; 
        }
        
        // 2.2 Kiểm tra trùng Email
        User existingEmail = userdao.checkEmailExist(e);
        if (existingEmail != null) {
            System.out.println("[LỖI] -> Trùng Email trong DB!");
            request.setAttribute("mess", "Email này đã được đăng ký cho một tài khoản khác!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return; 
        }
        
        System.out.println("[3] DB an toàn. Bắt đầu tạo OTP...");
        
        // --- BƯỚC 3: TẠO VÀ GỬI OTP KHI MỌI THỨ HỢP LỆ ---
        String otp = EmailUtility.getRandomOTP();
        System.out.println("[4] Chuẩn bị gửi email tới: " + e);
        
        // Bắt đầu bấm giờ và bọc Try-Catch để bắt lỗi Google
        long startTime = System.currentTimeMillis();
        try {
            EmailUtility.sendEmail(e, otp);
            long endTime = System.currentTimeMillis();
            System.out.println("[5] Gửi mail THÀNH CÔNG! Thời gian gửi: " + (endTime - startTime) + "ms");
            
        } catch (Exception ex) {
            // NẾU GOOGLE CHẶN (Sai pass, rớt mạng...), NÓ SẼ NHẢY VÀO ĐÂY
            System.out.println("[LỖI NGHIÊM TRỌNG] Gửi mail THẤT BẠI. Lý do:");
            ex.printStackTrace(); 
            
            // Ép form quay đầu, báo lỗi đỏ lên giao diện cho người dùng biết
            request.setAttribute("mess", "Hệ thống gửi thư đang gặp sự cố. Vui lòng thử lại sau!");
            request.setAttribute("activeTab", "register");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        System.out.println("[6] Lưu Session và chuyển hướng sang trang OTP...");

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
        
        System.out.println("========== KẾT THÚC LUỒNG ĐĂNG KÝ ==========\n");
    }
}