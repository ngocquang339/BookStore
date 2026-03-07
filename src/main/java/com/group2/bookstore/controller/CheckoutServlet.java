package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.AddressDAO;
import com.group2.bookstore.model.Address;
import com.group2.bookstore.model.CartItem;
import com.group2.bookstore.model.User;
import com.group2.bookstore.model.Book;
import java.io.IOException;
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
        BookDAO dao = new BookDAO();
        
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

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

            for (String idStr : selectedItems) {
                try {
                    int bookId = Integer.parseInt(idStr);
                    Book book = dao.getBookById(bookId);
                    if(book.getStockQuantity() < 1){
                        flag = 1;
                        bId = book.getId();
                        break;
                    }
                    for (CartItem item : cart) {
                        if (item.getBook().getId() == bookId) {
                            checkoutCart.add(item);
                            checkoutTotal += (item.getQuantity() * item.getBook().getPrice());
                            break;
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if(flag == 1){
                session.setAttribute("cartError", "Sản phẩm " + dao.getBookById(bId).getTitle() + " đã hết hàng!");
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            // LƯU VÀO SESSION ĐỂ DÙNG DẦN
            session.setAttribute("checkoutCart", checkoutCart);
            session.setAttribute("grandTotal", checkoutTotal);

        } else {
            // === TRƯỜNG HỢP B: BỊ ĐÁ VỀ SAU KHI XÓA/SỬA ĐỊA CHỈ HOẶC F5 TRANG ===
            // Lấy lại giỏ hàng đã lưu trong Session ra
            List<CartItem> checkoutCart = (List<CartItem>) session.getAttribute("checkoutCart");
            
            // Nếu trong Session cũng không có nốt, lúc này mới thực sự là lỗi -> Đuổi về Cart
            if (checkoutCart == null || checkoutCart.isEmpty()) {
                session.setAttribute("cartError", "Vui lòng chọn ít nhất 1 sản phẩm để thanh toán!");
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }
            // Nếu có rồi thì bỏ qua, đi tiếp xuống dưới để load địa chỉ ra giao diện!
        }

        // 2. LOAD LẠI DANH SÁCH ĐỊA CHỈ (Dù có xóa hay sửa thì nó sẽ cập nhật mới nhất ở đây)
        AddressDAO addressDAO = new AddressDAO();
        List<Address> listAddresses = addressDAO.getAddressesByUserId(user.getId());
        req.setAttribute("listAddresses", listAddresses);
        
        // Hiển thị lỗi từ doPost nếu có
        if (session.getAttribute("errorMsg") != null) {
            req.setAttribute("errorMsg", session.getAttribute("errorMsg"));
            session.removeAttribute("errorMsg"); 
        }

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

        // 1. NHẬN PHƯƠNG THỨC THANH TOÁN VÀ ID ĐỊA CHỈ TỪ FORM (JSP MỚI)
        String paymentMethod = req.getParameter("paymentMethod");
        String selectedAddressIdStr = req.getParameter("selectedAddressId");

        // Bắt lỗi nếu người dùng cố tình không chọn địa chỉ (f12 xóa thuộc tính required)
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
            
            // ================= RẼ NHÁNH PHƯƠNG THỨC THANH TOÁN =================
            if ("COD".equals(paymentMethod)) {
                
                // === LUỒNG 1: THANH TOÁN TIỀN MẶT (Lưu Database luôn - Giữ nguyên code cũ của bạn) ===
                OrderDAO dao = new OrderDAO();
                dao.createOrder(user, checkoutCart, receiverName, shippingAddress, phone, grandTotal, paymentMethod);

                // Chỉ xóa những món đã thanh toán khỏi giỏ hàng gốc
                if (mainCart != null) {
                    for (CartItem purchasedItem : checkoutCart) {
                        mainCart.removeIf(item -> item.getBook().getId() == purchasedItem.getBook().getId());
                    }
                }

                // Cập nhật lại giỏ hàng chính, dọn dẹp biến tạm
                session.setAttribute("cart", mainCart);
                session.removeAttribute("checkoutCart");
                session.removeAttribute("grandTotal");

                req.getSession().setAttribute("successMsg", "Đặt hàng thành công!");
                resp.sendRedirect(req.getContextPath() + "/home");

            } else if ("VNPAY".equals(paymentMethod)) {
                
                // === LUỒNG 2: THANH TOÁN VNPAY (Chưa lưu DB vội, chuyển hướng sang VNPAY) ===
                
                // 1. Tạo mã đơn hàng duy nhất
                String orderId = "ORDER_" + System.currentTimeMillis();
                
                // 2. Chuyển đổi số tiền sang kiểu long (VNPAY yêu cầu)
                long amount = grandTotal.longValue(); 
                
                // 3. Thông tin hiển thị khi thanh toán (Viết không dấu)
                String orderInfo = "ThanhToanDonHang_" + orderId;
                
                // 4. Đường link để VNPAY trả khách về lại web của bạn sau khi quẹt thẻ xong
                String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
                String returnUrl = baseUrl + "/vnpay-return";

                // 5. LƯU TẠM THÔNG TIN VÀO SESSION (Để tí nữa khách quay lại còn có dữ liệu mà lưu DB)
                session.setAttribute("pending_checkoutCart", checkoutCart);
                session.setAttribute("pending_receiverName", receiverName);
                session.setAttribute("pending_shippingAddress", shippingAddress);
                session.setAttribute("pending_phone", phone);
                session.setAttribute("pending_grandTotal", grandTotal);
                session.setAttribute("pending_paymentMethod", paymentMethod);

                // 6. TẠO LINK VÀ BAY THẲNG SANG TRANG VNPAY
                String vnpayUrl = com.group2.bookstore.util.VNPayService.createPaymentUrl(orderId, amount, orderInfo, returnUrl);
                resp.sendRedirect(vnpayUrl);
                return; // Kết thúc hàm ở đây để chuyển hướng
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Hệ thống đang bận, vui lòng thử lại sau!");
            resp.sendRedirect(req.getContextPath() + "/checkout");
        }
    
    }
}