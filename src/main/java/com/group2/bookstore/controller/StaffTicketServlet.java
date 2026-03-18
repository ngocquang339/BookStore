package com.group2.bookstore.controller;

import com.group2.bookstore.dal.NotificationDAO;
import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.dal.SupportTicketDAO;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.SupportTicket;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffTicketServlet", urlPatterns = { "/staff/tickets" })
public class StaffTicketServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Dữ liệu cho Tab Khiếu nại (Giữ nguyên)
        SupportTicketDAO ticketDao = new SupportTicketDAO();
        List<SupportTicket> listTickets = ticketDao.getAllTickets();
        request.setAttribute("listTickets", listTickets);

        // 2. DỮ LIỆU MỚI CHO TAB TRẢ HÀNG (Sử dụng hàm DAO của bạn)
        OrderDAO orderDao = new OrderDAO();

        // Truyền status = 5, sortBy = "id" (hoặc "order_date" tuỳ DB của bạn), sortOrder = "DESC" để đơn mới lên đầu
        List<Order> listReturnOrders = orderDao.getOrdersByStatus(5, "id", "DESC");

        request.setAttribute("listReturnOrders", listReturnOrders);

        request.getRequestDispatcher("/view/staff/ticket-manage.jsp").forward(request, response);
    }

    // XỬ LÝ KHI STAFF BẤM NÚT "LƯU & BẮN THÔNG BÁO"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action"); // Lấy biến phân loại hành động

        if ("approve_return".equals(action)) {
            // --- XỬ LÝ: STAFF DUYỆT TRẢ HÀNG (STATUS 5 -> 6) ---
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int userId = Integer.parseInt(request.getParameter("userId"));

            OrderDAO orderDao = new OrderDAO();
            boolean isUpdated = orderDao.updateOrderStatus(orderId, 6);

            if (isUpdated) {
                // (Tùy chọn) Gửi thông báo cho User
                NotificationDAO notifDao = new NotificationDAO();
                notifDao.createNotification(userId,
                        "Yêu cầu trả hàng cho đơn #" + orderId + " đã được chấp nhận và hoàn tiền!",
                        "my-orders?status=returned");

                request.getSession().setAttribute("successMessage",
                        "Đã duyệt hoàn tiền thành công cho đơn hàng #" + orderId);
            } else {
                request.getSession().setAttribute("errorMessage", "Lỗi: Không thể cập nhật trạng thái đơn hàng.");
            }

        } else {
            // --- XỬ LÝ: STAFF TRẢ LỜI TICKET KHIẾU NẠI (CODE CŨ CỦA BẠN) ---
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            int customerId = Integer.parseInt(request.getParameter("userId"));
            String status = request.getParameter("status");
            String adminReply = request.getParameter("adminReply");

            SupportTicketDAO ticketDao = new SupportTicketDAO();
            boolean isUpdated = ticketDao.updateTicketAndReply(ticketId, status, adminReply);

            if (isUpdated) {
                NotificationDAO notifDao = new NotificationDAO();
                String msg = "Khiếu nại (Mã #" + ticketId + ") của bạn đã được phản hồi! Trạng thái hiện tại: "
                        + status;
                notifDao.createNotification(customerId, msg, "support");
                request.getSession().setAttribute("successMessage",
                        "Đã phản hồi khiếu nại và gửi thông báo cho khách hàng!");
            } else {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật khiếu nại.");
            }
        }

        // Load lại trang danh sách (sẽ giữ lại thông báo báo thành công)
        response.sendRedirect(request.getContextPath() + "/staff/tickets");
    }
}