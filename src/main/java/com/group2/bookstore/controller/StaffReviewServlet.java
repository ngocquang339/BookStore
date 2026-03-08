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

@WebServlet(name = "StaffReviewServlet", urlPatterns = { "/staff/reviews", "/staff/delete-review" })
public class StaffReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("/staff/delete-review".equals(request.getServletPath())) {
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                try {
                    int reviewId = Integer.parseInt(idRaw);
                    ReviewDAO dao = new ReviewDAO();
                    dao.deleteReview(reviewId); // Xóa khỏi Database
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            // Xóa xong thì load lại trang danh sách đánh giá
            response.sendRedirect(request.getContextPath() + "/staff/reviews");
            return; // Kết thúc luôn, không chạy phần code hiển thị bên dưới nữa
        }
        String star = request.getParameter("star");
        int starValue = 0;
        if (star != null && !star.isEmpty() && !star.equals("all")) {
            try {
                starValue = Integer.parseInt(star);
                if (starValue < 1 || starValue > 5)
                    starValue = 0;
            } catch (NumberFormatException e) {
                starValue = 0; // Nếu user nhập bậy chữ cái, ép về chế độ xem tất cả
            }
        }
        // 2. Gọi DAO để lấy dữ liệu
        ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> listReviews = reviewDAO.getReviewsByStar(starValue);

        // 3. Đẩy dữ liệu sang JSP
        request.setAttribute("listReviews", listReviews);
        request.setAttribute("selectedStar", (starValue == 0) ? "" : String.valueOf(starValue));

        // 4. Chuyển hướng sang file JSP
        request.getRequestDispatcher("/view/staff/review-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Hỗ trợ gõ tiếng Việt có dấu không bị lỗi font
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy dữ liệu từ Popup Modal gửi lên
        String reviewIdStr = request.getParameter("reviewId");
        String replyText = request.getParameter("replyText");

        // 2. Gọi DAO để update xuống DB
        if (reviewIdStr != null && replyText != null && !replyText.trim().isEmpty()) {
            try {
                int reviewId = Integer.parseInt(reviewIdStr);
                ReviewDAO reviewDAO = new ReviewDAO();
                reviewDAO.updateStaffReply(reviewId, replyText);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 3. Update xong thì load lại trang Quản lý đánh giá
        response.sendRedirect(request.getContextPath() + "/staff/reviews");
    }
}