package com.group2.bookstore.controller;

import com.group2.bookstore.dal.VoucherDAO;
import com.group2.bookstore.model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/vouchers") // Đường dẫn khi click vào banner
public class VoucherHubServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        VoucherDAO voucherDAO = new VoucherDAO();
        
        // Kéo toàn bộ mã giảm giá đang hoạt động
        List<Voucher> listVouchers = voucherDAO.getAllActiveVouchers();
        
        req.setAttribute("listVouchers", listVouchers);
        req.getRequestDispatcher("/view/voucher-hub.jsp").forward(req, resp);
    }
}