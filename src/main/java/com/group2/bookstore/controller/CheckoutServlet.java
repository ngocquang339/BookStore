package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.dal.VoucherDAO;
import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.AddressDAO;
import com.group2.bookstore.model.Address;
import com.group2.bookstore.model.CartItem;
import com.group2.bookstore.model.User;
import com.group2.bookstore.model.Book;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        UserDAO userDAO = new UserDAO();
        user = userDAO.getUserById(user.getId()); // Kéo bản cập nhật mới nhất lên
        session.setAttribute("user", user);

        BookDAO dao = new BookDAO();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // 1. KIỂM TRA XEM CÓ PARAMETER TỪ GIỎ HÀNG GỬI LÊN KHÔNG
        String[] selectedItems = req.getParameterValues("selectedItems");

        if (selectedItems != null && selectedItems.length > 0) {
            // === TRƯỜNG HỢP A: ĐI TỪ GIỎ HÀNG SANG (Có chọn sách) ===
            List<CartItem> checkoutCart = new ArrayList<>();
            double checkoutTotal = 0.0;
            int flag = 0;
            int bId = 0;

            // Trong vòng lặp xử lý selectedItems của bạn
            for (String idStr : selectedItems) {
                try {
                    int bookId = Integer.parseInt(idStr);
                    Book book = dao.getBookById(bookId);

                    // Tìm CartItem tương ứng để biết khách muốn mua bao nhiêu
                    CartItem currentItem = null;
                    for (CartItem item : cart) {
                        if (item.getBook().getId() == bookId) {
                            currentItem = item;
                            break;
                        }
                    }

                    if (currentItem != null) {
                        // KIỂM TRA: Kho còn ít hơn số lượng khách muốn mua
                        if (book.getStockQuantity() < currentItem.getQuantity()) {
                            flag = 1;
                            bId = book.getId();
                            session.setAttribute("cartError", "Sản phẩm " + book.getTitle() + " chỉ còn "
                                    + book.getStockQuantity() + " sản phẩm!");
                            break;
                        }
                        checkoutCart.add(currentItem);
                        checkoutTotal += (currentItem.getQuantity() * currentItem.getBook().getPrice());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if (flag == 1) {
                session.setAttribute("cartError", "Sản phẩm " + dao.getBookById(bId).getTitle() + " đã hết hàng!");
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            // LƯU VÀO SESSION ĐỂ DÙNG DẦN
            session.setAttribute("checkoutCart", checkoutCart);
            session.setAttribute("grandTotal", checkoutTotal);

            double fpointDiscountUI = checkoutTotal * user.getDiscountRate();
            req.setAttribute("fpointDiscountUI", fpointDiscountUI);

        } else {
            // === TRƯỜNG HỢP B: BỊ ĐÁ VỀ SAU KHI XÓA/SỬA ĐỊA CHỈ HOẶC F5 TRANG ===
            // Lấy lại giỏ hàng đã lưu trong Session ra
            List<CartItem> checkoutCart = (List<CartItem>) session.getAttribute("checkoutCart");

            // Nếu trong Session cũng không có nốt, lúc này mới thực sự là lỗi -> Đuổi về
            // Cart
            if (checkoutCart == null || checkoutCart.isEmpty()) {
                session.setAttribute("cartError", "Vui lòng chọn ít nhất 1 sản phẩm để thanh toán!");
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }
            // Nếu có rồi thì bỏ qua, đi tiếp xuống dưới để load địa chỉ ra giao diện!
        }

        // 2. LOAD LẠI DANH SÁCH ĐỊA CHỈ (Dù có xóa hay sửa thì nó sẽ cập nhật mới nhất
        // ở đây)
        AddressDAO addressDAO = new AddressDAO();
        List<Address> listAddresses = addressDAO.getAddressesByUserId(user.getId());
        req.setAttribute("listAddresses", listAddresses);

        // Hiển thị lỗi từ doPost nếu có
        if (session.getAttribute("errorMsg") != null) {
            req.setAttribute("errorMsg", session.getAttribute("errorMsg"));
            session.removeAttribute("errorMsg");
        }

        VoucherDAO voucherDAO = new VoucherDAO();
        req.setAttribute("wallet", voucherDAO.getUserWallet(user.getId()));
        req.getRequestDispatcher("/view/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        List<CartItem> checkoutCart = (List<CartItem>) session.getAttribute("checkoutCart");
        List<CartItem> mainCart = (List<CartItem>) session.getAttribute("cart");

        if (user == null || checkoutCart == null || checkoutCart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }
        UserDAO userDAO = new UserDAO();
        user = userDAO.getUserById(user.getId()); // Kéo bản cập nhật mới nhất lên
        session.setAttribute("user", user);
        // 1. NHẬN PHƯƠNG THỨC THANH TOÁN VÀ ID ĐỊA CHỈ TỪ FORM (JSP MỚI)
        String paymentMethod = req.getParameter("paymentMethod");
        String selectedAddressIdStr = req.getParameter("selectedAddressId");

        // Bắt lỗi nếu người dùng cố tình không chọn địa chỉ (f12 xóa thuộc tính
        // required)
        if (selectedAddressIdStr == null || selectedAddressIdStr.isEmpty()) {
            session.setAttribute("errorMsg", "Vui lòng chọn địa chỉ giao hàng!");
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        try {
            // 2. LẤY CHI TIẾT ĐỊA CHỈ TỪ DATABASE THÔNG QUA ID
            int addressId = Integer.parseInt(selectedAddressIdStr);
            AddressDAO addressDAO = new AddressDAO();

            // Lấy object Address ra (Nếu hàm của bạn tên khác, hãy sửa lại cho đúng)
            Address selectedAddress = addressDAO.getAddressById(addressId, user.getId());

            if (selectedAddress == null) {
                resp.sendRedirect(req.getContextPath() + "/checkout");
                return;
            }

            // 3. TẠO CHUỖI ĐỊA CHỈ HOÀN CHỈNH VÀ LẤY SĐT ĐỂ LƯU VÀO BẢNG ORDER
            String receiverName = selectedAddress.getFullName();
            String phone = selectedAddress.getPhone();
            // Nối chuỗi y hệt cách bạn hiển thị ngoài giao diện JSP
            String shippingAddress = selectedAddress.getAddressDetail() + ", " +
                    selectedAddress.getWard() + ", " +
                    selectedAddress.getDistrict() + ", " +
                    selectedAddress.getCity();

            Double grandTotal = (Double) session.getAttribute("grandTotal");
            // ===============================================================
            // [MỚI] TÒA ÁN TỐI CAO JAVA TÍNH TOÁN LẠI VOUCHER
            // ===============================================================
            String appliedVoucherIdStr = req.getParameter("appliedVoucherId");
            int appliedVoucherId = 0;
            double discount = 0;
            double finalTotal = grandTotal; // Mặc định số tiền cuối cùng = tiền gốc

            if (appliedVoucherIdStr != null && !appliedVoucherIdStr.trim().isEmpty()) {
                appliedVoucherId = Integer.parseInt(appliedVoucherIdStr);
                VoucherDAO voucherDAO = new VoucherDAO();

                // Lấy ví ra đối chiếu để chống Hacker tự chế mã ID
                List<com.group2.bookstore.model.UserVoucher> wallet = voucherDAO.getUserWallet(user.getId());
                com.group2.bookstore.model.UserVoucher validVoucher = null;
                for (com.group2.bookstore.model.UserVoucher uv : wallet) {
                    if (uv.getVoucherId() == appliedVoucherId) {
                        validVoucher = uv;
                        break;
                    }
                }

                if (validVoucher != null) {
                    com.group2.bookstore.model.Voucher v = validVoucher.getVoucher();
                    // Xác nhận lại đơn hàng có đủ điều kiện Min Order không
                    if (grandTotal >= v.getMinOrderValue()) {
                        if (v.getDiscountPercent() > 0) {
                            discount = grandTotal * (v.getDiscountPercent() / 100.0);
                        } else if (v.getDiscountAmount() > 0) {
                            discount = v.getDiscountAmount();
                        }

                        // Chống âm tiền
                        if (discount > grandTotal)
                            discount = grandTotal;

                        finalTotal = grandTotal - discount; // Chốt số tiền cuối cùng!
                    } else {
                        appliedVoucherId = 0; // Đơn không đủ đk -> Hủy mã
                    }
                } else {
                    appliedVoucherId = 0; // Mã lậu/đã dùng -> Hủy mã
                }
            }
            // ===============================================================
            // F-POINT (CHỈ ÁP DỤNG KHI THANH TOÁN VNPAY)
            // ===============================================================
            double fpointDiscount = 0;
            
            // 1. Ép xóa khoảng trắng và viết hoa chữ VNPAY để kiểm tra chắc chắn 100%
            if (paymentMethod != null && "VNPAY".equals(paymentMethod.trim().toUpperCase())) {
                fpointDiscount = grandTotal * user.getDiscountRate(); 
            }

            // 2. Nếu có giảm giá F-Point thì mới cộng dồn vào tổng tiền giảm
            if (fpointDiscount > 0) {
                discount += fpointDiscount; 

                // Chống âm tiền lần 2 (nếu tổng giảm của Voucher + F-Point lớn hơn cả tiền gốc)
                if (discount > grandTotal) {
                    discount = grandTotal;
                }
            }
            
            // 3. Cập nhật lại số tiền cuối cùng khách phải trả
            finalTotal = grandTotal - discount; 
            // ===============================================================
            // ===============================================================

            // ================= RẼ NHÁNH PHƯƠNG THỨC THANH TOÁN =================
            if ("COD".equals(paymentMethod)) {
                int orderStatus = 1;
                int totalQuantity = 0;
                for (CartItem item : checkoutCart) {
                    totalQuantity += item.getQuantity();
                }

                if (totalQuantity <= 10 && finalTotal <= 2000000) { // Đã sửa thành finalTotal
                    orderStatus = 2;
                }

                OrderDAO dao = new OrderDAO();
                // [SỬA]: Truyền finalTotal thay vì grandTotal vào Database
                dao.createOrder(user, checkoutCart, receiverName, shippingAddress, phone, finalTotal, paymentMethod,
                        orderStatus, appliedVoucherId, BigDecimal.valueOf(discount));

                // [MỚI]: Xé vé Voucher nếu có xài
                if (appliedVoucherId > 0) {
                    VoucherDAO vDao = new VoucherDAO();
                    vDao.markVoucherAsUsed(user.getId(), appliedVoucherId);
                }
                // (Đoạn code xóa giỏ hàng bên dưới giữ nguyên) ...
                if (mainCart != null) {
                    for (CartItem purchasedItem : checkoutCart) {
                        mainCart.removeIf(item -> item.getBook().getId() == purchasedItem.getBook().getId());
                    }
                }
                session.setAttribute("cart", mainCart);
                session.removeAttribute("checkoutCart");
                session.removeAttribute("grandTotal");

                session.setAttribute("successMsg", "Đặt hàng thành công!");
                resp.sendRedirect(req.getContextPath() + "/home");

            } else if (paymentMethod != null && "VNPAY".equals(paymentMethod.trim().toUpperCase())) {
                String orderId = "ORDER_" + System.currentTimeMillis();
                // [SỬA]: Gửi số tiền ĐÃ TRỪ VOUCHER sang VNPAY
                long amount = (long) finalTotal;
                String orderInfo = "ThanhToanDonHang_" + orderId;
                String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                        + req.getContextPath();
                String returnUrl = baseUrl + "/vnpay-return";

                session.setAttribute("pending_checkoutCart", checkoutCart);
                session.setAttribute("pending_receiverName", receiverName);
                session.setAttribute("pending_shippingAddress", shippingAddress);
                session.setAttribute("pending_phone", phone);
                // [SỬA]: Lưu finalTotal thay vì tiền gốc
                session.setAttribute("pending_grandTotal", finalTotal- fpointDiscount);
                session.setAttribute("pending_paymentMethod", paymentMethod);
                session.setAttribute("pending_discount", discount);

                // [MỚI]: Nhớ lưu lại ID voucher để trang vnpay-return xé vé sau khi quẹt thẻ
                // thành công
                session.setAttribute("pending_voucherId", appliedVoucherId);

                BookDAO bookDAO = new BookDAO();
                bookDAO.updateStockForCheckout(checkoutCart, false);

                String vnpayUrl = com.group2.bookstore.util.VNPayService.createPaymentUrl(orderId, amount, orderInfo,
                        returnUrl);
                resp.sendRedirect(vnpayUrl);
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Hệ thống đang bận, vui lòng thử lại sau!");
            resp.sendRedirect(req.getContextPath() + "/checkout");
        }

    }
}