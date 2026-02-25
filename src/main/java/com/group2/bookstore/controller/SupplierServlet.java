package com.group2.bookstore.controller;

import com.group2.bookstore.dal.SupplierDAO;
import com.group2.bookstore.model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "SupplierServlet", urlPatterns = {"/warehouse/supplier"})
public class SupplierServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SupplierDAO dao = new SupplierDAO();
        request.setAttribute("listS", dao.getAllSuppliers());
        request.getRequestDispatcher("/view/warehouse/supplier_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        SupplierDAO dao = new SupplierDAO();
        
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            Supplier s = new Supplier(0, 
                request.getParameter("name"), 
                request.getParameter("contactPerson"), 
                request.getParameter("phone"), 
                request.getParameter("email"), 
                request.getParameter("address"), true);
            dao.addSupplier(s);
        } 
        else if ("update".equals(action)) {
            Supplier s = new Supplier(
                Integer.parseInt(request.getParameter("id")), 
                request.getParameter("name"), 
                request.getParameter("contactPerson"), 
                request.getParameter("phone"), 
                request.getParameter("email"), 
                request.getParameter("address"), true);
            dao.updateSupplier(s);
        } 
        else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteSupplier(id);
        }

        // Sau khi xử lý xong, redirect lại trang danh sách để load lại data
        response.sendRedirect("supplier");
    }
}