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
        
        String action = request.getServletPath();
        ReviewDAO reviewDAO = new ReviewDAO();

        if (action.equals("/staff/delete-review")) {
            // --- XỬ LÝ XÓA ---
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                int id = Integer.parseInt(idRaw);
                reviewDAO.deleteReview(id);
            }
            // Xóa xong thì quay lại trang danh sách
            response.sendRedirect("reviews"); 
            return;
        }

        // --- XỬ LÝ HIỆN DANH SÁCH ---
        List<Review> list = reviewDAO.getAllReviews();
        request.setAttribute("listReviews", list);
        request.getRequestDispatcher("/view/admin/review-manage.jsp").forward(request, response);
    }
}