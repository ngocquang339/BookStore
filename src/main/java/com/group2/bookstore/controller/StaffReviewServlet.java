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

// URL: /staff/reviews (Xem) và /staff/delete-review (Xóa)
@WebServlet(name = "StaffReviewServlet", urlPatterns = {"/staff/reviews", "/staff/delete-review"})
public class StaffReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        ReviewDAO dao = new ReviewDAO();

        // Nếu là hành động xóa
        if (path.equals("/staff/delete-review")) {
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                try {
                    int id = Integer.parseInt(idRaw);
                    dao.deleteReview(id); // Gọi hàm xóa
                } catch (NumberFormatException e) { e.printStackTrace(); }
            }
            // Xóa xong quay lại trang danh sách
            response.sendRedirect("reviews");
            return;
        }

        // Mặc định: Lấy danh sách hiển thị
        List<Review> list = dao.getAllReviews();
        request.setAttribute("listReviews", list);
        request.getRequestDispatcher("/view/admin/review-manage.jsp").forward(request, response);
    }
}