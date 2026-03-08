package com.group2.bookstore.controller;

import com.group2.bookstore.dal.VoucherDAO;
import com.group2.bookstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/save-voucher")
public class SaveVoucherServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Trả về kết quả dưới dạng Text (để code Javascript phía Frontend đọc được)
        resp.setContentType("text/plain;charset=UTF-8");
        
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (user == null) {
            resp.getWriter().write("UNAUTHORIZED"); // Chưa đăng nhập
            return;
        }

        try {
            // 2. Lấy ID của voucher mà khách vừa bấm
            int voucherId = Integer.parseInt(req.getParameter("voucherId"));
            
            // 3. Gọi DAO để lưu vào DB (Ví)
            VoucherDAO dao = new VoucherDAO();
            String result = dao.saveVoucherToWallet(user.getId(), voucherId);
            
            // Trả kết quả về cho trình duyệt (SUCCESS, EXISTED, hoặc ERROR)
            resp.getWriter().write(result);
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("ERROR");
        }
    }
}