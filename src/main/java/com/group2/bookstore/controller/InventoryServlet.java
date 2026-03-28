package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import com.group2.bookstore.dal.CategoryDAO;

@WebServlet(name = "InventoryServlet", urlPatterns = { "/warehouse/inventory" })
public class InventoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        BookDAO dao = new BookDAO();
        CategoryDAO cDao = new CategoryDAO();

        String keyword = request.getParameter("keyword");
        String author = request.getParameter("author");
        String publisher = request.getParameter("publisher");
        String categoryIdStr = request.getParameter("categoryId");

        if (keyword == null)
            keyword = "";

        int cid = 0;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                cid = Integer.parseInt(categoryIdStr);
            } catch (Exception e) {
            }
        }

        // ---- CODE PHÂN TRANG MỚI THÊM VÀO ĐÂY ----
        int page = 1; // Trang mặc định
        int pageSize = 10; // Số lượng sách trên 1 trang
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (Exception e) {
            }
        }

        // 1. GỌI DAO LẤY DANH SÁCH (Dùng hàm Overload số 3 của bạn, có truyền page và
        // pageSize)
        List<Book> list = dao.getBooks(keyword, cid, author, publisher, 0, 999999999, "book_id", "DESC", true, page,
                pageSize);

        // Lấy tổng số lượng sách thỏa mãn điều kiện lọc để tính tổng số trang
        int totalRecords = dao.getTotalInventoryBooks(keyword, cid, author, publisher);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        // ------------------------------------------

        // 2. GIỮ LẠI TRẠNG THÁI TÌM KIẾM TRÊN FORM
        request.setAttribute("paramSearch", keyword);
        request.setAttribute("paramCid", cid);
        request.setAttribute("paramAuthor", author);
        request.setAttribute("paramPublisher", publisher);

        // Trả thêm data phân trang về JSP
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // Truyền data sang JSP
        request.setAttribute("listC", cDao.getAllCategories());
        request.setAttribute("listA", dao.getAllAuthors());
        request.setAttribute("listP", dao.getAllPublishers());
        request.setAttribute("listB", list);

        request.getRequestDispatcher("/view/warehouse/inventory_list.jsp").forward(request, response);
    }
}