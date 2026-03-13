package com.group2.bookstore.constant;

public class OrderStatus {
    public static final int PENDING = 1;     // Chờ duyệt
    public static final int PROCESSING = 2;  // Đang xử lý (Sẵn sàng lấy hàng)
    public static final int PACKED = 3;      // Đã đóng gói xong
    public static final int SHIPPING = 4;    // Đang giao (Đã xuất kho)
    public static final int DELIVERED = 5;   // Giao thành công
    public static final int CANCELLED = 6;   // Đã hủy
}