package com.group2.bookstore.controller;

import com.group2.bookstore.dal.ReviewDAO;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// Chú ý: urlPatterns khớp với thuộc tính action="submit-review" trong thẻ <form> của bạn
@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int bookId = Integer.parseInt(request.getParameter("pid"));
            String action = request.getParameter("action");
            ReviewDAO reviewDAO = new ReviewDAO();

            if ("update".equals(action)) {
                // XỬ LÝ SỬA BÌNH LUẬN BẰNG AJAX
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");
                
                boolean isUpdated = reviewDAO.updateReview(reviewId, user.getId(), rating, comment); 
                
                // Trả về JSON thay vì chuyển trang
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": " + isUpdated + "}");

            } else if ("delete".equals(action)) {
                // XỬ LÝ XÓA BÌNH LUẬN BẰNG AJAX
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                
                boolean isDeleted = reviewDAO.deleteReview(reviewId, user.getId()); 
                
                // Trả về JSON thay vì chuyển trang
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": " + isDeleted + "}");

            }else if ("report".equals(action)) {
                // XỬ LÝ TỐ CÁO BÌNH LUẬN BẰNG AJAX
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                String reason = request.getParameter("reason");
                
                boolean isReported = reviewDAO.reportReview(reviewId, user.getId(), reason); 
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": " + isReported + "}");

            } else {
                // XỬ LÝ ĐĂNG BÌNH LUẬN MỚI
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");

                // Lấy ID mới từ DAO
                int newReviewId = reviewDAO.insertReview(user.getId(), bookId, rating, comment);
                
                if (newReviewId > 0) {
                    // TRẢ VỀ CHUỖI JSON CHỨA ID MỚI CHO JAVASCRIPT
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": true, \"reviewId\": " + newReviewId + "}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST); 
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); 
        }
    }
}