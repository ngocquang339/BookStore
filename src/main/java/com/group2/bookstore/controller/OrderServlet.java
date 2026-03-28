package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.User;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = { "/my-orders" })
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 50,      // 50MB (Tối đa 1 file)
    maxRequestSize = 1024 * 1024 * 50    // 50MB (Tối đa toàn request)
)
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
        int countProcessing = orderDAO.countOrdersByStatus(user.getId(), 1)
                + orderDAO.countOrdersByStatus(user.getId(), 2) + orderDAO.countOrdersByStatus(user.getId(), 3); // [SỬA]                                                                                            // Đang                                                                                              // xử                                                                                              // lý                                                                                              // là                                                                                              // 1, 2                                                                                               // và 3                                                                                             // (Chờ                                                                                              // duyệt,                                                                                          // Đã                                                                                // duyệt,                                                                                // Đóng                                                                            // gói                                                                                               // xong)
        int countShipping = orderDAO.countOrdersByStatus(user.getId(), 4); // [SỬA] Đang giao là 4
        int countCompleted = orderDAO.countOrdersByStatus(user.getId(), 5); // [SỬA] Hoàn tất là 5
        int countCancelled = orderDAO.countOrdersByStatus(user.getId(), 6); // [SỬA] Hủy là 6

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
                listOrders.addAll(orderDAO.getOrdersByStatusForUser(user.getId(), 3)); // [SỬA] Thêm cả trạng thái 3 (Đã                                                           // đóng gói xong) vào tab Đang xử                                                                     // lý
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
                    case "shipping":
                        dbStatus = 4;
                        break; // [SỬA] 4
                    case "completed":
                        dbStatus = 5;
                        break; // [SỬA] 5
                    case "cancelled":
                        dbStatus = 6;
                        break; // [SỬA] 6
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

                if (currentOrder != null && currentOrder.getUserId() == user.getId()
                        && (currentOrder.getStatus() == 1 || currentOrder.getStatus() == 2)) {

                    // 1. Cập nhật trạng thái thành 5 (Đã hủy)
                    boolean isCancelled = orderDAO.updateOrderStatus(orderId, 6); // [SỬA] 6 là trạng thái Hủy

                    if (isCancelled) {
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
                    session.setAttribute("errorMsg",
                            "Đơn hàng không tồn tại hoặc không thể hủy ở trạng thái hiện tại.");
                }
            }
            // === LUỒNG 2: [MỚI] XỬ LÝ XÁC NHẬN ĐÃ NHẬN HÀNG ===
            else if ("confirm_receive".equals(action) && orderIdStr != null) {
                int orderId = Integer.parseInt(orderIdStr);
                OrderDAO orderDAO = new OrderDAO();

                Order currentOrder = orderDAO.getOrderById(orderId);

                // Rào bảo mật: Chỉ cho phép xác nhận nếu đơn này của chính user đó
                // VÀ trạng thái đang là 4 (Đang giao)
                if (currentOrder != null && currentOrder.getUserId() == user.getId()
                        && currentOrder.getStatus() == 4) {

                    // Cập nhật trạng thái thành 5 (Hoàn tất / Đã giao)
                    boolean isUpdated = orderDAO.updateOrderStatus(orderId, 5);

                    if (isUpdated) {
                        session.setAttribute("successMsg",
                                "Cảm ơn bạn đã xác nhận! Đơn hàng #" + orderId + " đã hoàn tất.");
                    } else {
                        session.setAttribute("errorMsg", "Không thể cập nhật trạng thái đơn hàng. Vui lòng thử lại!");
                    }
                } else {
                    session.setAttribute("errorMsg", "Yêu cầu không hợp lệ!");
                }
            }else if ("request_return".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String reason = request.getParameter("returnReason");
                String note = request.getParameter("returnNote");
                // THÊM ĐOẠN NÀY ĐỂ VALIDATE ĐỘ DÀI
                if (note != null && note.length() > 500) {
                    request.getSession().setAttribute("mess", "Chi tiết thêm không được vượt quá 500 ký tự!");
                    request.getSession().setAttribute("status", "error");
                    response.sendRedirect(request.getContextPath() + "/my-orders");
                    return;
                }
                String[] selectedBookIds = request.getParameterValues("selectedBookIds");

                // Gộp Lý do và Chi tiết lại
                String fullReason = reason;
                if (note != null && !note.trim().isEmpty()) {
                    fullReason = reason + " - Chi tiết: " + note.trim();
                }

                // ==========================================
                // XỬ LÝ UPLOAD FILE VÀ LẤY MIME TYPE (CÁCH BỌC THÉP)
                // ==========================================
                String proofImagePath = "";
                String mimeType = ""; 
                Part filePart = request.getPart("proofFile");
                
                if (filePart != null && filePart.getSize() > 0) {
                    mimeType = filePart.getContentType();
                    
                    try {
                        // 1. ĐƯỜNG DẪN TUYỆT ĐỐI RA NGOÀI Ổ CỨNG (Thay cho cách cũ)
                        String uploadPath = "D:" + File.separator + "Mindbook_Data" + File.separator + "returns";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }

                        // Đổi tên file cho khỏi trùng lặp
                        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        String uniqueFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                        
                        // LƯU FILE BẰNG INPUT STREAM
                        File fileToSave = new File(uploadDir, uniqueFileName);
                        try (java.io.InputStream fileContent = filePart.getInputStream()) {
                            java.nio.file.Files.copy(fileContent, fileToSave.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                        }
                        
                        // 2. ĐƯỜNG DẪN ẢO ĐỂ LƯU VÀO DATABASE (Sau này gắn thẻ <img> sẽ gọi link này)
                        proofImagePath = "/uploads/returns/" + uniqueFileName;

                    } catch (Exception ex) {
                        System.out.println("CẢNH BÁO - Lỗi khi lưu file ảnh: " + ex.getMessage());
                        // Dù lỗi lưu ảnh (do Tomcat), hệ thống VẪN TIẾP TỤC CHẠY xuống dưới để lưu DB!
                    }
                }

                OrderDAO orderDAO = new OrderDAO();
                Order currentOrder = orderDAO.getOrderById(orderId);

                if (currentOrder != null && currentOrder.getUserId() == user.getId()) {
                    if (selectedBookIds != null && selectedBookIds.length > 0) {
                        boolean allSuccess = true;

                        for (String bookIdStr : selectedBookIds) {
                            int bookId = Integer.parseInt(bookIdStr);
                            String qtyParam = request.getParameter("returnQty_" + bookId);
                            int returnQty = (qtyParam != null) ? Integer.parseInt(qtyParam) : 1;

                            // [SỬA Ở ĐÂY] Truyền thêm tham số mimeType vào hàm DAO
                            boolean isInserted = orderDAO.insertPartialReturnRequest(orderId, bookId, returnQty, fullReason, proofImagePath, mimeType);
                            
                            if (!isInserted) allSuccess = false;
                        }

                        if (allSuccess) {
                            orderDAO.updateOrderStatus(orderId, 7); 
                            request.getSession().setAttribute("mess", "Đã gửi yêu cầu trả hàng thành công. Chờ shop duyệt nhé!");
                            request.getSession().setAttribute("status", "success");
                        } else {
                            request.getSession().setAttribute("mess", "Có lỗi khi lưu sản phẩm trả hàng vào Database.");
                            request.getSession().setAttribute("status", "error");
                        }
                        
                    } else {
                        request.getSession().setAttribute("mess", "Bạn chưa tick chọn sản phẩm nào để trả!");
                        request.getSession().setAttribute("status", "warning");
                    }
                } else {
                    request.getSession().setAttribute("mess", "Không tìm thấy đơn hàng hợp lệ.");
                    request.getSession().setAttribute("status", "error");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Có lỗi xảy ra trong quá trình xử lý!");
        }

        // 3. Xong việc thì redirect ngược lại trang Lịch sử đơn hàng để nó tải lại danh
        // sách mới
        response.sendRedirect(request.getContextPath() + "/my-orders");
    }
}
