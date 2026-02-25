package com.group2.bookstore.controller;

import com.group2.bookstore.dal.ReviewDAO;
import com.group2.bookstore.model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffReviewServlet", urlPatterns = {"/staff/reviews", "/staff/delete-review"})
public class StaffReviewServlet extends HttpServlet {

@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy tham số lọc số sao từ URL (Ví dụ: ?star=5)
        String star = request.getParameter("star");
        
        // 2. Gọi DAO để lấy dữ liệu
        ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> listReviews = reviewDAO.getReviewsByStar(star);
        
        // 3. Đẩy dữ liệu sang JSP
        request.setAttribute("listReviews", listReviews);
        request.setAttribute("selectedStar", star); // Giữ lại số sao đang chọn trên giao diện
        
        // 4. Chuyển hướng sang file JSP (Nhớ trỏ đúng thư mục staff nhé)
        request.getRequestDispatcher("/view/staff/review-manage.jsp").forward(request, response);
    }
}