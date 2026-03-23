package com.group2.bookstore.controller;

import java.io.PrintWriter;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import com.group2.bookstore.dal.FPointHistoryDAO;
import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.FPointHistory;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffFPointServlet", urlPatterns = { "/staff/fpoint" })
public class StaffFPointServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Nhận các tham số lọc và hành động
        String action = request.getParameter("action");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String type = request.getParameter("type");

        FPointHistoryDAO historyDAO = new FPointHistoryDAO();

        // 2. Lấy danh sách đã được lọc từ Database
        List<FPointHistory> historyLogs = historyDAO.getFilteredHistory(startDate, endDate, type);

        // 3. NẾU NGƯỜI DÙNG BẤM "TẢI LOG" -> KÍCH HOẠT TẢI FILE CSV
        if ("export".equals(action)) {
            // Cấu hình Header để trình duyệt hiểu đây là file cần tải về
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"Lich_Su_FPoint.csv\"");

            // Ghi ký tự BOM (Byte Order Mark) để Microsoft Excel nhận diện đúng Tiếng Việt
            // UTF-8
            response.getOutputStream().write(239); // 0xEF
            response.getOutputStream().write(187); // 0xBB
            response.getOutputStream().write(191); // 0xBF

            PrintWriter writer = new PrintWriter(new OutputStreamWriter(response.getOutputStream(), "UTF-8"));

            // Ghi dòng Tiêu đề (Header) của bảng
            writer.println("Thời gian,Khách hàng,Biến động,Lý do");

            // Định dạng thời gian
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

            // Duyệt qua danh sách và in từng dòng dữ liệu
            for (FPointHistory log : historyLogs) {
                String time = sdf.format(log.getCreatedAt());

                // Xóa/Thay thế dấu phẩy trong chuỗi (nếu có) để không làm hỏng cấu trúc cột của
                // CSV
                String customer = log.getCustomerInfo().replace(",", " ");
                String reason = (log.getReason() != null) ? log.getReason().replace(",", " -") : "";

                String amountStr = (log.getActionType().equals("add") ? "+" : "-") + log.getAmount();

                // In dòng dữ liệu phân cách nhau bằng dấu phẩy
                writer.println(time + "," + customer + "," + amountStr + "," + reason);
            }

            writer.flush();
            writer.close();

            // Dừng luôn hàm doGet tại đây để không forward ra trang web nữa
            return;
        }

        // 4. NẾU KHÔNG PHẢI TẢI LOG -> HIỂN THỊ GIAO DIỆN WEB BÌNH THƯỜNG
        request.setAttribute("historyLogs", historyLogs);
        request.getRequestDispatcher("/view/staff/fpoint-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cấu hình UTF-8 để đọc được Tiếng Việt có dấu từ ô "Lý do"
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 1. Lấy dữ liệu gửi lên từ form
        String userInfo = request.getParameter("userInfo"); // Có thể là ID hoặc Email
        String actionType = request.getParameter("actionType"); // "add" hoặc "sub"
        String amountStr = request.getParameter("amount");
        String reason = request.getParameter("reason");

        UserDAO userDAO = new UserDAO();
        FPointHistoryDAO historyDAO = new FPointHistoryDAO();

        try {
            int amount = Integer.parseInt(amountStr);
            if (amount <= 0) {
                session.setAttribute("errorMessage", "Số điểm thao tác phải lớn hơn 0!");
                response.sendRedirect(request.getContextPath() + "/staff/fpoint");
                return;
            }

            // 2. Logic tìm kiếm User (Ưu tiên tìm theo ID trước, nếu lỗi parse số thì tìm
            // theo Email)
            User targetUser = null;
            try {
                int userId = Integer.parseInt(userInfo);
                targetUser = userDAO.getUserById(userId);
            } catch (NumberFormatException e) {
                // Người dùng nhập Email
                targetUser = userDAO.checkEmailExist(userInfo);
            }

            // Kiểm tra xem User có tồn tại hay không
            if (targetUser == null || targetUser.getRole() != 0) { // Giả sử role=0 là khách hàng
                session.setAttribute("errorMessage", "Không tìm thấy khách hàng với ID/Email này!");
                response.sendRedirect(request.getContextPath() + "/staff/fpoint");
                return;
            }

            // 3. Tạo chuỗi hiển thị tên khách hàng (VD: @quang (#1011))
            String customerDisplayInfo = "@" + targetUser.getUsername() + " (#" + targetUser.getId() + ")";

            // 4. Lưu log vào bảng FPoint_History
            // 4. Lưu log vào bảng FPoint_History
            FPointHistory log = new FPointHistory(targetUser.getId(), customerDisplayInfo, actionType, amount, reason);
            boolean isSaved = historyDAO.insertLog(log);

            // TÍNH TOÁN VÀ CẬP NHẬT ĐIỂM F-POINT THỰC TẾ
            if (isSaved) {
                int currentPoint = targetUser.getF_points();
                int newPoint = 0;

                if (actionType.equals("add")) {
                    newPoint = currentPoint + amount;
                } else {
                    newPoint = currentPoint - amount;
                    if (newPoint < 0)
                        newPoint = 0; // Đảm bảo điểm không bị âm
                }

                // Gọi hàm DAO vừa tạo ở Bước 2
                userDAO.updateUserPoint(targetUser.getId(), newPoint);

                session.setAttribute("successMessage", "Đã " + (actionType.equals("add") ? "cộng" : "trừ") +
                        " " + amount + " điểm cho khách hàng " + targetUser.getFullname());
            } else {
                session.setAttribute("errorMessage", "Có lỗi xảy ra khi ghi nhận trên hệ thống!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ, vui lòng kiểm tra lại!");
        }

        // 6. Dùng sendRedirect thay vì forward để tránh lỗi "Submit lại form" khi F5
        // trình duyệt
        response.sendRedirect(request.getContextPath() + "/staff/fpoint");
    }
}