<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý Khiếu Nại - BookStore</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
            </head>

            <body style="background-color: #f4f6f9;">
                <jsp:include page="../component/header.jsp" />

                <div class="container-fluid py-4 px-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold text-danger mb-0"><i class="fa-solid fa-headset me-2"></i>Quản lý Khiếu nại &
                            Hỗ trợ</h2>
                        <a href="${pageContext.request.contextPath}/staff-dashboard" class="btn btn-outline-secondary">
                            <i class="fa-solid fa-arrow-left me-1"></i> Về Dashboard
                        </a>
                    </div>

                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show fw-bold" role="alert">
                            <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>

                    <ul class="nav nav-tabs mb-4" id="staffTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active fw-bold text-danger" id="ticket-tab" data-bs-toggle="tab"
                                data-bs-target="#ticket-pane" type="button" role="tab">
                                <i class="fa-solid fa-comments me-1"></i> Quản lý Khiếu nại
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link fw-bold text-warning" id="return-tab" data-bs-toggle="tab"
                                data-bs-target="#return-pane" type="button" role="tab">
                                <i class="fa-solid fa-box-open me-1"></i> Duyệt Yêu cầu Trả hàng
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="staffTabContent">

                        <div class="tab-pane fade show active" id="ticket-pane" role="tabpanel" tabindex="0">
                            <div class="card shadow-sm border-0">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="table-light">
                                                <tr class="text-uppercase text-muted" style="font-size: 13px;">
                                                    <th>Mã Ticket</th>
                                                    <th>User ID</th>
                                                    <th>Vấn đề</th>
                                                    <th>Tiêu đề</th>
                                                    <th>Ngày tạo</th>
                                                    <th>Trạng thái</th>
                                                    <th class="text-end">Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${listTickets}" var="ticket"> </c:forEach>
                                                <c:if test="${empty listTickets}">
                                                    <tr>
                                                        <td colspan="7" class="text-center text-muted py-4">Chưa có
                                                            khiếu nại nào trong hệ thống.</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="return-pane" role="tabpanel" tabindex="0">
                            <div class="card shadow-sm border-0">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="table-light">
                                                <tr class="text-uppercase text-muted" style="font-size: 13px;">
                                                    <th>Mã Đơn Hàng</th>
                                                    <th>User ID</th>
                                                    <th>Ngày Yêu Cầu</th>
                                                    <th>Tổng Tiền</th>
                                                    <th>Trạng thái</th>
                                                    <th class="text-end">Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${listReturnOrders}" var="order">
                                                    <tr>
                                                        <td class="fw-bold"><span
                                                                class="badge bg-light text-secondary border border-secondary-subtle font-monospace px-2 py-1">OD-${order.id}</span>
                                                        </td>
                                                        <td>${order.userId}</td>
                                                        <td>
                                                            <fmt:formatDate value="${order.orderDate}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td class="text-danger fw-bold">
                                                            <fmt:formatNumber value="${order.totalAmount}"
                                                                type="currency" currencySymbol="₫" />
                                                        </td>
                                                        <td><span class="badge bg-warning text-dark"><i
                                                                    class="fa-solid fa-hourglass-half me-1"></i>Chờ
                                                                duyệt trả hàng</span></td>
                                                        <td class="text-end">
                                                            <form
                                                                action="${pageContext.request.contextPath}/staff/tickets"
                                                                method="POST" style="margin: 0;">
                                                                <input type="hidden" name="action"
                                                                    value="approve_return">
                                                                <input type="hidden" name="orderId" value="${order.id}">
                                                                <input type="hidden" name="userId"
                                                                    value="${order.userId}">

                                                                <button type="submit"
                                                                    class="btn btn-sm btn-success fw-bold"
                                                                    onclick="return confirm('Xác nhận hoàn tiền và chuyển trạng thái đơn hàng #${order.id} thành Đã Hoàn Tiền?');">
                                                                    <i class="fa-solid fa-check me-1"></i> Chấp nhận &
                                                                    Hoàn tiền
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty listReturnOrders}">
                                                    <tr>
                                                        <td colspan="6" class="text-center text-muted py-4">Không có yêu
                                                            cầu trả hàng nào cần duyệt.</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>