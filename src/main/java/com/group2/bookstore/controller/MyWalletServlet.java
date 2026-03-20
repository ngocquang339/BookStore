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
            // ====================================================================
            // 🚨 BƯỚC QUAN TRỌNG: Cập nhật lại số dư ví mới nhất vào Session
            // Tránh việc User xài hết tiền rồi nhưng Web chưa kịp update số dư
            // ====================================================================
            UserDAO userDAO = new UserDAO();
            User freshUser = userDAO.getUserById(user.getId());
            if (freshUser != null) {
                // Đè lại thông tin user mới (chứa wallet_balance mới nhất) vào session
                session.setAttribute("user", freshUser); 
            }

            // 3. Lấy danh sách lịch sử giao dịch từ Database
            WalletHistoryDAO walletDAO = new WalletHistoryDAO();
            List<WalletHistory> walletHistoryList = walletDAO.getHistoryByUserId(user.getId());

            // 4. Gói ghém dữ liệu và đẩy sang giao diện my-wallet.jsp
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
        // Trang ví tạm thời chỉ để "Ngắm", không có thao tác submit form nên ta chuyển hướng về doGet
        doGet(request, response);
    }
}