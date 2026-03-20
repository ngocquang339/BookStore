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
            }
            // 1.3 - Nếu không có action -> Hiển thị danh sách Sổ địa chỉ (Mặc định)
            else {
                List<Address> listAddresses = addressDAO.getAddressesByUserId(user.getId());
                request.setAttribute("listAddresses", listAddresses);
                request.getRequestDispatcher("view/address-book.jsp").forward(request, response);
            } 
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

        // =========================================================
        // KIỂM TRA DỮ LIỆU ĐẦU VÀO (BACKEND VALIDATION CHO EX 1 -> EX 5)
        // (Áp dụng chung cho cả THÊM và SỬA)
        // =========================================================
        if ("/add-address".equals(path) || "/edit-address".equals(path)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String city = request.getParameter("city");
            String district = request.getParameter("district");
            String ward = request.getParameter("ward");
            String addressDetail = request.getParameter("addressDetail");

            // [EX 5]: Thiếu Dropdown Tỉnh/Huyện/Xã
            if (city == null || district == null || ward == null || city.isEmpty() || district.isEmpty() || ward.isEmpty()) {
                session.setAttribute("mess", "This field is required (Vui lòng chọn đầy đủ địa giới).");
                session.setAttribute("status", "error");
                response.sendRedirect(request.getContextPath() + "/address");
                return;
            }
            // [EX 2]: Tên quá dài
            if (fullName == null || fullName.trim().length() > 50) {
                session.setAttribute("mess", "Length cannot exceed 50 characters.");
                session.setAttribute("status", "error");
                response.sendRedirect(request.getContextPath() + "/address");
                return;
            }
            // [EX 1]: Tên chứa số
            if (fullName.matches(".*\\d.*")) {
                session.setAttribute("mess", "Name cannot contain numbers.");
                session.setAttribute("status", "error");
                response.sendRedirect(request.getContextPath() + "/address");
                return;
            }
            // [EX 3]: SĐT sai định dạng (Bắt buộc 10 số, bắt đầu bằng 0)
            if (phone == null || !phone.matches("^0\\d{9}$")) {
                session.setAttribute("mess", "Phone number must contain only digits, be exactly 10 digits, and start with 0.");
                session.setAttribute("status", "error");
                response.sendRedirect(request.getContextPath() + "/address");
                return;
            }
            // [EX 4]: Chi tiết địa chỉ quá dài
            if (addressDetail == null || addressDetail.trim().length() > 100) {
                session.setAttribute("mess", "Address cannot exceed 100 characters.");
                session.setAttribute("status", "error");
                response.sendRedirect(request.getContextPath() + "/address");
                return;
            }
        }
        // =========================================================
        // XỬ LÝ 1: SUBMIT FORM THÊM ĐỊA CHỈ
        // =========================================================
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

                // --- LẤY MÃ GHN TỪ THẺ HIDDEN INPUT ---
                String districtIdStr = request.getParameter("districtIdGHN");
                int districtIdGHN = (districtIdStr != null && !districtIdStr.isEmpty()) ? Integer.parseInt(districtIdStr) : 0;
                String wardCodeGHN = request.getParameter("wardCodeGHN");

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
                
                // --- SET MÃ GHN VÀO OBJECT ---
                address.setDistrictId(districtIdGHN);
                address.setWardCode(wardCodeGHN);

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

            if ("checkout".equals(source)) {
                response.sendRedirect(request.getContextPath() + "/checkout"); 
            } else {
                response.sendRedirect(request.getContextPath() + "/address"); 
            }
        }
        
        // =========================================================
        // XỬ LÝ 2: SUBMIT FORM SỬA ĐỊA CHỈ
        // =========================================================
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

                // --- LẤY MÃ GHN TỪ THẺ HIDDEN INPUT ---
                String districtIdStr = request.getParameter("districtIdGHN");
                int districtIdGHN = (districtIdStr != null && !districtIdStr.isEmpty()) ? Integer.parseInt(districtIdStr) : 0;
                String wardCodeGHN = request.getParameter("wardCodeGHN");

                Address address = addressDAO.getAddressById(addressId, user.getId());
                if (address != null) {
                    address.setFullName(fullName);
                    address.setPhone(phone);
                    address.setCity(city);
                    address.setDistrict(district);
                    address.setWard(ward);
                    address.setAddressDetail(addressDetail);
                    address.setDefaultShipping(isDefaultShipping);
                    
                    // --- SET MÃ GHN VÀO OBJECT ---
                    address.setDistrictId(districtIdGHN);
                    address.setWardCode(wardCodeGHN);

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

            String source = request.getParameter("source");
            if ("checkout".equals(source)) {
                response.sendRedirect("checkout"); 
            } else {
                response.sendRedirect("address");  
            }
        }
    }
}