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

@WebServlet(name = "InventoryServlet", urlPatterns = {"/warehouse/inventory"})
public class InventoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8"); // Đảm bảo tiếng Việt
        BookDAO dao = new BookDAO();

        // 1. Lấy dữ liệu cho các ô Select (Dropdown)
        List<String> authors = dao.getAllAuthors();
        List<String> publishers = dao.getAllPublishers();
        request.setAttribute("listAuthors", authors);
        request.setAttribute("listPublishers", publishers);

        // 2. Nhận tham số từ Filter Form
        String search = request.getParameter("search");

        String cate = request.getParameter("cid");
        int cid = (cate == null || cate.isEmpty()) ? 0 : Integer.parseInt(cate);

        String author = request.getParameter("author");
        String publisher = request.getParameter("publisher");

        // 3. Xử lý khoảng giá
        String priceRange = request.getParameter("priceRange");
        double minPrice = 0;
        double maxPrice = 0;

        String indexPage = request.getParameter("index");
        if (indexPage == null) {
            indexPage = "1";
        }
        int index = Integer.parseInt(indexPage);

        if (priceRange != null && !priceRange.isEmpty()) {
            switch (priceRange) {
                case "under100":
                    minPrice = 0;
                    maxPrice = 100000;
                    break;
                case "100-200":
                    minPrice = 100000;
                    maxPrice = 200000;
                    break;
                case "200-500":
                    minPrice = 200000;
                    maxPrice = 500000;
                    break;
                case "over500":
                    minPrice = 500000;
                    maxPrice = 999999999;
                    break;
            }
        }

        // ĐÃ SỬA: Truyền biến cid vào hàm thay vì số 0
        // List<Book> list = dao.getBooks(keyword, cid, author, publisher, 0, 999999999, "book_id", "DESC", true);

        // // 5. Gọi hàm DAO
        // List<Book> list = dao.getBooks(search, cid, author, publisher, minPrice, maxPrice, sort, order, false, index);

        // 6. Gửi dữ liệu về JSP
        // request.setAttribute("listB", list);

        // Giữ lại các giá trị đã chọn để hiển thị lại trên Form
        request.setAttribute("paramSearch", search);
        request.setAttribute("paramCid", cid);
        request.setAttribute("paramAuthor", author);
        request.setAttribute("paramPublisher", publisher);
        request.setAttribute("paramPrice", priceRange);

        request.getRequestDispatcher("/view/warehouse/inventory_list.jsp").forward(request, response);
    }
}
