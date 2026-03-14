<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Staff Dashboard - BookStore</title>

                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/admin-dashboard-stats.css?v=2">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            </head>

            <body>

                <header class="main-header">
                    <div class="container d-flex justify-content-between align-items-center">
                        <div class="logo">
                            <a href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
                                <span style="color: #C92127; font-weight: 900; font-size: 28px;">MIND</span><span
                                    style="color: white; font-weight: 900; font-size: 28px;">BOOK</span>
                            </a>
                            <span style="color: white; margin-left: 10px; font-weight: bold; font-size: 16px;">| STAFF
                                PORTAL</span>
                        </div>

                        <div class="header-icons">
                            <a href="${pageContext.request.contextPath}/logout"
                                style="color: white; text-decoration: none;">
                                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                            </a>
                        </div>
                    </div>
                </header>

                <main class="container" style="margin-top: 30px;">

                    <h2 style="margin-bottom: 20px; color: #333;">Báo cáo ca làm việc (Hôm nay)</h2>

                    <div class="stats-container">
                        <div class="stat-card">
                            <i class="fa-solid fa-cart-shopping" style="color: #007bff;"></i>
                            <div>
                                <h2>${todayTotalOrders != null ? todayTotalOrders : '0'}</h2>
                                <p>Tổng đơn hôm nay</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <i class="fa-solid fa-clock" style="color: #ffc107;"></i>
                            <div>
                                <h2>${todayPending != null ? todayPending : '0'}</h2>
                                <p>Đơn đang chờ xử lý</p>
                            </div>
                        </div>
                        <div class="stat-card">
                            <i class="fa-solid fa-money-bill-wave" style="color: #28a745;"></i>
                            <div>
                                <h2>
                                    <c:choose>
                                        <c:when test="${not empty todayRevenue}">
                                            <fmt:formatNumber value="${todayRevenue}" type="currency"
                                                currencySymbol="đ" />
                                        </c:when>
                                        <c:otherwise>0 đ</c:otherwise>
                                    </c:choose>
                                </h2>
                                <p>Doanh thu thực tế</p>
                            </div>
                        </div>
                    </div>

                    <h2 style="margin-top: 40px; margin-bottom: 20px; color: #333;">Chức năng nghiệp vụ</h2>

                    <div class="card-grid">

                        <a href="${pageContext.request.contextPath}/vouchers-management" class="admin-card">
                            <i class="fa-solid fa-ticket" style="color: #e83e8c;"></i>
                            <h3>Quản lý Mã giảm giá</h3>
                            <p>Tạo mới, theo dõi trạng thái và quản lý các mã khuyến mãi</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/orders-management" class="admin-card">
                            <i class="fa-solid fa-list-check" style="color: #17a2b8;"></i>
                            <h3>Quản lý Đơn hàng</h3>
                            <p>Xem danh sách, duyệt đơn và cập nhật trạng thái giao hàng</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/staff/reports" class="admin-card">
                            <i class="fa-solid fa-chart-pie" style="color: #6f42c1;"></i>
                            <h3>Chi tiết Doanh thu</h3>
                            <p>Xem biểu đồ và xuất file Excel báo cáo cuối ngày</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/staff/reviews" class="admin-card">
                            <i class="fa-solid fa-comments" style="color: #fd7e14;"></i>
                            <h3>Phản hồi Khách hàng</h3>
                            <p>Xem và trả lời các đánh giá, bình luận về sách</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/staff/customers" class="admin-card">
                            <i class="fa-solid fa-users-viewfinder" style="color: #28a745;"></i>
                            <h3>Hỗ trợ Khách hàng</h3>
                            <p>Tra cứu thông tin liên hệ, lịch sử và giải quyết khiếu nại</p>
                        </a>
                        <a href="${pageContext.request.contextPath}/staff/fpoint" class="admin-card">
                            <i class="fa-solid fa-coins" style="color: #ffc107;"></i>
                            <h3>Quản lý F-Point</h3>
                            <p>Thao tác cộng/trừ điểm thưởng và xem lịch sử biến động của khách hàng</p>
                        </a>
                    </div>
                </main>

            </body>

            </html>