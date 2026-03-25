package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.PromotionDAO;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.Promotion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PromoBookServlet", urlPatterns = {"/staff/promo-books"})
public class PromoBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int promoId = Integer.parseInt(request.getParameter("id"));
        
        // ==========================================
        // LOGIC PHÂN TRANG (TÁI SỬ DỤNG HÀM CÓ SẴN)
        // ==========================================
        int page = 1; // Mặc định là trang 1
        int pageSize = 10; // Cài đặt hiển thị 10 cuốn sách trên 1 trang
        
        // Lấy số trang từ URL (nếu có)
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        PromotionDAO promoDao = new PromotionDAO();
        BookDAO bookDao = new BookDAO(); 
        
        Promotion promo = promoDao.getPromotionById(promoId);
        
        // 1. TÍNH TỔNG SỐ TRANG: Dùng hàm countBooks của bạn
        // Tham số: keyword="", cid=0, isAdmin=true (để Staff thấy cả sách bị ẩn nếu cần)
        int totalBooks = bookDao.countBooks("", 0, true);
        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);
        
        // 2. LẤY SÁCH CHO TRANG HIỆN TẠI: Dùng hàm getBooks CORE của bạn
        // Truyền các tham số rỗng/0 cho bộ lọc, sắp xếp theo book_id DESC
        List<Book> listBooks = bookDao.getBooks(
            "",          // keyword
            0,           // cid
            "",          // author
            "",          // publisher
            0,           // minPrice
            0,           // maxPrice
            0,           // ratingFilter
            "book_id",   // sortBy
            "DESC",      // sortOrder
            true,        // isAdmin (True để hiển thị tất cả trong trang quản lý)
            page,        // index (số trang hiện tại)
            pageSize     // pageSize (số sách 1 trang)
        );
        
        // 3. Lấy danh sách ID sách đang tham gia Flash Sale này
        List<Integer> selectedBookIds = promoDao.getBookIdsInPromotion(promoId);

        // Bắn dữ liệu sang JSP
        request.setAttribute("promo", promo);
        request.setAttribute("allBooks", listBooks); 
        request.setAttribute("selectedBookIds", selectedBookIds);
        
        // Bắn thông tin phân trang sang JSP
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/view/staff/promo-books.jsp").forward(request, response);
    }

    // Nhận Request AJAX từ công tắc Bật/Tắt bên giao diện
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        int promoId = Integer.parseInt(request.getParameter("promoId"));
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        
        PromotionDAO promoDao = new PromotionDAO();
        boolean success = false;
        
        if ("add".equals(action)) {
            success = promoDao.addBookToPromotion(promoId, bookId);
        } else if ("remove".equals(action)) {
            success = promoDao.removeBookFromPromotion(promoId, bookId);
        }
        
        // Trả về JSON để Javascript biết là thành công hay chưa
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": " + success + "}");
    }
}