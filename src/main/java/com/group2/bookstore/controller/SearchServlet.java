package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.CategoryDAO;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.Category;
import com.group2.bookstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Set font Tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 2. Lấy dữ liệu từ Form (Sidebar + Header)
        String txtSearch = request.getParameter("txt");
        String cid_raw = request.getParameter("cid");
        String priceFrom_raw = request.getParameter("minPrice");
        String priceTo_raw = request.getParameter("maxPrice");
        String author = request.getParameter("author");
        String publisher = request.getParameter("publisher"); // Thêm Publisher
        String sort = request.getParameter("sort");

        // 3. Xử lý dữ liệu (tránh null)
        txtSearch = (txtSearch == null) ? "" : txtSearch.trim();
        author = (author == null) ? "" : author.trim();
        publisher = (publisher == null) ? "" : publisher.trim();
        sort = (sort == null) ? "" : sort.trim();
        
        int cid = 0;
        double priceFrom = 0;
        double priceTo = 0;
        
        try {
            if (cid_raw != null && !cid_raw.isEmpty()) cid = Integer.parseInt(cid_raw);
            if (priceFrom_raw != null && !priceFrom_raw.isEmpty()) priceFrom = Double.parseDouble(priceFrom_raw);
            if (priceTo_raw != null && !priceTo_raw.isEmpty()) priceTo = Double.parseDouble(priceTo_raw);
        } catch (NumberFormatException e) {
            // Nếu lỗi ép kiểu số thì giữ mặc định là 0
        }

        // 4. Kiểm tra quyền Admin (Để truyền vào hàm getBooks)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        boolean isAdmin = false;
        if (user != null && user.getRole() == 1) { // Giả sử Role 1 là Admin
            isAdmin = true;
        }

        // 5. Gọi DAO
        BookDAO bookDAO = new BookDAO();
        CategoryDAO catDAO = new CategoryDAO();

        // Gọi hàm getBooks (9 tham số) khớp với BookDAO mới của bạn
        List<Book> listBooks = bookDAO.getBooks(txtSearch, cid, author, publisher, priceFrom, priceTo, sort, "ASC", isAdmin);

        // Lấy dữ liệu cho Dropdown bộ lọc
        List<Category> listCategories = catDAO.getCategories();
        List<String> listPublishers = bookDAO.getAllPublishers();

        // 6. Đẩy dữ liệu sang JSP
        request.setAttribute("listBooks", listBooks);
        request.setAttribute("listCategories", listCategories);
        request.setAttribute("listPublishers", listPublishers);
        
        // 7. Lưu lại trạng thái bộ lọc (để form không bị reset)
        request.setAttribute("txtS", txtSearch);
        request.setAttribute("cid", cid);
        request.setAttribute("minPrice", (priceFrom > 0 ? priceFrom_raw : "")); 
        request.setAttribute("maxPrice", (priceTo > 0 ? priceTo_raw : ""));
        request.setAttribute("author", author);
        request.setAttribute("publisher", publisher);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("view/Search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}