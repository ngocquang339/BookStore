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
        String action = req.getParameter("action");
        
        // 1. XỬ LÝ CHUYỂN HƯỚNG SANG TRANG THÊM MỚI
        if ("add".equals(action)) {
            req.getRequestDispatcher("/view/add-voucher.jsp").forward(req, resp);
            return;
        }

        // 2. XỬ LÝ XÓA VOUCHER
        if ("delete".equals(action)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int voucherId = Integer.parseInt(idParam);
                dao.deleteVoucher(voucherId); 
            }
            resp.sendRedirect(req.getContextPath() + "/vouchers-management");
            return;
        }

        // 3. XỬ LÝ XEM THỐNG KÊ (Trả về JSON cho AJAX)
        if ("analytics".equals(action)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int voucherId = Integer.parseInt(idParam);
                int[] stats = dao.getVoucherStats(voucherId);
                
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"saved\":" + stats[0] + ", \"used\":" + stats[1] + "}");
            }
            return; 
        }

        // 4. MẶC ĐỊNH: TẢI DANH SÁCH VOUCHER RA BẢNG
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
        String maxDiscountRaw = req.getParameter("maxDiscount");

        Voucher v = new Voucher();
        v.setCode(code);
        
        // Gán thuộc tính tùy theo loại giảm giá
        if (discountType == 1) {
            v.setDiscountAmount(discountValue);
            v.setDiscountPercent(0);
            v.setMaxDiscount(0.0); // Giảm tiền mặt thì không có tối đa
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

        // Lưu thành công thì quay về trang danh sách
        resp.sendRedirect(req.getContextPath() + "/vouchers-management");
    }
}