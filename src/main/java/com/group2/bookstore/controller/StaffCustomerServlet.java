package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffCustomerServlet", urlPatterns = { "/staff/customers" })
public class StaffCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();

        // --- XỬ LÝ V.I.P 1: KHÓA / MỞ KHÓA TÀI KHOẢN ---
        String action = request.getParameter("action");
        if ("toggleStatus".equals(action)) {
            String idRaw = request.getParameter("id");
            String statusRaw = request.getParameter("status"); // Trạng thái hiện tại

            if (idRaw != null && statusRaw != null) {
                try {
                    int id = Integer.parseInt(idRaw);
                    int currentStatus = Integer.parseInt(statusRaw);

                    // Đảo ngược trạng thái: Nếu đang 1 (Hoạt động) thì thành 0 (Khóa), và ngược lại
                    int newStatus = (currentStatus == 1) ? 0 : 1;

                    userDAO.updateUserStatus(id, newStatus);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            // Làm xong thì "quay xe" tải lại trang để thấy kết quả cập nhật ngay
            response.sendRedirect(request.getContextPath() + "/staff/customers");
            return; // Bắt buộc phải có return để dừng hàm doGet ở đây
        }
        String keyword = request.getParameter("keyword"); // Lấy từ khóa từ ô tìm kiếm
        List<User> listCustomers;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Nếu có gõ tìm kiếm -> Gọi hàm Search
            listCustomers = userDAO.searchCustomers(keyword);
            request.setAttribute("keyword", keyword); // Giữ lại từ khóa trên ô input
        } else {
            // Nếu không tìm kiếm -> Hiển thị tất cả
            listCustomers = userDAO.getAllCustomers();
        }

        request.setAttribute("listCustomers", listCustomers);
        request.getRequestDispatcher("/view/staff/customer-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}