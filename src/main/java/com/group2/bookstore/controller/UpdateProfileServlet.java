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

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 2. Xử lý tiếng Việt (nếu có)
        request.setCharacterEncoding("UTF-8");

        // 3. Lấy dữ liệu người dùng nhập từ Form
        String newFullname = request.getParameter("fullname");
        String newEmail = request.getParameter("email");
        String newPhone = request.getParameter("phone_number");
        String newAddress = request.getParameter("address");

        // 4. Lấy User hiện tại từ Session ra để biết đang sửa ai
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Kiểm tra nếu session hết hạn (user null) thì đá về login
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 5. Cập nhật thông tin mới vào đối tượng User
        currentUser.setFullname(newFullname);
        currentUser.setEmail(newEmail);
        currentUser.setPhone_number(newPhone);
        currentUser.setAddress(newAddress);

        // 6. GỌI DAO ĐỂ LƯU VÀO DATABASE (QUAN TRỌNG)
        UserDAO userDAO = new UserDAO();
        boolean isUpdated = userDAO.updateUser(currentUser); 
        // (Bạn cần viết hàm updateUser trong UserDAO nhận vào 1 User và chạy lệnh SQL UPDATE)

        if (isUpdated) {
            // 7. Cập nhật lại Session (Để F5 trang Profile thấy dữ liệu mới ngay)
            session.setAttribute("user", currentUser);
            
            // Gửi thông báo thành công
            session.setAttribute("mess", "Cập nhật thành công!");
        } else {
            // Gửi thông báo thất bại
            session.setAttribute("mess", "Lỗi! Không thể cập nhật.");
        }

        // 8. Quay trở lại trang Profile
        response.sendRedirect("view/UserProfile.jsp"); // Hoặc đường dẫn map tới profile
    }
}
