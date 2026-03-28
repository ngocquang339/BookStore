package com.group2.bookstore.controller;

import com.group2.bookstore.dal.PromotionDAO;
import com.group2.bookstore.model.Promotion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

// Đặt đường dẫn URL cho khu vực nội bộ của Staff
@WebServlet(name = "PromotionServlet", urlPatterns = {"/staff/promotions"})
public class PromotionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        PromotionDAO dao = new PromotionDAO();
        List<Promotion> listPromos = dao.getAllPromotions();
        
        request.setAttribute("listPromos", listPromos);
        
        request.getRequestDispatcher("/view/staff/promotion-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            // Lấy dữ liệu từ Form do Staff nhập
            String promoName = request.getParameter("promoName");
            int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
            String startDate = request.getParameter("startDate"); 
            String endDate = request.getParameter("endDate");

            // =========================================================
            // [ĐÃ SỬA LỖI]: Xóa chữ T và thêm giây vào cho SQL Server hiểu
            // =========================================================
            if (startDate != null && startDate.contains("T")) {
                startDate = startDate.replace("T", " ") + ":00";
            }
            if (endDate != null && endDate.contains("T")) {
                endDate = endDate.replace("T", " ") + ":00";
            }
            PromotionDAO dao = new PromotionDAO();
            boolean isSuccess = dao.insertPromotion(promoName, discountPercent, startDate, endDate);

            if (isSuccess) {
                request.getSession().setAttribute("successMessage", "Tạo chương trình Flash Sale thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra, không thể tạo Khuyến mãi!");
            }
        }
        // --- XỬ LÝ SỬA ---
        else if ("update".equals(action)) {
            int promoId = Integer.parseInt(request.getParameter("promoId"));
            String promoName = request.getParameter("promoName");
            int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            
            boolean isActive = request.getParameter("isActive") != null; 

            // Cắt chữ T giống như lúc Tạo mới
            if (startDate != null && startDate.contains("T")) startDate = startDate.replace("T", " ") + ":00";
            if (endDate != null && endDate.contains("T")) endDate = endDate.replace("T", " ") + ":00";

            PromotionDAO dao = new PromotionDAO();
            if (dao.updatePromotion(promoId, promoName, discountPercent, startDate, endDate, isActive)) {
                request.getSession().setAttribute("successMessage", "Cập nhật Flash Sale thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Lỗi khi cập nhật Khuyến mãi!");
            }
        } 
        // --- XỬ LÝ XÓA ---
        else if ("delete".equals(action)) {
            int promoId = Integer.parseInt(request.getParameter("promoId"));
            PromotionDAO dao = new PromotionDAO();
            if (dao.deletePromotion(promoId)) {
                request.getSession().setAttribute("successMessage", "Đã xóa chương trình Flash Sale!");
            } else {
                request.getSession().setAttribute("errorMessage", "Lỗi! Không thể xóa (Có thể đang có sách nằm trong chương trình này).");
            }
        }
        
        // Tạo xong thì load lại trang danh sách
        response.sendRedirect(request.getContextPath() + "/staff/promotions");
    }
}