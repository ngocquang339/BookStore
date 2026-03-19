package com.group2.bookstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.dal.BookDAO;

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        int roleId = 0;
        if(currentUser != null){
            roleId = currentUser.getRole();
        }
        BookDAO dao = new BookDAO();
        List<Book> list = dao.getRandomBook(roleId, 50);
        request.setAttribute("suggestedBooks", list);
        request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // CHỈ lấy fullname từ form cơ bản này. TUYỆT ĐỐI KHÔNG lấy email và phone ở đây.
        String newFullname = request.getParameter("fullname");

        // [XỬ LÝ EX 1]: Kiểm tra tên bị bỏ trống
        if (newFullname == null || newFullname.trim().isEmpty()) {
            session.setAttribute("mess", "Full Name cannot be blank.");
            session.setAttribute("status", "error");
            response.sendRedirect(request.getContextPath() + "/update-profile");
            return;
        }

        // Chỉ cập nhật fullname
        currentUser.setFullname(newFullname.trim());

        UserDAO userDAO = new UserDAO();
        // Lưu ý: Hàm updateUser trong DAO lúc này chỉ nên update fullname, 
        // hoặc vẫn truyền nguyên đối tượng currentUser (vì email/phone cũ không bị ghi đè)
        boolean isUpdated = userDAO.updateUser(currentUser); 

        if (isUpdated) {
            currentUser.setPassword("");
            session.setAttribute("user", currentUser);
            session.setAttribute("mess", "Cập nhật thông tin thành công!");
            session.setAttribute("status", "success");
        } else {
            session.setAttribute("mess", "Lỗi! Không thể cập nhật.");
            session.setAttribute("status", "error");
        }

        response.sendRedirect(request.getContextPath() + "/update-profile");
    }
}
