package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.dal.WalletHistoryDAO;
import com.group2.bookstore.model.User;
import com.group2.bookstore.model.WalletHistory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyWalletServlet", urlPatterns = {"/my-wallet"})
public class MyWalletServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy session hiện tại
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 2. Chặn đứng người lạ (Chưa đăng nhập)
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User freshUser = userDAO.getUserById(user.getId());
            if (freshUser != null) {
                // Đè lại thông tin user mới (chứa wallet_balance mới nhất) vào session
                session.setAttribute("user", freshUser); 
            }
 
            WalletHistoryDAO walletDAO = new WalletHistoryDAO();
            List<WalletHistory> walletHistoryList = walletDAO.getHistoryByUserId(user.getId());

            request.setAttribute("walletHistoryList", walletHistoryList);
            request.getRequestDispatcher("view/my-wallet.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}