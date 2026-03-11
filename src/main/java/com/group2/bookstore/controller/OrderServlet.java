package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.User;
// Nhớ import các class Order và OrderDAO của bạn vào đây
// import com.group2.bookstore.dal.OrderDAO;
// import com.group2.bookstore.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = {"/my-orders"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect("login"); // Đổi thành URL trang login của bạn
            return;
        }

        // 2. Lấy trạng thái đơn hàng từ URL (Mặc định là "all" nếu không có param)
        String status = request.getParameter("status");
        if (status == null || status.trim().isEmpty()) {
            status = "all";
        }

        // 3. GỌI DAO ĐỂ LẤY DỮ LIỆU
        OrderDAO orderDAO = new OrderDAO();
        // Gom 1 và 2 vào chung tab "Đang xử lý" của khách
        int countProcessing = orderDAO.countOrdersByStatus(user.getId(), 1) + orderDAO.countOrdersByStatus(user.getId(), 2);
        int countShipping = orderDAO.countOrdersByStatus(user.getId(), 3);   // [SỬA] Đang giao là 3
        int countCompleted = orderDAO.countOrdersByStatus(user.getId(), 4);  // [SỬA] Hoàn tất là 4
        int countCancelled = orderDAO.countOrdersByStatus(user.getId(), 5);  // [SỬA] Hủy là 5
        
        int countAll = countProcessing + countShipping + countCompleted + countCancelled;
        List<Order> listOrders = new ArrayList<>();
        
        if ("all".equals(status)) {
            listOrders = orderDAO.getAllOrdersByUserId(user.getId());
        } else {
            // [SỬA] Chuyển đổi trạng thái sang số nguyên CHUẨN
            if ("processing".equals(status)) {
                // Lấy cả 1 và 2 gộp lại cho tab Đang xử lý
                listOrders.addAll(orderDAO.getOrdersByStatusForUser(user.getId(), 1));
                listOrders.addAll(orderDAO.getOrdersByStatusForUser(user.getId(), 2));

                // THÊM ĐOẠN NÀY: Sắp xếp lại tổng thể danh sách vừa gộp (Mới nhất lên đầu)
                java.util.Collections.sort(listOrders, new java.util.Comparator<Order>() {
                    @Override
                    public int compare(Order o1, Order o2) {
                        // Sắp xếp giảm dần theo ID (ID to = đơn mới)
                        return Integer.compare(o2.getId(), o1.getId());
                    }
                });
            } else {
                int dbStatus = -1;
                switch (status) {    
                    case "shipping": dbStatus = 3; break;   // [SỬA] 3
                    case "completed": dbStatus = 4; break;  // [SỬA] 4
                    case "cancelled": dbStatus = 5; break;  // [SỬA] 5
                }
                listOrders = orderDAO.getOrdersByStatusForUser(user.getId(), dbStatus);
            }
        }
        request.setAttribute("countAll", countAll);
        request.setAttribute("countProcessing", countProcessing);
        request.setAttribute("countShipping", countShipping);
        request.setAttribute("countCompleted", countCompleted);
        request.setAttribute("countCancelled", countCancelled);
        
        request.setAttribute("listOrders", listOrders);

        // 4. Đẩy trạng thái hiện tại sang JSP để bôi đỏ cái Tab đang được chọn
        request.setAttribute("currentStatus", status);

        // Chuyển hướng sang trang JSP
        request.getRequestDispatcher("view/MyOrders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập (Bảo mật cơ bản)
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");

        try {
            if ("cancel".equals(action) && orderIdStr != null) {
                int orderId = Integer.parseInt(orderIdStr);
                OrderDAO orderDAO = new OrderDAO();
                
                // Lấy thông tin đơn hàng hiện tại lên để kiểm tra
                Order currentOrder = orderDAO.getOrderById(orderId);
                
                // Cực kỳ quan trọng: Chỉ cho phép hủy nếu đơn hàng thuộc về user này
                // Và trạng thái đang là 1 (Chờ duyệt) hoặc 2 (Đã duyệt)
                if (currentOrder != null && currentOrder.getUserId() == user.getId() 
                    && (currentOrder.getStatus() == 1 || currentOrder.getStatus() == 2)) {
                    
                    // 1. Cập nhật trạng thái thành 5 (Đã hủy)
                    boolean isCancelled = orderDAO.updateOrderStatus(orderId, 5); // [SỬA] 5 là trạng thái Hủy
                    
                    if (isCancelled) {
                        // ==============================================================
                        // [MỚI THÊM] - HOÀN LẠI VOUCHER VÀO VÍ KHÁCH HÀNG NẾU CÓ DÙNG
                        // ==============================================================
                        if (currentOrder.getVoucher_id() > 0) {
                            com.group2.bookstore.dal.VoucherDAO voucherDAO = new com.group2.bookstore.dal.VoucherDAO();
                            voucherDAO.refundVoucher(user.getId(), currentOrder.getVoucher_id());
                        }
                        // ==============================================================
                        
                        // Set thông báo thành công
                        session.setAttribute("successMsg", "Đã hủy đơn hàng #" + orderId + " thành công!");
                    } else {
                        session.setAttribute("errorMsg", "Không thể hủy đơn hàng này. Vui lòng thử lại!");
                    }
                } else {
                    session.setAttribute("errorMsg", "Đơn hàng không tồn tại hoặc không thể hủy ở trạng thái hiện tại.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Có lỗi xảy ra trong quá trình xử lý!");
        }

        // 3. Xong việc thì redirect ngược lại trang Lịch sử đơn hàng để nó tải lại danh sách mới
        response.sendRedirect(request.getContextPath() + "/my-orders");
    }
}
