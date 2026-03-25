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
            <h2 class="fw-bold text-danger mb-0"><i class="fa-solid fa-headset me-2"></i>Quản lý Khiếu nại & Hỗ trợ</h2>
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

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show fw-bold" role="alert">
                <i class="fa-solid fa-circle-xmark me-2"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <ul class="nav nav-tabs mb-4" id="staffTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active fw-bold text-danger" id="ticket-tab" data-bs-toggle="tab" data-bs-target="#ticket-pane" type="button" role="tab">
                    <i class="fa-solid fa-comments me-1"></i> Quản lý Khiếu nại
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link fw-bold text-warning" id="return-tab" data-bs-toggle="tab" data-bs-target="#return-pane" type="button" role="tab">
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
                                    <c:forEach items="${listTickets}" var="ticket">
                                        <tr>
                                            <td class="fw-bold">
                                                <span class="badge bg-light text-secondary border border-secondary-subtle font-monospace px-2 py-1">
                                                    TK-<fmt:formatNumber value="${ticket.ticketId}" pattern="00000" />
                                                </span>
                                            </td>
                                            <td>${ticket.userId}</td>
                                            <td><span class="badge bg-info text-dark">${ticket.issueType}</span></td>
                                            <td style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${ticket.ticketSubject}">
                                                ${ticket.ticketSubject}
                                            </td>
                                            <td><fmt:formatDate value="${ticket.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${ticket.status == 'Pending'}">
                                                        <span class="badge bg-warning text-dark"><i class="fa-solid fa-hourglass-half me-1"></i>Chờ xử lý</span>
                                                    </c:when>
                                                    <c:when test="${ticket.status == 'Replied'}">
                                                        <span class="badge bg-success"><i class="fa-solid fa-check-double me-1"></i>Đã phản hồi</span>
                                                    </c:when>
                                                    <c:when test="${ticket.status == 'Closed'}">
                                                        <span class="badge bg-secondary"><i class="fa-solid fa-lock me-1"></i>Đã đóng</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <button type="button" class="btn btn-sm btn-primary fw-bold" data-bs-toggle="modal" data-bs-target="#replyModal${ticket.ticketId}">
                                                    Xử lý
                                                </button>
                                            </td>
                                        </tr>

                                        <div class="modal fade" id="replyModal${ticket.ticketId}" tabindex="-1" aria-hidden="true" style="text-align: left;">
                                            <div class="modal-dialog modal-lg">
                                                <div class="modal-content">
                                                    <div class="modal-header bg-danger text-white">
                                                        <h5 class="modal-title">
                                                            <i class="fa-solid fa-reply me-2"></i>Phản hồi Ticket 
                                                            <span class="text-warning">TK-<fmt:formatNumber value="${ticket.ticketId}" pattern="00000" /></span>
                                                        </h5>
                                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <form action="${pageContext.request.contextPath}/staff/tickets" method="POST">
                                                        <div class="modal-body">
                                                            <input type="hidden" name="action" value="reply_ticket">
                                                            <input type="hidden" name="ticketId" value="${ticket.ticketId}">
                                                            <input type="hidden" name="userId" value="${ticket.userId}">

                                                            <div class="mb-3 p-3 bg-light rounded border">
                                                                <label class="fw-bold text-danger small mb-1">Phân loại: ${ticket.issueType}</label>
                                                                <p class="mb-0 text-dark fw-bold">Tiêu đề: ${ticket.ticketSubject}</p>
                                                                <p class="mb-0 text-muted mt-2">Nội dung chi tiết: <br> ${ticket.ticketMessage}</p>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label class="form-label fw-bold">Cập nhật trạng thái:</label>
                                                                <select name="status" class="form-select border-danger">
                                                                    <option value="Pending" ${ticket.status=='Pending' ? 'selected' : ''}>⏳ Chờ xử lý (Pending)</option>
                                                                    <option value="Replied" ${ticket.status=='Replied' ? 'selected' : ''}>✅ Đã phản hồi (Replied)</option>
                                                                    <option value="Closed" ${ticket.status=='Closed' ? 'selected' : ''}>🔒 Đóng (Closed)</option>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label fw-bold">Lời nhắn phản hồi (Sẽ gửi thông báo cho khách):</label>
                                                                <textarea name="adminReply" class="form-control" rows="4" placeholder="Nhập nội dung bạn muốn phản hồi cho khách..." required>${ticket.adminReply}</textarea>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer bg-light">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                            <button type="submit" class="btn btn-danger">
                                                                <i class="fa-solid fa-paper-plane me-2"></i>Lưu & Bắn thông báo
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty listTickets}">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-4">Chưa có khiếu nại nào trong hệ thống.</td>
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
                                            <td>
                                                <div class="fw-bold text-secondary mb-1">OD-${order.id}</div>
                                                <button type="button" class="btn btn-sm btn-outline-primary" 
                                                        style="padding: 2px 8px; font-size: 12px; border-radius: 4px;"
                                                        data-bs-toggle="modal" data-bs-target="#staffDetailModal_${order.id}">
                                                    <i class="fa-solid fa-eye me-1"></i>Xem chi tiết
                                                </button>
                                            </td>
                                            <td>${order.userId}</td>
                                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                            <td class="text-danger fw-bold">
                                                <fmt:formatNumber value="${refundMap[order.id]}" type="currency" currencySymbol="₫"/><br>
                                                <small class="text-muted fw-normal" style="font-size: 11px;">(Sau chiết khấu)</small>
                                            </td>
                                            <td><span class="badge bg-warning text-dark"><i class="fa-solid fa-hourglass-half me-1"></i>Chờ duyệt trả hàng</span></td>
                                            
                                            <td class="text-end">
                                                <form action="${pageContext.request.contextPath}/staff/tickets" method="POST" class="d-flex align-items-center justify-content-end gap-2" style="margin: 0;">
                                                    <input type="hidden" name="action" value="process_return">
                                                    <input type="hidden" name="orderId" value="${order.id}">
                                                    <input type="hidden" name="userId" value="${order.userId}">

                                                    <select name="decision" class="form-select form-select-sm w-auto" required style="cursor: pointer; min-width: 150px;">
                                                        <option value="" disabled selected>-- Chọn thao tác --</option>
                                                        <option value="accept" class="text-success fw-bold">Chấp nhận yêu cầu</option>
                                                        <option value="reject" class="text-danger fw-bold">Không chấp nhận</option>
                                                    </select>

                                                    <button type="submit" class="btn btn-sm btn-primary fw-bold" onclick="return confirm('Xác nhận lưu quyết định xử lý cho đơn hàng #${order.id}?');">
                                                        Lưu
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                        <div class="modal fade" id="staffDetailModal_${order.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered modal-lg">
                                                <div class="modal-content">
                                                    <div class="modal-header bg-light">
                                                        <h5 class="modal-title fw-bold">Chi tiết trả hàng - Đơn OD-${order.id}</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body p-4" style="max-height: 70vh; overflow-y: auto;">
                                                        
                                                        <h6 class="fw-bold mb-3"><i class="fa-solid fa-box-open text-warning me-2"></i>Sản phẩm yêu cầu trả:</h6>
                                                        
                                                        <%-- Lặp qua các sách bị trả --%>
                                                        <c:forEach var="req" items="${returnDetailsMap[order.id]}">
                                                            <div class="border rounded p-3 mb-3 bg-white shadow-sm" style="border-left: 4px solid #e67e22 !important;">
                                                                <div class="fw-bold text-dark" style="font-size: 15px;">
                                                                    ${req.bookTitle} <span class="badge bg-danger ms-2">SL: ${req.quantity}</span>
                                                                </div>
                                                                <div class="text-muted mt-2" style="font-size: 14px;">
                                                                    <strong>Lý do của khách:</strong> ${req.customerReason}
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                        <%-- [MỚI THÊM] KHU VỰC TỔNG KẾT TIỀN HOÀN LẠI --%>
                                                        <div class="alert alert-warning mt-3 mb-4 d-flex justify-content-between align-items-center p-3 border-warning" style="background-color: #fff9e6;">
                                                            <div>
                                                                <h6 class="fw-bold mb-1 text-dark"><i class="fa-solid fa-coins text-warning me-2"></i>Tổng tiền hoàn lại:</h6>
                                                                <small class="text-muted">(Đã trừ tỷ lệ Voucher / Khuyến mãi nếu có)</small>
                                                            </div>
                                                            <h4 class="text-danger fw-bold mb-0">
                                                                <fmt:formatNumber value="${refundMap[order.id]}" type="currency" currencySymbol="₫"/>
                                                            </h4>
                                                        </div>
                                                        
                                                        <%-- Lấy dữ liệu của phần tử đầu tiên để lấy ảnh chung (Code cũ giữ nguyên) --%>
                                                        <c:set var="firstReq" value="${returnDetailsMap[order.id][0]}" />
                                                        <%-- Lấy dữ liệu của phần tử đầu tiên (index = 0) để lấy ảnh chung --%>
                                                        <c:set var="firstReq" value="${returnDetailsMap[order.id][0]}" />
                                                        
                                                        <c:if test="${not empty firstReq.proofImage}">
                                                            <hr class="my-4">
                                                            <h6 class="fw-bold mb-3"><i class="fa-solid fa-camera text-info me-2"></i>Minh chứng đính kèm:</h6>
                                                            
                                                            <div class="text-center bg-light p-3 rounded border">
                                                                <c:choose>
                                                                    <c:when test="${firstReq.imageMimeType != null && firstReq.imageMimeType.startsWith('video/')}">
                                                                        <video src="${firstReq.proofImage}" controls style="max-width: 100%; max-height: 400px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);"></video>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${firstReq.proofImage}" style="max-width: 100%; max-height: 400px; border-radius: 8px; object-fit: contain; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </c:if>
                                                        
                                                    </div>
                                                    <div class="modal-footer border-top-0">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    
                                    <c:if test="${empty listReturnOrders}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">Không có yêu cầu trả hàng nào cần duyệt.</td>
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