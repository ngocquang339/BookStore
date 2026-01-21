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
import com.group2.bookstore.model.User; // Nhớ import User
import jakarta.servlet.http.HttpSession; // Nhớ import Session

@WebServlet(name = "SearchServlet", urlPatterns = { "/search" })
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Lấy từ khóa tìm kiếm
        String txtSearch = request.getParameter("txt");
        if (txtSearch == null) {
            txtSearch = ""; // Tránh lỗi null khi gọi DAO
        }
        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("user");
        Integer userId = (u != null) ? u.getId() : null;
        // 2. Gọi DAO (sử dụng hàm getBooks mới)
        BookDAO dao = new BookDAO();
        dao.saveSearchHistory(txtSearch, userId);
        // Tham số 1: keyword | Tham số 2: cid (0 là lấy tất cả) | Tham số 3: lowStock
        // (false)
        List<Book> list = dao.getBooks(txtSearch, 0, false);

        // 3. Đẩy dữ liệu sang JSP
        request.setAttribute("listBooks", list);
        request.setAttribute("txtS", txtSearch); // Giữ lại từ khóa

        // 4. Forward về trang chủ
        request.getRequestDispatcher("view/Home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}