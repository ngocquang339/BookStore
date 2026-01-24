package com.group2.bookstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.BookDAO; 
import com.group2.bookstore.model.Book; 
@WebServlet("/home")
public class HomeServlet extends HttpServlet{
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BookDAO bookDAO = new BookDAO();
        List<Book> list = bookDAO.getRandomBook();

        if (list == null || list.isEmpty()) {
            System.out.println("DEBUG: Danh sách sách bị RỖNG! Kiểm tra lại SQL hoặc Database.");
        } else {
            System.out.println("DEBUG: Lấy thành công " + list.size() + " cuốn sách.");
            System.out.println("DEBUG: Cuốn đầu tiên: " + list.get(0).getTitle());
        }
        // -----------------------------

        // 2. Đẩy danh sách vào request
        request.setAttribute("randomBooks", list);
        
        // 3. Chuyển hướng sang trang JSP hiển thị
        request.getRequestDispatcher("/view/Home.jsp").forward(request, response);
    }
}
