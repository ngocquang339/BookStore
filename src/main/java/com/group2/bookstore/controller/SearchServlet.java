package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

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
        String publisher = request.getParameter("publisher");
        String sortBy = request.getParameter("sort");
        
        // --- PHẦN PHÂN TRANG ---
        String indexPage = request.getParameter("index");
        int index = 1; // Mặc định là trang 1
        int pageSize = 20; // Bạn có thể chỉnh số lượng sách mỗi trang ở đây (ví dụ 12)
        
        try {
            if (indexPage != null && !indexPage.isEmpty()) {
                index = Integer.parseInt(indexPage);
            }
        } catch (NumberFormatException e) {
            index = 1;
        }

        // 3. Xử lý dữ liệu (tránh null)
        txtSearch = (txtSearch == null) ? "" : txtSearch.trim();
        author = (author == null) ? "" : author.trim();
        publisher = (publisher == null) ? "" : publisher.trim();
        sortBy = (sortBy == null) ? "" : sortBy.trim();
        String sortOrder = "ASC";
        
        int cid = 0;
        double priceFrom = 0;
        double priceTo = 0;

        // Xử lý Sort logic
        if(sortBy.equals("price_asc")){
            sortBy = "price";
            sortOrder = "ASC";
        }
        else if(sortBy.equals("price_desc")){
            sortBy = "price";
            sortOrder = "DESC";
        }
        else if(sortBy.equals("title")){
            sortBy = "title";
            sortOrder = "ASC";
        }
        else if(sortBy.equals("newest")){
            sortBy = "book_id";
            sortOrder = "DESC";
        }

        try {
            if (cid_raw != null && !cid_raw.isEmpty()) cid = Integer.parseInt(cid_raw);
            if (priceFrom_raw != null && !priceFrom_raw.isEmpty()) priceFrom = Double.parseDouble(priceFrom_raw);
            if (priceTo_raw != null && !priceTo_raw.isEmpty()) priceTo = Double.parseDouble(priceTo_raw);
        } catch (NumberFormatException e) {
            // Giữ mặc định 0
        }

        // 4. Kiểm tra quyền Admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        boolean isAdmin = false;
        int roleId = 0;
        if (user != null) {
            if(user.getRole() == 1) isAdmin = true;
            roleId = user.getRole();
        }

        // 5. Gọi DAO
        BookDAO bookDAO = new BookDAO();
        CategoryDAO catDAO = new CategoryDAO();

        // --- LOGIC PHÂN TRANG CORE ---
        // A. Đếm tổng số lượng sách dựa trên TẤT CẢ bộ lọc (dùng hàm count nâng cao của bạn)
        int total = bookDAO.countBooks(txtSearch, cid, author, publisher, priceFrom, priceTo, isAdmin);
        
        // B. Tính trang cuối cùng
        int endPage = total / pageSize;
        if (total % pageSize != 0) {
            endPage++;
        }

        // C. Lấy danh sách sách của trang hiện tại (Dùng Overload 3 trong DAO của bạn)
        List<Book> listBooks = bookDAO.getBooks(txtSearch, cid, author, publisher, priceFrom, priceTo, sortBy, sortOrder, isAdmin, index, pageSize);
        
        // Dữ liệu bổ trợ
        List<Book> randomBooks = bookDAO.getRandomBook(roleId, 10); // Lấy ít lại cho nhẹ trang
        List<Category> listCategories = catDAO.getCategories();
        List<String> listPublishers = bookDAO.getAllPublishers();

        // 6. Đẩy dữ liệu sang JSP
        request.setAttribute("listBooks", listBooks);
        request.setAttribute("listCategories", listCategories);
        request.setAttribute("listPublishers", listPublishers);
        request.setAttribute("suggestedBooks", randomBooks);
        
        // Gửi dữ liệu phân trang
        request.setAttribute("endPage", endPage);
        request.setAttribute("tag", index); // Trang hiện tại để active button
        request.setAttribute("totalResult", total); // Hiển thị "Tìm thấy X kết quả"

        // 7. Lưu lại trạng thái bộ lọc (để form và link phân trang không bị mất tham số)
        request.setAttribute("txtS", txtSearch);
        request.setAttribute("cid", cid);
        request.setAttribute("minPrice", (priceFrom > 0 ? priceFrom_raw : "")); 
        request.setAttribute("maxPrice", (priceTo > 0 ? priceTo_raw : ""));
        request.setAttribute("author", author);
        request.setAttribute("publisher", publisher);
        request.setAttribute("sort", sortBy);

        request.getRequestDispatcher("view/Search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}