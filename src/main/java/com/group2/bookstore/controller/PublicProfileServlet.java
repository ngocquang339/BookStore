package com.group2.bookstore.controller;

import com.group2.bookstore.dal.CollectionDAO;
import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.Collection;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PublicProfileServlet", urlPatterns = {"/public-profile"})
public class PublicProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy ID của người dùng từ trên thanh URL (VD: ?id=123)
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            int targetUserId = Integer.parseInt(idParam);
            
            // 2. LẤY THÔNG TIN USER TỪ DATABASE
            UserDAO userDAO = new UserDAO();
            User targetUser = userDAO.getUserById(targetUserId); // Giả định bạn đã có hàm này trong UserDAO
            
            if (targetUser == null) {
                // Nếu User ID không tồn tại (hacker gõ bừa ID) -> Đá về trang chủ
                request.setAttribute("mess", "Tài khoản người dùng không tồn tại!");
                request.getRequestDispatcher("view/home.jsp").forward(request, response);
                return;
            }
            
            // =========================================================
            // 🚨 BẢO MẬT CẤP CAO (TẨY TRẮNG DỮ LIỆU NHẠY CẢM)
            // Tuyệt đối không cho JSP có cơ hội chạm vào những thông tin này
            // =========================================================
            targetUser.setPassword("");
            targetUser.setEmail("");
            targetUser.setPhone_number("");
            targetUser.setRole(0); // Che giấu luôn Role Admin nếu có
            
            // 3. LẤY DANH SÁCH BỘ SƯU TẬP CÔNG KHAI
            CollectionDAO collectionDAO = new CollectionDAO();
            List<Collection> publicCollections = collectionDAO.getPublicCollectionsByUserId(targetUserId);
            
            // 4. ĐÓNG GÓI VÀ ĐẨY SANG TRANG GIAO DIỆN
            request.setAttribute("targetUser", targetUser);
            request.setAttribute("publicCollections", publicCollections);
            
            request.getRequestDispatcher("view/public-profile.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Xử lý ngoại lệ nếu người dùng cố tình gõ chữ cái vào tham số ID (VD: ?id=abc)
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Trang này chỉ để xem (READ-ONLY) nên không cần xử lý POST
        doGet(request, response);
    }
}