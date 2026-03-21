<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hỗ trợ khách hàng - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <style>
        .support-wrapper { background-color: #fff; border-radius: 8px; padding: 25px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); min-height: 500px; }
        
        /* CSS cho 2 cái Tabs */
        .nav-tabs .nav-link { color: #555; font-weight: 500; border: none; border-bottom: 2px solid transparent; }
        .nav-tabs .nav-link.active { color: #C92127; background-color: transparent; border-color: #C92127; }
        .nav-tabs .nav-link:hover { border-color: #eee; }
        
        /* CSS cho thẻ Ticket */
        .ticket-card { border: 1px solid #eee; border-radius: 8px; margin-bottom: 15px; padding: 15px; background: #fafafa; transition: 0.3s; }
        .ticket-card:hover { box-shadow: 0 4px 10px rgba(0,0,0,0.05); background: #fff; }
        .ticket-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; border-bottom: 1px dashed #ddd; padding-bottom: 10px; }
        
        /* Màu sắc Trạng thái */
        .status-pending { color: #f39c12; background: #fdf3e8; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .status-replied { color: #00b14f; background: #e6f8ec; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .status-closed { color: #6c757d; background: #f8f9fa; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        
        /* Hộp tin nhắn phản hồi của Admin */
        .admin-reply-box { background: #f1f8ff; border-left: 4px solid #2f80ed; padding: 12px; border-radius: 4px; margin-top: 15px; font-size: 14px; }
    </style>
</head>
<body style="background-color: #f5f5f5;">

    <jsp:include page="component/header.jsp" />

    <div class="container profile-container py-4">
        <div class="row">
            <div class="col-md-3">
                <jsp:include page="component/sidebar.jsp" />
            </div>

            <div class="col-md-9">
                <div class="support-wrapper">
                    <h4 class="mb-4 fw-bold" style="color: #333;"><i class="fa-solid fa-headset me-2" style="color: #C92127;"></i> Trung tâm Hỗ trợ</h4>
                    
                    <c:if test="${not empty sessionScope.successMsg}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fa-solid fa-circle-check me-2"></i>${sessionScope.successMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="successMsg" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMsg}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fa-solid fa-circle-xmark me-2"></i>${sessionScope.errorMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="errorMsg" scope="session" />
                    </c:if>

                    <ul class="nav nav-tabs mb-4" id="myTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="history-tab" data-bs-toggle="tab" data-bs-target="#history" type="button" role="tab">Lịch sử Yêu cầu</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="create-tab" data-bs-toggle="tab" data-bs-target="#create" type="button" role="tab">Gửi Yêu cầu Mới</button>
                        </li>
                    </ul>

                    <div class="tab-content" id="myTabContent">
                        
                        <div class="tab-pane fade show active" id="history" role="tabpanel">
                            <c:choose>
                                <c:when test="${empty listTickets}">
                                    <div class="text-center py-5">
                                        <i class="fa-regular fa-comments text-muted" style="font-size: 50px; margin-bottom: 15px;"></i>
                                        <h6 class="text-muted">Bạn chưa gửi yêu cầu hỗ trợ nào.</h6>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="t" items="${listTickets}">
                                        <div class="ticket-card">
                                            <div class="ticket-header">
                                                <div>
                                                    <span class="badge bg-secondary me-2">${t.issueType}</span>
                                                    <span class="text-muted" style="font-size: 13px;"><i class="fa-regular fa-clock me-1"></i>${t.createdAt}</span>
                                                </div>
                                                <div>
                                                    <c:if test="${t.status == 'Pending'}"><span class="status-pending"><i class="fa-solid fa-hourglass-half me-1"></i> Đang chờ xử lý</span></c:if>
                                                    <c:if test="${t.status == 'Replied'}"><span class="status-replied"><i class="fa-solid fa-check-double me-1"></i> Đã phản hồi</span></c:if>
                                                    <c:if test="${t.status == 'Closed'}"><span class="status-closed"><i class="fa-solid fa-lock me-1"></i> Đã đóng</span></c:if>
                                                </div>
                                            </div>
                                            
                                            <h6 class="fw-bold mb-2">${t.ticketSubject}</h6>
                                            <p class="text-muted mb-0" style="font-size: 14px; line-height: 1.5;">${t.ticketMessage}</p>
                                            
                                            <%-- Chỉ hiện hộp Admin Reply nếu Admin đã trả lời --%>
                                            <c:if test="${not empty t.adminReply}">
                                                <div class="admin-reply-box">
                                                    <strong><i class="fa-solid fa-user-shield text-primary me-1"></i> Phản hồi từ Admin:</strong>
                                                    <div class="mt-1">${t.adminReply}</div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="tab-pane fade" id="create" role="tabpanel">
                            <form action="${pageContext.request.contextPath}/support" method="POST">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label fw-bold">Vấn đề bạn đang gặp phải <span class="text-danger">*</span></label>
                                        <select class="form-select" name="issueType" required>
                                            <option value="" disabled selected>-- Chọn loại vấn đề --</option>
                                            <option value="Lỗi website / Ứng dụng">Lỗi website / Ứng dụng</option>
                                            <option value="Sản phẩm lỗi / Thiếu hàng">Sản phẩm lỗi / Thiếu hàng</option>
                                            <option value="Vấn đề thanh toán / Hoàn tiền">Vấn đề thanh toán / Hoàn tiền</option>
                                            <option value="Chậm giao hàng">Chậm giao hàng</option>
                                            <option value="Tư vấn / Hỏi đáp khác">Tư vấn / Hỏi đáp khác</option>
                                        </select>
                                    </div>
                                    <div class="col-md-12 mb-3">
                                        <label class="form-label fw-bold">Tiêu đề yêu cầu <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="ticketSubject" placeholder="Ví dụ: Sách bị rách bìa khi nhận hàng..." maxlength="100" required>
                                    </div>
                                    <div class="col-md-12 mb-3">
                                        <label class="form-label fw-bold">Chi tiết vấn đề <span class="text-danger">*</span></label>
                                        <textarea class="form-control" name="ticketMessage" rows="5" placeholder="Vui lòng mô tả chi tiết vấn đề bạn đang gặp phải để chúng tôi có thể hỗ trợ nhanh nhất..." required></textarea>
                                    </div>
                                    <div class="col-md-12 text-end">
                                        <button type="submit" class="btn text-white fw-bold px-4" style="background-color: #C92127;">
                                            <i class="fa-regular fa-paper-plane me-2"></i>Gửi Yêu Cầu
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="component/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>