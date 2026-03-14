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

@WebServlet(name = "StaffReviewServlet", urlPatterns = { "/staff/reviews", "/staff/delete-review",
        "/staff/mass-delete-reviews", "/staff/mark-spam-reviews" })
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
        String bookIdStr = request.getParameter("bookId");
        String userIdStr = request.getParameter("userId");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String replyStatus = request.getParameter("replyStatus");
        String commentKeyword = request.getParameter("commentKeyword");
        int starValue = 0;
        int bookId = 0;
        int userId = 0;

        if (star != null && !star.isEmpty() && !star.equals("all")) {
            try {
                starValue = Integer.parseInt(star);
                if (starValue < 1 || starValue > 5)
                    starValue = 0;
            } catch (NumberFormatException e) {
                starValue = 0; // Nếu user nhập bậy chữ cái, ép về chế độ xem tất cả
            }
        }
        if (bookIdStr != null && !bookIdStr.isEmpty() && !bookIdStr.equals("all")) {
            try {
                bookId = Integer.parseInt(bookIdStr);
            } catch (NumberFormatException e) {
                bookId = 0;
            }
        }
        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                userId = Integer.parseInt(userIdStr);
            } catch (Exception e) {
            }
        }
        // 2. Gọi DAO để lấy dữ liệu
        ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> listReviews = reviewDAO.getFilteredReviews(starValue, bookId, userId, fromDate, toDate,
                replyStatus, commentKeyword);
        List<Review> listBooks = reviewDAO.getDistinctReviewedBooks();

        // 3. Đẩy dữ liệu sang JSP
        request.setAttribute("listReviews", listReviews);
        request.setAttribute("selectedStar", (starValue == 0) ? "" : String.valueOf(starValue));
        request.setAttribute("selectedBookId", (bookId == 0) ? "" : String.valueOf(bookId));
        request.setAttribute("selectedUserId", (userId == 0) ? "" : String.valueOf(userId));
        request.setAttribute("listBooks", listBooks);

        // 4. Chuyển hướng sang file JSP
        request.getRequestDispatcher("/view/staff/review-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lấy đường dẫn URL để biết Form nào đang gọi
        String path = request.getServletPath();

        // ==========================================
        // LUỒNG 1: XỬ LÝ NÚT BẤM "XÓA HÀNG LOẠT"
        // ==========================================
        if ("/staff/mass-delete-reviews".equals(path)) {
            String[] reviewIds = request.getParameterValues("reviewIds");

            if (reviewIds != null && reviewIds.length > 0) {
                ReviewDAO dao = new ReviewDAO();
                dao.deleteMultipleReviews(reviewIds);
            }
            response.sendRedirect(request.getContextPath() + "/staff/reviews");
            return; // Xóa xong thì kết thúc luôn, không chạy xuống dưới nữa
        }
        // ==========================================
        // LUỒNG 1.5: XỬ LÝ NÚT BẤM "ĐÁNH DẤU SPAM HÀNG LOẠT"
        // ==========================================
        if ("/staff/mark-spam-reviews".equals(path)) {
            String[] reviewIds = request.getParameterValues("reviewIds");

            if (reviewIds != null && reviewIds.length > 0) {
                ReviewDAO dao = new ReviewDAO();
                dao.markMultipleAsSpam(reviewIds); // Gọi hàm ẩn comment
            }
            response.sendRedirect(request.getContextPath() + "/staff/reviews");
            return; // Xong thì kết thúc
        }
        // ==========================================
        // LUỒNG 2: XỬ LÝ NÚT BẤM "TRẢ LỜI ĐÁNH GIÁ"
        // ==========================================
        String reviewIdStr = request.getParameter("reviewId");
        String replyText = request.getParameter("replyText");

        if (reviewIdStr != null && replyText != null && !replyText.trim().isEmpty()) {
            try {
                int reviewId = Integer.parseInt(reviewIdStr);
                ReviewDAO reviewDAO = new ReviewDAO();
                reviewDAO.updateStaffReply(reviewId, replyText);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/staff/reviews");
    }
}