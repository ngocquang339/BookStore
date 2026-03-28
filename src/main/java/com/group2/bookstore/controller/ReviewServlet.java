package com.group2.bookstore.controller;

import com.group2.bookstore.dal.ReviewDAO;
import com.group2.bookstore.model.Review; // Bổ sung import Model
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List; 


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

            // Thiết lập header trả về JSON dùng chung cho tất cả các nhánh
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if ("update".equals(action)) {
                
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");
                
                boolean isUpdated = reviewDAO.updateReview(reviewId, user.getId(), rating, comment); 
                
                
                String ratingData = getUpdatedRatingJson(reviewDAO, bookId);
                
                response.getWriter().write("{\"success\": " + isUpdated + ", " + ratingData + "}");

            } else if ("delete".equals(action)) {
                
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                
                boolean isDeleted = reviewDAO.deleteReview(reviewId, user.getId()); 
                
                String ratingData = getUpdatedRatingJson(reviewDAO, bookId);
                
                response.getWriter().write("{\"success\": " + isDeleted + ", " + ratingData + "}");

            } else if ("report".equals(action)) {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                String reason = request.getParameter("reason");
                
                boolean isReported = reviewDAO.reportReview(reviewId, user.getId(), reason); 
                
                response.getWriter().write("{\"success\": " + isReported + "}");

            } else {
                
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");

                // Lấy ID mới từ DAO
                int newReviewId = reviewDAO.insertReview(user.getId(), bookId, rating, comment);
                
                if (newReviewId > 0) {
                    // Tính toán lại điểm số
                    String ratingData = getUpdatedRatingJson(reviewDAO, bookId);
                    
                    response.getWriter().write("{\"success\": true, \"reviewId\": " + newReviewId + ", " + ratingData + "}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST); 
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); 
        }
    }

    
private String getUpdatedRatingJson(ReviewDAO dao, int bookId) {
    List<Review> listReviews = dao.getReviewsByBookId(bookId);
    int totalReviews = listReviews.size();
    double averageRating = 0.0;
    
    int[] starCounts = new int[6];
    int[] starPercentages = new int[6];
    
    if (totalReviews > 0) {
        double sum = 0;
        for (Review r : listReviews) {
            sum += r.getRating();
            if (r.getRating() >= 1 && r.getRating() <= 5) {
                starCounts[r.getRating()]++;
            }
        }
        // Tính trung bình (VD: 4.5)
        averageRating = Math.round((sum / totalReviews) * 10.0) / 10.0;
        
        // Tính phần trăm cho từng loại sao
        for (int i = 1; i <= 5; i++) {
            starPercentages[i] = (int) Math.round((starCounts[i] * 100.0) / totalReviews);
        }
    }
    
    // Đóng gói mảng phần trăm thành JSON object {"1": 10, "2": 0, "3": 20, ...}
    String percentagesJson = String.format("{\"1\": %d, \"2\": %d, \"3\": %d, \"4\": %d, \"5\": %d}", 
        starPercentages[1], starPercentages[2], starPercentages[3], starPercentages[4], starPercentages[5]);
        
    return "\"newAverage\": " + averageRating + ", \"newTotal\": " + totalReviews + ", \"newPercentages\": " + percentagesJson;
}
}