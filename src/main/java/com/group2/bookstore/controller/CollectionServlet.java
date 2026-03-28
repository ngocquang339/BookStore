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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CollectionDAO dao = new CollectionDAO();
    
        List<Collection> listCollections = dao.getCollectionsByUserId(user.getId());
        
        request.setAttribute("listCollections", listCollections);
        request.getRequestDispatcher("view/MyCollections.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
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
                case "addBook":
                    addBookToCollection(request, response, user, dao, session);
                    break;
                case "removeBook":
                    removeBookFromCollection(request, response, user, dao, session);
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

    private void createCollection(HttpServletRequest request, HttpServletResponse response, User user, CollectionDAO dao, HttpSession session) throws IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        boolean isPublic = "1".equals(request.getParameter("isPublic"));
        String coverColor = request.getParameter("coverColor");

        if (name == null || name.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Collection name is required (Tên giá sách không được để trống)!");
            response.sendRedirect(request.getContextPath() + "/my-collections");
            return;
        }

        if (name.length() > 50) {
            session.setAttribute("errorMsg", "Tên giá sách không được vượt quá 50 ký tự!");
            response.sendRedirect(request.getContextPath() + "/my-collections");
            return;
        }
        if (description != null && description.length() > 250) {
            session.setAttribute("errorMsg", "Mô tả ngắn không được vượt quá 250 ký tự!");
            response.sendRedirect(request.getContextPath() + "/my-collections");
            return;
        }
        
        if (dao.isNameExist(user.getId(), name.trim(), -1)) {
            session.setAttribute("errorMsg", "Bạn đã có bộ sưu tập với tên này!");
            response.sendRedirect(request.getContextPath() + "/my-collections");
            return;
        }

        Collection c = new Collection(0, user.getId(), name.trim(), description, isPublic, coverColor, null);
        
        if (dao.createCollection(c)) {
            session.setAttribute("successMsg", "Tạo Bộ sưu tập thành công!");
        } else {
            session.setAttribute("errorMsg", "Không thể tạo Bộ sưu tập. Thử lại sau!");
        }
        response.sendRedirect(request.getContextPath() + "/my-collections");
    }

    private void updateCollection(HttpServletRequest request, HttpServletResponse response, User user, CollectionDAO dao, HttpSession session) throws IOException {
        int collectionId = Integer.parseInt(request.getParameter("collectionId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        boolean isPublic = "1".equals(request.getParameter("isPublic"));
        String coverColor = request.getParameter("coverColor");

        if (name == null || name.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Tên giá sách không được để trống!");
            response.sendRedirect(request.getContextPath() + "/my-collections");
            return;
        }

        if (name.length() > 50) {
            session.setAttribute("errorMsg", "Tên giá sách không được vượt quá 50 ký tự!");
            response.sendRedirect(request.getContextPath() + "/my-collections");
            return;
        }
        if (description != null && description.length() > 250) {
            session.setAttribute("errorMsg", "Mô tả ngắn không được vượt quá 250 ký tự!");
            response.sendRedirect(request.getContextPath() + "/my-collections");
            return;
        }

        if (dao.isNameExist(user.getId(), name.trim(), collectionId)) {
            session.setAttribute("errorMsg", "Bạn đã có một bộ sưu tập khác mang tên này!");
            response.sendRedirect(request.getContextPath() + "/my-collections");
            return;
        }

        Collection c = new Collection(collectionId, user.getId(), name.trim(), description, isPublic, coverColor, null);

        if (dao.updateCollection(c)) {
            session.setAttribute("successMsg", "Cập nhật thành công!");
        } else {
            session.setAttribute("errorMsg", "Cập nhật thất bại! Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/my-collections");
    }

    private void deleteCollection(HttpServletRequest request, HttpServletResponse response, User user, CollectionDAO dao, HttpSession session) throws IOException {
        int collectionId = Integer.parseInt(request.getParameter("collectionId"));

        if (dao.deleteCollection(collectionId, user.getId())) {
            session.setAttribute("successMsg", "Đã xóa Bộ sưu tập!");
        } else {
            session.setAttribute("errorMsg", "Xóa thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/my-collections");
    }

    private void addBookToCollection(HttpServletRequest request, HttpServletResponse response, User user, CollectionDAO dao, HttpSession session) throws IOException {
        int collectionId = Integer.parseInt(request.getParameter("collectionId"));
        int bookId = Integer.parseInt(request.getParameter("bookId"));

        if (dao.addBookToCollection(collectionId, bookId)) {
            session.setAttribute("successMsg", "Đã lưu sách vào Bộ sưu tập thành công!");
        } else {
            session.setAttribute("errorMsg", "Sách này đã tồn tại trong Bộ sưu tập hoặc có lỗi xảy ra!");
        }
        
        response.sendRedirect(request.getContextPath() + "/detail?pid=" + bookId); 
    }

    private void removeBookFromCollection(HttpServletRequest request, HttpServletResponse response, User user, CollectionDAO dao, HttpSession session) throws IOException {
        int collectionId = Integer.parseInt(request.getParameter("collectionId"));
        int bookId = Integer.parseInt(request.getParameter("bookId"));

        Collection c = dao.getCollectionById(collectionId);
        if (c != null && c.getUserId() == user.getId()) {
            dao.removeBookFromCollection(collectionId, bookId);
            session.setAttribute("successMsg", "Đã gỡ sách khỏi bộ sưu tập!");
        }
        response.sendRedirect(request.getContextPath() + "/collection-detail?id=" + collectionId);
    }
}