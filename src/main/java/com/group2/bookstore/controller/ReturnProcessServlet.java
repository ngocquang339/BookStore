package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.WarehouseOrderDAO;
import com.group2.bookstore.model.ReturnRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/warehouse/return-process")
public class ReturnProcessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        WarehouseOrderDAO dao = new WarehouseOrderDAO();
        
        // Cập nhật trạng thái của ReturnRequests (thay vì Orders) khi bắt đầu kiểm
        // (Lưu ý: Nếu 9 là trạng thái "Đang kiểm", bạn giữ nguyên số này, 
        // hoặc đổi thành số tương ứng theo bảng status 1-7 của bạn)
        try { 
            dao.updateReturnRequestStatus(orderId, 3); 
        } catch(Exception e) {
            e.printStackTrace();
        }

        // Dùng hàm lấy chi tiết ReturnRequest mới
        List<ReturnRequest> items = dao.getReturnOrderDetails(orderId);
        request.setAttribute("items", items);
        
        // Lấy tên khách hàng từ item đầu tiên để hiển thị trên Header của giao diện
        if (!items.isEmpty()) {
            request.setAttribute("orderInfo", items.get(0));
        }
        
        // Truyền ID sang JSP
        request.setAttribute("orderId", orderId); 

        request.getRequestDispatcher("/view/warehouse/return_inspection.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Hỗ trợ tiếng Việt cho lý do từ chối
        request.setCharacterEncoding("UTF-8");
        
        String orderIdStr = request.getParameter("orderId");
        String qcAction = request.getParameter("qcAction");     // Lấy "PASS" hoặc "FAIL" từ nút bấm
        String failReason = request.getParameter("failReason"); // Lấy lý do từ Modal nếu chọn FAIL
        
        // Kiểm tra an toàn
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Lỗi dữ liệu: Không tìm thấy mã đơn hàng!");
            response.sendRedirect("returns");
            return;
        }

        int orderId = Integer.parseInt(orderIdStr);
        WarehouseOrderDAO dao = new WarehouseOrderDAO();
        
        try {
            // Thực hiện kiểm hàng: Hàm này sẽ tự quyết định cộng kho hay không dựa trên PASS/FAIL
            dao.processQualityControl(orderId, qcAction, failReason); 
            
            if ("PASS".equals(qcAction)) {
                request.getSession().setAttribute("successMessage", "Đã nhập kho hàng hoàn trả thành công! Chờ Admin hoàn tiền.");
            } else {
                request.getSession().setAttribute("errorMessage", "Đã từ chối hàng (Failed QC). Đã ghi chú cho Admin.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi xử lý kiểm hàng: " + e.getMessage());
        }
        
        response.sendRedirect("returns");
    }
}