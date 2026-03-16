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
                                        <c:forEach items="${listTickets}" var="ticket">
                                            <tr>
                                                <td class="fw-bold">
                                                    <span
                                                        class="badge bg-light text-secondary border border-secondary-subtle font-monospace px-2 py-1">
                                                        TK-
                                                        <fmt:formatNumber value="${ticket.ticketId}" pattern="00000" />
                                                    </span>
                                                </td>
                                                <td>${ticket.userId}</td>
                                                <td><span class="badge bg-secondary">${ticket.issueType}</span></td>
                                                <td class="fw-bold"
                                                    style="max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                                    ${ticket.ticketSubject}
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${ticket.createdAt}"
                                                        pattern="dd/MM/yyyy HH:mm" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${ticket.status == 'Pending'}">
                                                            <span class="badge bg-warning text-dark"><i
                                                                    class="fa-regular fa-clock me-1"></i>Chờ xử
                                                                lý</span>
                                                        </c:when>
                                                        <c:when test="${ticket.status == 'Processing'}">
                                                            <span class="badge bg-primary"><i
                                                                    class="fa-solid fa-gear fa-spin me-1"></i>Đang xử
                                                                lý</span>
                                                        </c:when>
                                                        <c:when test="${ticket.status == 'Resolved'}">
                                                            <span class="badge bg-success"><i
                                                                    class="fa-solid fa-check me-1"></i>Đã giải
                                                                quyết</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <button type="button" class="btn btn-sm btn-outline-danger fw-bold"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#replyModal${ticket.ticketId}">
                                                        Xử lý / Trả lời
                                                    </button>
                                                </td>
                                            </tr>

                                            <div class="modal fade" id="replyModal${ticket.ticketId}" tabindex="-1"
                                                aria-hidden="true">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header bg-danger text-white">
                                                            <h5 class="modal-title">
                                                                <i class="fa-solid fa-reply me-2"></i>Phản hồi Ticket
                                                                <span class="text-warning">TK-
                                                                    <fmt:formatNumber value="${ticket.ticketId}"
                                                                        pattern="00000" />
                                                                </span>
                                                            </h5>
                                                            <button type="button" class="btn-close btn-close-white"
                                                                data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>

                                                        <form action="${pageContext.request.contextPath}/staff/tickets"
                                                            method="POST">
                                                            <div class="modal-body">
                                                                <input type="hidden" name="ticketId"
                                                                    value="${ticket.ticketId}">
                                                                <input type="hidden" name="userId"
                                                                    value="${ticket.userId}">

                                                                <div class="mb-3 p-3 bg-light rounded border">
                                                                    <label class="fw-bold text-muted small mb-1">Khách
                                                                        hàng viết:</label>
                                                                    <p class="mb-0 text-dark">${ticket.ticketMessage}
                                                                    </p>
                                                                </div>

                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold">Set Trạng thái
                                                                        mới:</label>
                                                                    <select name="status"
                                                                        class="form-select border-danger">
                                                                        <option value="Pending"
                                                                            ${ticket.status=='Pending' ? 'selected' : ''
                                                                            }>⏳ Chờ xử lý (Pending)</option>
                                                                        <option value="Processing"
                                                                            ${ticket.status=='Processing' ? 'selected'
                                                                            : '' }>⚙️ Đang xử lý (Processing)</option>
                                                                        <option value="Resolved"
                                                                            ${ticket.status=='Resolved' ? 'selected'
                                                                            : '' }>✅ Đã giải quyết (Resolved)</option>
                                                                    </select>
                                                                </div>

                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold">Lời nhắn phản hồi
                                                                        (Sẽ gửi thông báo cho User):</label>
                                                                    <textarea name="adminReply" class="form-control"
                                                                        rows="5"
                                                                        placeholder="Chào bạn, hệ thống đã ghi nhận khiếu nại và tiến hành..."
                                                                        required>${ticket.adminReply}</textarea>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer bg-light">
                                                                <button type="button" class="btn btn-secondary"
                                                                    data-bs-dismiss="modal">Đóng</button>
                                                                <button type="submit" class="btn btn-danger"><i
                                                                        class="fa-solid fa-paper-plane me-2"></i>Lưu &
                                                                    Bắn thông báo</button>
                                                            </div>
                                                        </form>

                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>

                                        <c:if test="${empty listTickets}">
                                            <tr>
                                                <td colspan="7" class="text-center text-muted py-4">Chưa có khiếu nại
                                                    nào trong hệ thống.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>