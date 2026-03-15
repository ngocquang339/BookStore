package com.group2.bookstore.controller;

import com.group2.bookstore.dal.ReviewDAO;
import com.group2.bookstore.model.Review;
import com.group2.bookstore.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "MyCommentsServlet", urlPatterns = {"/my-comments"})
public class MyCommentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // --- LOGIC PHÂN TRANG ---
        int page = 1; // Trang mặc định là 1
        int pageSize = 5; // Số lượng bình luận hiển thị trên 1 trang
        
        // Bắt tham số 'page' từ URL (ví dụ: my-comments?page=2)
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        ReviewDAO reviewDAO = new ReviewDAO();
        
        // 1. Đếm tổng số bình luận và tính ra tổng số trang
        int totalComments = reviewDAO.getTotalReviewsByUserId(user.getId());
        int totalPages = (int) Math.ceil((double) totalComments / pageSize);
        
        // 2. Lấy danh sách bình luận của đúng trang đó
        List<Review> myComments = reviewDAO.getReviewsByUserIdPaging(user.getId(), page, pageSize);
        
        // 3. Đẩy sang JSP
        request.setAttribute("myComments", myComments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/view/my-comments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu sau này bạn muốn làm tính năng Xóa/Sửa bình luận ngay tại trang này thì viết code ở đây
        doGet(request, response);
    }
}