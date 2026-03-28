<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý Tích Điểm (F-Point) - BookStore</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
                <style>
                    :root {
                        --bg-primary: #f4f6f9;
                        --bg-card: #ffffff;
                        --text-default: #212529;
                        --border-default: #ced4da;
                    }

                    body {
                        background-color: var(--bg-primary) !important;
                        color: var(--text-default) !important;
                    }

                    .bg-dark {
                        background-color: var(--bg-card) !important;
                        color: var(--text-default) !important;
                    }

                    .text-light {
                        color: var(--text-default) !important;
                    }

                    .border-secondary {
                        border-color: var(--border-default) !important;
                    }

                    .card,
                    .table,
                    .form-control,
                    .form-select,
                    .btn {
                        background-color: var(--bg-card) !important;
                        color: var(--text-default) !important;
                        border-color: var(--border-default) !important;
                    }

                    .btn-light,
                    .btn-outline-secondary,
                    .btn-dark {
                        background-color: #ffffff !important;
                        color: #9aa8b5 !important;
                        border-color: var(--border-default) !important;
                    }
                </style>
            </head>

            <body>
                
                <div class="border-start border-2 border-secondary ps-4">
                    <div class="d-flex align-items-center gap-4">
                        <a href="${pageContext.request.contextPath}/staff-dashboard"
                            class="btn btn-danger rounded-pill px-4 shadow-sm" style="transition: 0.3s;">
                            <i class="fa-solid fa-chart-line me-2"></i> Về Dashboard
                        </a>
                    </div>
                    <div class="border-start border-2 border-secondary ps-4">
                        <h2 class="fw-bold text-warning mb-1"><i class="fa-solid fa-coins me-2"></i>Hệ thống F-Point
                        </h2>
                        <p class="text-muted mb-0 text-light">Thao tác cộng/trừ điểm thưởng cho khách hàng</p>
                    </div>
                </div>

                <div class="row mb-5">
                    <div class="col-md-5">
                        <div class="card shadow border-secondary bg-dark text-light">
                            <div class="card-header bg-secondary text-white fw-bold py-3 border-0">
                                <i class="fa-solid fa-wand-magic-sparkles me-2"></i> Lệnh Thực Thi Điểm
                            </div>
                            <div class="card-body p-4">
                                <c:if test="${not empty sessionScope.successMessage}">
                                    <div class="alert alert-success alert-dismissible fade show text-dark fw-bold"
                                        role="alert">
                                        <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                    <c:remove var="successMessage" scope="session" />
                                </c:if>

                                <c:if test="${not empty sessionScope.errorMessage}">
                                    <div class="alert alert-danger alert-dismissible fade show text-dark fw-bold"
                                        role="alert">
                                        <i class="fa-solid fa-triangle-exclamation me-2"></i>
                                        ${sessionScope.errorMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                    </div>
                                    <c:remove var="errorMessage" scope="session" />
                                </c:if>
                                <form action="${pageContext.request.contextPath}/staff/fpoint" method="post">
                                    <div class="mb-3">
                                        <label class="form-label text-muted">ID Khách hàng / Email:</label>
                                        <input type="text" name="userInfo"
                                            class="form-control bg-dark text-light border-secondary"
                                            placeholder="Nhập ID hoặc Email..." required>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-6">
                                            <label class="form-label text-muted">Thao tác:</label>
                                            <select name="actionType"
                                                class="form-select bg-dark text-light border-secondary">
                                                <option value="add">🟢 Cộng điểm (+)</option>
                                                <option value="sub">🔴 Trừ điểm (-)</option>
                                            </select>
                                        </div>
                                        <div class="col-6">
                                            <label class="form-label text-muted">Số lượng:</label>
                                            <input type="number" name="amount"
                                                class="form-control bg-dark text-light border-secondary" placeholder="0"
                                                min="1" required>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label text-muted">Lý do (Ghi chú hệ thống):</label>
                                        <textarea name="reason" class="form-control bg-dark text-light border-secondary"
                                            rows="2" placeholder="VD: Tặng điểm sinh nhật, đền bù lỗi..."></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-warning w-100 fw-bold mb-2 text-dark"><i
                                            class="fa-solid fa-check me-2"></i> Xác nhận thực thi</button>
                                    <button type="reset" class="btn btn-outline-secondary w-100 text-light">Nhập
                                        lại</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-7">
                        <div class="card shadow border-secondary bg-dark text-light h-100">
                            <div
                                class="card-header bg-secondary text-white fw-bold py-3 border-0 d-flex justify-content-between">
                                <span><i class="fa-solid fa-clock-rotate-left me-2"></i> Lịch sử biến động</span>
                                <a href="${pageContext.request.contextPath}/staff/fpoint?action=export&startDate=${param.startDate}&endDate=${param.endDate}&type=${param.type}"
                                    class="btn btn-sm btn-light text-dark shadow-sm">
                                    <i class="fa-solid fa-file-csv text-success"></i> Tải Log CSV
                                </a>
                            </div>
                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/staff/fpoint" method="get">
                                    <div class="row g-2 mb-4">
                                        <div class="col-md-4">
                                            <input type="date" name="startDate" value="${param.startDate}"
                                                class="form-control bg-dark text-light border-secondary form-control-sm">
                                        </div>
                                        <div class="col-md-4">
                                            <input type="date" name="endDate" value="${param.endDate}"
                                                class="form-control bg-dark text-light border-secondary form-control-sm">
                                        </div>
                                        <div class="col-md-3">
                                            <select name="type"
                                                class="form-select bg-dark text-light border-secondary form-select-sm">
                                                <option value="all" ${param.type=='all' || empty param.type ? 'selected'
                                                    : '' }>Tất cả loại</option>
                                                <option value="add" ${param.type=='add' ? 'selected' : '' }>Chỉ cộng
                                                </option>
                                                <option value="sub" ${param.type=='sub' ? 'selected' : '' }>Chỉ trừ
                                                </option>
                                            </select>
                                        </div>
                                        <div class="col-md-1">
                                            <button type="submit" class="btn btn-sm btn-danger w-100"><i
                                                    class="fa-solid fa-filter"></i></button>
                                        </div>
                                    </div>
                                </form>

                                <div class="table-responsive">
                                    <table class="table table-hover align-middle" style="font-size: 14px;">
                                        <thead class="table-secondary">
                                            <tr class="text-muted text-uppercase">
                                                <th>Thời gian</th>
                                                <th>Khách hàng</th>
                                                <th>Biến động</th>
                                                <th>Lý do</th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <c:forEach items="${historyLogs}" var="log">
                                                <tr>
                                                    <td>
                                                        <fmt:formatDate value="${log.createdAt}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                    <td>${log.customerInfo}</td>
                                                    <td
                                                        class="${log.actionType == 'add' ? 'text-success' : 'text-danger'} fw-bold">
                                                        ${log.actionType == 'add' ? '+' : '-'}
                                                        <fmt:formatNumber value="${log.amount}" pattern="#,###" />
                                                    </td>
                                                    <td>${log.reason}</td>
                                                </tr>
                                            </c:forEach>

                                            <c:if test="${empty historyLogs}">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-3">Chưa có lịch sử
                                                        biến
                                                        động nào.</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <nav aria-label="Page navigation">
                                    <ul class="pagination pagination-sm justify-content-end mt-3">
                                        <li class="page-item disabled"><a
                                                class="page-link bg-dark border-secondary text-muted" href="#">Trước</a>
                                        </li>
                                        <li class="page-item active"><a
                                                class="page-link bg-danger border-danger text-light" href="#">1</a></li>
                                        <li class="page-item"><a class="page-link bg-dark border-secondary text-light"
                                                href="#">2</a></li>
                                        <li class="page-item"><a class="page-link bg-dark border-secondary text-light"
                                                href="#">Sau</a></li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
                <jsp:include page="../component/footer.jsp" />
            </body>

            </html>