package com.group2.bookstore.controller;

import com.group2.bookstore.dal.VoucherDAO;
import com.group2.bookstore.model.User;
import com.group2.bookstore.model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/vouchers-management")
public class VoucherController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        
        // Chỉ cho phép Role = 3 (Sale Staff) truy cập
        if (user == null || user.getRole() != 3) { 
            resp.sendRedirect(req.getContextPath() + "/login"); 
            return;
        }

        VoucherDAO dao = new VoucherDAO();
        // Dùng hàm vừa thêm mới ở bước 1
        List<Voucher> list = dao.getAllVouchersForStaff();
        
        req.setAttribute("vouchers", list);
        req.getRequestDispatcher("/view/voucher-management.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");
        int discountType = Integer.parseInt(req.getParameter("discountType")); // 1: Tiền, 2: %
        double discountValue = Double.parseDouble(req.getParameter("discountValue"));
        double minOrderValue = Double.parseDouble(req.getParameter("minOrderValue"));
        int usageLimit = Integer.parseInt(req.getParameter("usageLimit"));
        
        // Convert chuỗi yyyy-MM-dd từ form HTML sang java.sql.Timestamp
        String startDateStr = req.getParameter("startDate") + " 00:00:00";
        String endDateStr = req.getParameter("endDate") + " 23:59:59";
        Timestamp startDate = Timestamp.valueOf(startDateStr);
        Timestamp endDate = Timestamp.valueOf(endDateStr);
        String maxDiscountRaw=req.getParameter("maxDiscount");

        Voucher v = new Voucher();
        v.setCode(code);
        
        // Dựa vào lựa chọn của Staff để gán đúng thuộc tính
        if (discountType == 1) {
            v.setDiscountAmount(discountValue);
            v.setDiscountPercent(0);
            v.setMaxDiscount(null); // Giảm tiền mặt thì không có tối đa
        } else {
            v.setDiscountPercent((int) discountValue);
            v.setDiscountAmount(0);
            if (maxDiscountRaw != null && !maxDiscountRaw.isEmpty()) {
                v.setMaxDiscount(Double.parseDouble(maxDiscountRaw));
            }
        }
        
        v.setMinOrderValue(minOrderValue);
        v.setUsageLimit(usageLimit);
        v.setStartDate(startDate);
        v.setEndDate(endDate);

        VoucherDAO dao = new VoucherDAO();
        dao.addVoucherForStaff(v);

        // Load lại trang sau khi thêm thành công
        resp.sendRedirect(req.getContextPath() + "/vouchers-management");
    }
}