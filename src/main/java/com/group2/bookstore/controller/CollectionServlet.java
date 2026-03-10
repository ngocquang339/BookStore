package com.group2.bookstore.controller;

import com.group2.bookstore.dal.CollectionDAO;
import com.group2.bookstore.model.Collection;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CollectionServlet", urlPatterns = {"/my-collections"})
public class CollectionServlet extends HttpServlet {

    // ====================================================================
    // DO GET: Xử lý việc HIỂN THỊ giao diện (Đọc danh sách)
    // ====================================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập (Bảo mật cơ bản)
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CollectionDAO dao = new CollectionDAO();
        
        // 2. Lấy danh sách Bộ sưu tập của User này
        List<Collection> listCollections = dao.getCollectionsByUserId(user.getId());
        
        // 3. Đẩy dữ liệu sang trang JSP để hiển thị
        request.setAttribute("listCollections", listCollections);
        request.getRequestDispatcher("view/MyCollections.jsp").forward(request, response);
    }

    // ====================================================================
    // DO POST: Xử lý các Form Hành động (Thêm mới, Sửa, Xóa)
    // ====================================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Đảm bảo tiếng Việt không bị lỗi font khi nhận từ Form
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        CollectionDAO dao = new CollectionDAO();

        try {
            // LƯỚI PHÂN LUỒNG HÀNH ĐỘNG
            switch (action) {
                case "create":
                    createCollection(request, response, user, dao, session);
                    break;
                case "update":
                    updateCollection(request, response, user, dao, session);
                    break;
                case "delete":
                    deleteCollection(request, response, user, dao, session);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/my-collections");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Có lỗi hệ thống xảy ra!");
            response.sendRedirect(request.getContextPath() + "/my-collections");
        }
    }

    // --- HÀM XỬ LÝ THÊM MỚI ---
    private void createCollection(HttpServletRequest request, HttpServletResponse response, User user, CollectionDAO dao, HttpSession session) throws IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        boolean isPublic = "1".equals(request.getParameter("isPublic"));
        String coverColor = request.getParameter("coverColor");

        Collection c = new Collection(0, user.getId(), name, description, isPublic, coverColor, null);
        
        if (dao.createCollection(c)) {
            session.setAttribute("successMsg", "Tạo Bộ sưu tập thành công!");
        } else {
            session.setAttribute("errorMsg", "Không thể tạo Bộ sưu tập. Thử lại sau!");
        }
        response.sendRedirect(request.getContextPath() + "/my-collections");
    }

    // --- HÀM XỬ LÝ CẬP NHẬT ---
    private void updateCollection(HttpServletRequest request, HttpServletResponse response, User user, CollectionDAO dao, HttpSession session) throws IOException {
        int collectionId = Integer.parseInt(request.getParameter("collectionId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        boolean isPublic = "1".equals(request.getParameter("isPublic"));
        String coverColor = request.getParameter("coverColor");

        Collection c = new Collection(collectionId, user.getId(), name, description, isPublic, coverColor, null);

        if (dao.updateCollection(c)) {
            session.setAttribute("successMsg", "Cập nhật thành công!");
        } else {
            session.setAttribute("errorMsg", "Cập nhật thất bại! Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/my-collections");
    }

    // --- HÀM XỬ LÝ XÓA ---
    private void deleteCollection(HttpServletRequest request, HttpServletResponse response, User user, CollectionDAO dao, HttpSession session) throws IOException {
        int collectionId = Integer.parseInt(request.getParameter("collectionId"));

        // Truyền cả userId vào để đảm bảo tính bảo mật (Chỉ chủ sở hữu mới xóa được)
        if (dao.deleteCollection(collectionId, user.getId())) {
            session.setAttribute("successMsg", "Đã xóa Bộ sưu tập!");
        } else {
            session.setAttribute("errorMsg", "Xóa thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/my-collections");
    }
}