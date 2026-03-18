package com.group2.bookstore.constant;

public class OrderStatus {
    public static final int PENDING = 1;     // Chờ duyệt
    public static final int PROCESSING = 2;  // Đang xử lý (Sẵn sàng lấy hàng)
    public static final int PACKED = 3;      // Đã đóng gói xong
    public static final int SHIPPING = 4;    // Đang giao (Đã xuất kho)
    public static final int DELIVERED = 5;   // Giao thành công
    public static final int CANCELLED = 6;   // Đã hủy
    public static final int RETURN_REQUESTED = 7;    // Khách gửi yêu cầu
    public static final int RETURN_APPROVED = 8;     // Admin/Manager đã duyệt
    public static final int RETURN_RECEIVED = 9;     // Kho đã nhận được gói hàng (bắt đầu kiểm)
    public static final int RETURN_COMPLETED = 10;   // Đã kiểm hàng & nhập kho xong (Cộng tồn kho)
}