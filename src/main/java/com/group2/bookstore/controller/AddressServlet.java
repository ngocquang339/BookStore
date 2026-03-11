package com.group2.bookstore.controller;

import com.group2.bookstore.dal.AddressDAO;
import com.group2.bookstore.model.Address;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

// Bổ sung thêm "/edit-address" vào mảng urlPatterns
@WebServlet(name = "AddressServlet", urlPatterns = {"/address", "/add-address", "/edit-address"})
public class AddressServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect("login"); 
            return;
        }

        String path = request.getServletPath();

        // 1. NẾU LÀ TRANG HIỂN THỊ SỔ ĐỊA CHỈ HOẶC MỞ FORM SỬA
        if ("/address".equals(path)) {
            String action = request.getParameter("action");
            AddressDAO addressDAO = new AddressDAO();

            if ("edit".equals(action)) {
                try {
                    int addressId = Integer.parseInt(request.getParameter("id"));
                    Address address = addressDAO.getAddressById(addressId, user.getId());
                    
                    if (address != null) {
                        // KHÔNG CẦN CẮT CHUỖI NỮA! Truyền thẳng object address sang JSP
                        request.setAttribute("address", address);
                        request.getRequestDispatcher("view/edit-address.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("address");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("address");
                }
            }
            // 1.2 - BỔ SUNG THÊM: Nếu action=delete -> Xử lý xóa địa chỉ
            // 1.2 - BỔ SUNG THÊM: Nếu action=delete -> Xử lý xóa địa chỉ
            else if ("delete".equals(action)) {
                try {
                    int addressId = Integer.parseInt(request.getParameter("id"));
                    boolean isSuccess = addressDAO.deleteAddress(addressId, user.getId());
                    
                    if (isSuccess) {
                        session.setAttribute("mess", "Đã xóa địa chỉ thành công!");
                        session.setAttribute("status", "success");
                    } else {
                        session.setAttribute("mess", "Xóa địa chỉ thất bại!");
                        session.setAttribute("status", "error");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("mess", "Đã xảy ra lỗi hệ thống!");
                    session.setAttribute("status", "error");
                }
                
                // --- ĐOẠN CODE MỚI ĐỂ CHUYỂN HƯỚNG ĐÚNG CHỖ ---
                String source = request.getParameter("source");
                if ("checkout".equals(source)) {
                    response.sendRedirect("checkout"); // Về lại trang thanh toán
                } else {
                    response.sendRedirect("address");  // Về trang quản lý địa chỉ mặc định
                }
                // ----------------------------------------------
            }
            // 1.3 - Nếu không có action -> Hiển thị danh sách Sổ địa chỉ (Mặc định)
            else {
                List<Address> listAddresses = addressDAO.getAddressesByUserId(user.getId());
                request.setAttribute("listAddresses", listAddresses);
                request.getRequestDispatcher("view/address-book.jsp").forward(request, response);
            } 
            // 1.2 - Nếu không có action -> Hiển thị danh sách Sổ địa chỉ (Mặc định)
        } 
        // 2. NẾU LÀ TRANG THÊM ĐỊA CHỈ MỚI
        else if ("/add-address".equals(path)) {
            String source = request.getParameter("source");
            if ("checkout".equals(source)) {
                response.sendRedirect("checkout"); // Trả về trang thanh toán ngay lập tức
            } else {
                response.sendRedirect("address");  // Trả về trang hồ sơ cá nhân
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String path = request.getServletPath();
        AddressDAO addressDAO = new AddressDAO();

        // XỬ LÝ 1: SUBMIT FORM THÊM ĐỊA CHỈ (Code cũ của bạn)
        if ("/add-address".equals(path)) {
            try {
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String country = request.getParameter("country");
                String city = request.getParameter("city");
                String district = request.getParameter("district");
                String ward = request.getParameter("ward");
                String addressDetail = request.getParameter("addressDetail");
                String zipCode = request.getParameter("zipCode");

                boolean isDefaultBilling = request.getParameter("isDefaultBilling") != null;
                boolean isDefaultShipping = request.getParameter("isDefaultShipping") != null;

                Address address = new Address();
                address.setUserId(user.getId());
                address.setFullName(fullName);
                address.setPhone(phone);
                address.setCountry(country);
                address.setCity(city);
                address.setDistrict(district);
                address.setWard(ward);
                address.setAddressDetail(addressDetail);
                address.setZipCode(zipCode);
                address.setDefaultBilling(isDefaultBilling);
                address.setDefaultShipping(isDefaultShipping);

                boolean isSuccess = addressDAO.insertAddress(address);

                if (isSuccess) {
                    session.setAttribute("mess", "Thêm địa chỉ mới thành công!");
                    session.setAttribute("status", "success");
                } else {
                    session.setAttribute("mess", "Không thể thêm địa chỉ. Vui lòng thử lại!");
                    session.setAttribute("status", "error");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("mess", "Đã xảy ra lỗi hệ thống!");
                session.setAttribute("status", "error");
            }
            String source = request.getParameter("source");

            // ================= ĐIỀU HƯỚNG THÔNG MINH =================
            if ("checkout".equals(source)) {
                // Nếu form được gửi từ Modal ở trang Thanh toán -> Trả về trang Thanh toán
                response.sendRedirect(request.getContextPath() + "/checkout"); 
            } else {
                // Nếu form được gửi từ trang Quản lý tài khoản bình thường -> Trả về trang Địa chỉ
                response.sendRedirect(request.getContextPath() + "/address"); 
            }
        }
        
        // XỬ LÝ 2: SUBMIT FORM SỬA ĐỊA CHỈ (CODE MỚI THÊM)
        else if ("/edit-address".equals(path)) {
            try {
                int addressId = Integer.parseInt(request.getParameter("addressId"));
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String city = request.getParameter("city");
                String district = request.getParameter("district");
                String ward = request.getParameter("ward");
                String addressDetail = request.getParameter("addressDetail");
                boolean isDefaultShipping = request.getParameter("isDefaultShipping") != null;

                Address address = addressDAO.getAddressById(addressId, user.getId());
                if (address != null) {
                    address.setFullName(fullName);
                    address.setPhone(phone);
                    address.setCity(city);
                    address.setDistrict(district);
                    address.setWard(ward);
                    address.setAddressDetail(addressDetail);
                    address.setDefaultShipping(isDefaultShipping);

                    boolean isSuccess = addressDAO.updateAddress(address);

                    if (isSuccess) {
                        session.setAttribute("mess", "Cập nhật địa chỉ thành công!");
                        session.setAttribute("status", "success");
                    } else {
                        session.setAttribute("mess", "Cập nhật thất bại. Vui lòng thử lại!");
                        session.setAttribute("status", "error");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("mess", "Đã xảy ra lỗi hệ thống!");
                session.setAttribute("status", "error");
            }

            // --- ĐOẠN CODE MỚI ĐỂ CHUYỂN HƯỚNG ĐÚNG CHỖ ---
            String source = request.getParameter("source");
            if ("checkout".equals(source)) {
                response.sendRedirect("checkout"); // Sửa ở checkout thì về checkout
            } else {
                response.sendRedirect("address");  // Sửa ở address thì về address
            }
            // ----------------------------------------------
        }
    }
}