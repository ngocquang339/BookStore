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
        
        // Lấy tham số Filter
        String search = request.getParameter("search");
        String cate = request.getParameter("cid");
        String author = request.getParameter("author");
        
        // Lấy tham số Sort
        String col = request.getParameter("col");     // Tên cột: title, author, price...
        String order = request.getParameter("order"); // Chiều: ASC, DESC
        
        // Giá trị mặc định nếu chưa chọn gì
        if (col == null) col = "id";
        if (order == null) order = "ASC";

        int cid = (cate == null || cate.isEmpty()) ? 0 : Integer.parseInt(cate);

        BookDAO dao = new BookDAO();
        request.setAttribute("listAuthors", dao.getAllAuthors());

        // Gọi hàm getBooks mới (Không dùng tham số boolean lowStock nữa cho đơn giản)
        List<Book> list = dao.getBooks(search, cid, author, col, order);

        request.setAttribute("listB", list);
        
        // Gửi lại col và order về JSP để vẽ mũi tên và tạo link đảo chiều
        request.setAttribute("sortCol", col);
        request.setAttribute("sortOrder", order);
        
        request.getRequestDispatcher("/view/warehouse/inventory_list.jsp").forward(request, response);
    }
}