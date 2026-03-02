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

        try {
            if ("add".equals(action) || "update".equals(action)) {
                String name = request.getParameter("name");
                String contactPerson = request.getParameter("contactPerson");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                String address = request.getParameter("address");

                // Validate Rỗng
                if (name == null || name.trim().isEmpty() || phone == null || phone.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() || address == null || address.trim().isEmpty()) {
                    throw new Exception("Vui lòng nhập đầy đủ Tên, SĐT, Email và Địa chỉ!");
                }
                
                name = name.trim(); phone = phone.trim(); email = email.trim(); address = address.trim();
                if(contactPerson != null) contactPerson = contactPerson.trim();

                // Validate Định dạng
                if (!phone.matches("^[0-9]{10,11}$")) throw new Exception("Số điện thoại phải từ 10-11 số.");
                if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) throw new Exception("Email không hợp lệ.");

                Supplier s = new Supplier();
                s.setName(name);
                s.setContactPerson(contactPerson);
                s.setPhone(phone);
                s.setEmail(email);
                s.setAddress(address);
                s.setActive(true);

                if ("add".equals(action)) {
                    dao.addSupplier(s);
                    request.setAttribute("successMessage", "Thêm nhà cung cấp thành công!");
                } else {
                    s.setId(Integer.parseInt(request.getParameter("id")));
                    dao.updateSupplier(s);
                    request.setAttribute("successMessage", "Cập nhật nhà cung cấp thành công!");
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteSupplier(id);
                request.setAttribute("successMessage", "Xóa nhà cung cấp thành công!");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
        }

        // Forward lại trang để hiện thông báo thay vì redirect
        request.setAttribute("listS", dao.getAllSuppliers());
        request.getRequestDispatcher("/view/warehouse/supplier_list.jsp").forward(request, response);
    }
}