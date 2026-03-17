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

@WebServlet("/conan")
public class ConanServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            BookDAO bookDAO = new BookDAO();
            
            // 1. Gọi hàm tìm kiếm sách có chứa từ khóa "Conan"
            // (Lưu ý: Nếu hàm tìm kiếm của bạn tên khác, ví dụ getBooksByName hay searchBook, hãy đổi lại cho khớp nhé)
            List<Book> conanList = bookDAO.getBooksByName("Conan"); 
            
            // 2. Gói danh sách này lại và gửi sang JSP
            request.setAttribute("conanList", conanList);
            
            // 3. Mở cánh cửa thần kỳ dẫn vào chuyên trang Conan
            // (Đảm bảo file Conan.jsp của bạn đang nằm trong thư mục view)
            request.getRequestDispatcher("/view/Conan.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Lỡ có lỗi thì đá về trang chủ cho an toàn
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}