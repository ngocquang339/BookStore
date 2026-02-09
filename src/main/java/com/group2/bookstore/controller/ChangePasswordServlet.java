package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng sang trang JSP để hiển thị form
        request.getRequestDispatcher("view/ChangePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        HttpSession Session = request.getSession();
        User user = (User) Session.getAttribute("user");

        // Nếu chưa đăng nhập -> đá về trang login
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Lấy dữ liệu từ form
        String currentPass = request.getParameter("currentPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        // 3. VALIDATE (Kiểm tra dữ liệu)
        String message = "";
        String status = "error"; // Mặc định là lỗi

        // Kiểm tra 1: Mật khẩu cũ có đúng không?
        // Lưu ý: Nếu bạn dùng mã hóa (MD5/BCrypt) thì phải mã hóa currentPass rồi mới so sánh
        if (!user.getPassword().equals(currentPass)) {
            message = "Mật khẩu hiện tại không đúng!";
        } 
        // Kiểm tra 2: Mật khẩu mới và xác nhận có khớp không?
        else if (!newPass.equals(confirmPass)) {
            message = "Mật khẩu xác nhận không khớp!";
        } 
        // Kiểm tra 3: Mật khẩu mới không được trùng mật khẩu cũ (Optional)
        else if (newPass.equals(currentPass)) {
            message = "Mật khẩu mới không được trùng với mật khẩu cũ!";
        }
        else {
            // 4. MỌI THỨ OK -> GỌI DAO ĐỂ UPDATE
            UserDAO userDAO = new UserDAO();
            
            // Hàm này bạn phải viết trong UserDAO: public boolean changePassword(int userId, String newPass)
            boolean isUpdated = userDAO.changePassword(newPass, user);

            if (isUpdated) {
                // Cập nhật lại password trong session để không phải đăng nhập lại
                user.setPassword(newPass);
                Session.setAttribute("user", user);
                
                message = "Đổi mật khẩu thành công!";
                status = "success";
            } else {
                message = "Lỗi hệ thống! Vui lòng thử lại sau.";
            }
        }

        // 5. Gửi thông báo về JSP (Toast Message)
        Session.setAttribute("mess", message);
        Session.setAttribute("status", status);

        // 6. Quay lại trang đổi mật khẩu
        response.sendRedirect("change-password");
    }
}
