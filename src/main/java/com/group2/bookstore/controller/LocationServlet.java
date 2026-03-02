package com.group2.bookstore.controller;

import com.group2.bookstore.dal.CategoryDAO;
import com.group2.bookstore.dal.LocationDAO;
import com.group2.bookstore.model.Location;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "LocationServlet", urlPatterns = {"/warehouse/location"})
public class LocationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LocationDAO dao = new LocationDAO();
        CategoryDAO cDao = new CategoryDAO(); // Tái sử dụng CategoryDAO để lấy danh sách thể loại nạp vào dropdown
        
        request.setAttribute("listL", dao.getAllLocations());
        request.setAttribute("listC", cDao.getAllCategories());
        
        request.getRequestDispatcher("/view/warehouse/location_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        LocationDAO dao = new LocationDAO();
        String action = request.getParameter("action");

        try {
            if ("add".equals(action) || "update".equals(action)) {
                String zone = request.getParameter("zone");
                String rack = request.getParameter("rack");
                String shelf = request.getParameter("shelf");
                String categoryIdStr = request.getParameter("categoryId");
                String description = request.getParameter("description");

                if (zone == null || zone.trim().isEmpty() || rack == null || rack.trim().isEmpty() || shelf == null || shelf.trim().isEmpty()) {
                    throw new Exception("Khu, Kệ và Tầng không được để trống!");
                }

                zone = zone.trim().toUpperCase(); rack = rack.trim(); shelf = shelf.trim();

                if (!zone.matches("^[A-Z]$")) throw new Exception("Khu phải là 1 chữ cái (VD: A, B, C).");
                if (!rack.matches("^[0-9]{1}$")) throw new Exception("Kệ phải có đúng 2 chữ số (VD: 01, 02).");
                if (!shelf.matches("^0[1-5]$")) throw new Exception("Tầng phải từ 01 đến 05.");

                int categoryId = 0;
                try { categoryId = Integer.parseInt(categoryIdStr); } catch (Exception e) {}
                if (categoryId <= 0) throw new Exception("Vui lòng chọn Thể loại cho kệ!");

                Location l = new Location();
                l.setZone(zone);
                l.setRack(rack);
                l.setShelf(shelf);
                l.setCategoryId(categoryId);
                l.setDescription(description);

                if ("add".equals(action)) {
                    dao.addLocation(l);
                    request.setAttribute("successMessage", "Thêm vị trí thành công!");
                } else {
                    l.setId(Integer.parseInt(request.getParameter("id")));
                    dao.updateLocation(l);
                    request.setAttribute("successMessage", "Cập nhật vị trí thành công!");
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteLocation(id);
                request.setAttribute("successMessage", "Xóa vị trí thành công!");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
        }

        // Forward lại trang kèm theo data và thông báo
        com.group2.bookstore.dal.CategoryDAO cDao = new com.group2.bookstore.dal.CategoryDAO();
        request.setAttribute("listL", dao.getAllLocations());
        request.setAttribute("listC", cDao.getAllCategories());
        request.getRequestDispatcher("/view/warehouse/location_list.jsp").forward(request, response);
    }
}