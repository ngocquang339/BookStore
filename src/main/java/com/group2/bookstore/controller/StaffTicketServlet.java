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

        List<Order> listReturnOrders = orderDao.getOrdersByStatus(7, "order_date", "DESC");

        request.setAttribute("listReturnOrders", listReturnOrders);

        request.getRequestDispatcher("/view/staff/ticket-manage.jsp").forward(request, response);
    }

    // XỬ LÝ KHI STAFF BẤM NÚT "LƯU & BẮN THÔNG BÁO"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action"); // Lấy biến phân loại hành động

        if ("process_return".equals(action)) {
            // --- XỬ LÝ: STAFF DUYỆT TRẢ HÀNG (CHẤP NHẬN HOẶC TỪ CHỐI) ---
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int userId = Integer.parseInt(request.getParameter("userId"));
            String decision = request.getParameter("decision"); // Lấy giá trị từ ô select

            OrderDAO orderDao = new OrderDAO();
            NotificationDAO notifDao = new NotificationDAO();

            if ("accept".equals(decision)) {
                // CHẤP NHẬN: Chuyển order status sang 6 (Đã Hủy / Hoàn tiền)
                boolean isUpdated = orderDao.updateOrderStatus(orderId, 8);

                if (isUpdated) {
                    notifDao.createNotification(userId,
                            "Yêu cầu trả hàng cho đơn #" + orderId + " đã được CHẤP NHẬN và hoàn tiền!",
                            "my-orders");
                    request.getSession().setAttribute("successMessage",
                            "Đã CHẤP NHẬN hoàn tiền cho đơn hàng #" + orderId);
                } else {
                    request.getSession().setAttribute("errorMessage", "Lỗi: Không thể cập nhật trạng thái đơn hàng.");
                }

            } else if ("reject".equals(decision)) {
                // TỪ CHỐI: Chuyển order status về lại 5 (Hoàn tất - Không cho trả nữa)
                boolean isUpdated = orderDao.updateOrderStatus(orderId, 5);

                if (isUpdated) {
                    notifDao.createNotification(userId,
                            "Yêu cầu trả hàng cho đơn #" + orderId + " đã BỊ TỪ CHỐI bởi cửa hàng.",
                            "my-orders");
                    request.getSession().setAttribute("successMessage",
                            "Đã TỪ CHỐI yêu cầu trả hàng của đơn #" + orderId);
                } else {
                    request.getSession().setAttribute("errorMessage", "Lỗi: Không thể cập nhật trạng thái đơn hàng.");
                }
            }

        } else if ("reply_ticket".equals(action)) {
            // --- XỬ LÝ: STAFF TRẢ LỜI TICKET KHIẾU NẠI ---
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

                // Lưu ý: Đảm bảo đường dẫn URL notification của bạn ở đây khớp với bên User
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