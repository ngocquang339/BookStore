package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.CategoryDAO;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Set Tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 2. Lấy dữ liệu từ Form (Sidebar + Header)
        String keyword = request.getParameter("txt");
        String cid_raw = request.getParameter("cid");
        String priceFrom_raw = request.getParameter("priceFrom");
        String priceTo_raw = request.getParameter("priceTo");
        String author = request.getParameter("author");
        String sort = request.getParameter("sort");

        // 3. Xử lý dữ liệu (tránh null)
        keyword = (keyword == null) ? "" : keyword.trim();
        author = (author == null) ? "" : author.trim();
        sort = (sort == null) ? "" : sort.trim();
        
        int cid = 0;
        double priceFrom = 0;
        double priceTo = 0;
        
        try {
            if (cid_raw != null && !cid_raw.isEmpty()) cid = Integer.parseInt(cid_raw);
            if (priceFrom_raw != null && !priceFrom_raw.isEmpty()) priceFrom = Double.parseDouble(priceFrom_raw);
            if (priceTo_raw != null && !priceTo_raw.isEmpty()) priceTo = Double.parseDouble(priceTo_raw);
        } catch (NumberFormatException e) {
            // Nếu người dùng nhập linh tinh vào ô số -> coi như bằng 0
        }

        // 4. Gọi BookDAO để lọc sách
        BookDAO bookDAO = new BookDAO();
        // Tham số: keyword, cid, author, publisher(null), minPrice, maxPrice, sortBy, sortOrder(ASC)
        List<Book> listBooks = bookDAO.getBooks(keyword, cid, author, null, priceFrom, priceTo, sort, "ASC");

        // 5. Gọi CategoryDAO để lấy danh sách danh mục (cho Sidebar)
        CategoryDAO catDAO = new CategoryDAO(); 
        List<Category> listCategories = catDAO.getAllCategories(); 

        // 6. Đẩy dữ liệu sang JSP
        request.setAttribute("listBooks", listBooks);      // Kết quả tìm kiếm
        request.setAttribute("listCategories", listCategories); // Dữ liệu cho Dropdown
        
        // 7. Giữ lại giá trị người dùng đã nhập (để Form không bị reset)
        request.setAttribute("txtS", keyword);
        request.setAttribute("cid", cid);
        // Lưu ý: priceFrom/To để dạng String raw để nếu null thì ô input trống (thay vì hiện số 0.0)
        request.setAttribute("priceFrom", (priceFrom > 0 ? priceFrom_raw : "")); 
        request.setAttribute("priceTo", (priceTo > 0 ? priceTo_raw : ""));
        request.setAttribute("author", author);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("view/Search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}