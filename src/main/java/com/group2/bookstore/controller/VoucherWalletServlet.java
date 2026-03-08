package com.group2.bookstore.controller;

import com.group2.bookstore.dal.VoucherDAO;
import com.group2.bookstore.model.User;
import com.group2.bookstore.model.UserVoucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/user/voucher-wallet")
public class VoucherWalletServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // Yêu cầu đăng nhập
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        VoucherDAO voucherDAO = new VoucherDAO();
        // Lấy danh sách voucher trong ví của user này
        List<UserVoucher> wallet = voucherDAO.getUserWallet(user.getId());

        req.setAttribute("wallet", wallet);
        req.getRequestDispatcher("/view/voucher-wallet.jsp").forward(req, resp);
    }
}