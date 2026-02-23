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
        
        String path = request.getServletPath();
        ReviewDAO dao = new ReviewDAO();

        // 1. XỬ LÝ XÓA
        if (path.equals("/staff/delete-review")) {
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                try {
                    int id = Integer.parseInt(idRaw);
                    dao.deleteReview(id);
                } catch (NumberFormatException e) { e.printStackTrace(); }
            }
            // KHẮC PHỤC LỖI ĐƯỜNG DẪN Ở ĐÂY: Dùng đường dẫn tuyệt đối để redirect
            response.sendRedirect(request.getContextPath() + "/staff/reviews");
            return;
        }

        // 2. XỬ LÝ LỌC THEO SAO
        String starRaw = request.getParameter("star");
        List<Review> list;
        
        if (starRaw != null && !starRaw.isEmpty()) {
            try {
                int star = Integer.parseInt(starRaw);
                list = dao.getReviewsByStar(star);
                request.setAttribute("selectedStar", star);
            } catch (Exception e) {
                list = dao.getAllReviews();
            }
        } else {
            list = dao.getAllReviews();
        }

        request.setAttribute("listReviews", list);
        request.getRequestDispatcher("/view/staff/review-manage.jsp").forward(request, response);
    }
}