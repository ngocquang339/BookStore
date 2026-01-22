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

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 1. Lấy từ khóa (nếu không có thì để rỗng để load all)
        String txtSearch = request.getParameter("txt");
        if (txtSearch == null) {
            txtSearch = "";
        }

        // 2. Gọi hàm getBooks đa năng trong DAO
        BookDAO dao = new BookDAO();
        // keyword = txtSearch, cid = 0 (lấy tất cả danh mục), onlyLowStock = false
        List<Book> list = dao.getBooks(txtSearch, 0, false);

        // 3. Đẩy dữ liệu sang JSP
        request.setAttribute("listBooks", list);
        request.setAttribute("txtS", txtSearch); // Lưu lại từ khóa để hiện ở ô input

        // 4. Về trang Home
        request.getRequestDispatcher("view/Home.jsp").forward(request, response);
    }
}