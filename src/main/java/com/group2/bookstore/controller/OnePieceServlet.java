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

@WebServlet("/onepiece")
public class OnePieceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            BookDAO bookDAO = new BookDAO();
            
            // 1. Dùng radar tìm kiếm tất cả các kho báu (sách) mang tên "One Piece"
            List<Book> onepieceList = bookDAO.getBooksByName("One Piece"); 
            
            // 2. Gói ghém chiến lợi phẩm vào một rương mang tên "onepieceList" để gửi sang JSP
            request.setAttribute("onepieceList", onepieceList);
            
            // 3. Nhổ neo, tiến thẳng tới vùng biển OnePiece.jsp!
            // (Hãy chắc chắn file OnePiece.jsp của bạn đang nằm trong thư mục view)
            request.getRequestDispatcher("/view/OnePiece.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Lỡ có sóng to gió lớn (lỗi code) thì cho tàu quay đầu về trang chủ cho an toàn
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}