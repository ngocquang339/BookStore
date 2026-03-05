package com.group2.bookstore.controller;

import com.group2.bookstore.model.Review;
import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.ReviewDAO;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.BookImage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/detail"})
public class ProducDetailServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get the Book ID from the URL (e.g., detail?pid=5)
        String idRaw = request.getParameter("pid");
        
        if (idRaw == null || idRaw.isEmpty()) {
            response.sendRedirect("home"); // Invalid ID -> Go Home
            return;
        }

        try {
            int id = Integer.parseInt(idRaw);
            BookDAO dao = new BookDAO();
            ReviewDAO reviewDAO = new ReviewDAO();
            
            // 2. Get the Main Book
            Book book = dao.getBookById(id);
            
            if (book == null) {
                response.sendRedirect("home"); // Book not found
                return;
            }

            List<BookImage> bookImage = dao.getBookImage(id);
            // 3. Get Related Books (Same Category)
            List<Book> relatedBooks = dao.getRelatedBooks(book.getCategoryId(), id);
            List<Book> bookSameAuthor = dao.getBookByAuthor(book.getAuthor());
            List<Book> suggestedBooks = dao.getRandomBook(2, 50);
            List<Review> listReviews = reviewDAO.getReviewsByBookId(id);

            // 4. Send data to JSP
            request.setAttribute("book", book);
            request.setAttribute("bookImages", bookImage);
            request.setAttribute("relatedBooks", relatedBooks);
            request.setAttribute("bookSameAuthor", bookSameAuthor);
            request.setAttribute("suggestedBooks", suggestedBooks);
            request.setAttribute("listReviews", listReviews); // Đẩy list đánh giá sang JSP

            // ==========================================
            // LOGIC TÍNH TỔNG SỐ ĐÁNH GIÁ, TRUNG BÌNH SAO VÀ % THANH BAR
            // ==========================================
            int totalReviews = listReviews.size();
            double averageRating = 0.0;
            int[] starPercentages = new int[6]; // Mảng chứa % từ 1 sao đến 5 sao
            
            if (totalReviews > 0) {
                double sum = 0;
                int[] starCounts = new int[6]; // Đếm số lượng của từng loại sao
                
                for (Review r : listReviews) {
                    sum += r.getRating();
                    
                    // Tăng biến đếm của loại sao này lên 1
                    if (r.getRating() >= 1 && r.getRating() <= 5) {
                        starCounts[r.getRating()]++;
                    }
                }
                
                // Tính trung bình và làm tròn đến 1 chữ số thập phân (VD: 4.3, 4.5, 4.8)
                averageRating = Math.round((sum / totalReviews) * 10.0) / 10.0;
                
                // Tính phần trăm cho từng loại sao
                for (int i = 1; i <= 5; i++) {
                    starPercentages[i] = (int) Math.round((starCounts[i] * 100.0) / totalReviews);
                }
            }

            // Đẩy 3 biến này sang JSP
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("starPercentages", starPercentages);
            // ==========================================
            
            request.getRequestDispatcher("view/product-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }
}