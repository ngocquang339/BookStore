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
            if ("add".equals(action)) {
                Location l = new Location(0, 
                    request.getParameter("zone"), 
                    request.getParameter("rack"), 
                    request.getParameter("shelf"), null, 
                    Integer.parseInt(request.getParameter("categoryId")), null, 
                    request.getParameter("description"));
                dao.addLocation(l);
            } 
            else if ("update".equals(action)) {
                Location l = new Location(
                    Integer.parseInt(request.getParameter("id")), 
                    request.getParameter("zone"), 
                    request.getParameter("rack"), 
                    request.getParameter("shelf"), null, 
                    Integer.parseInt(request.getParameter("categoryId")), null, 
                    request.getParameter("description"));
                dao.updateLocation(l);
            } 
            else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteLocation(id);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Bắt lỗi parse số (nếu có)
        }
        
        response.sendRedirect("location");
    }
}