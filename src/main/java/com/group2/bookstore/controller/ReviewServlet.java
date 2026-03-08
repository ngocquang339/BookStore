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
        
        // Trạng thái 401 (Unauthorized): Chưa đăng nhập
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
            return;
        }

        try {
            int bookId = Integer.parseInt(request.getParameter("pid"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            ReviewDAO reviewDAO = new ReviewDAO();
            boolean isSuccess = reviewDAO.insertReview(user.getId(), bookId, rating, comment);
            
            if (isSuccess) {
                // Trạng thái 200 (OK): Thành công
                response.setStatus(HttpServletResponse.SC_OK); 
            } else {
                // Trạng thái 400 (Bad Request): Lỗi không lưu được
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST); 
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Trạng thái 500 (Internal Server Error): Lỗi code/database
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); 
        }
    }
}