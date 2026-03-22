<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <title>Hỗ trợ Khách hàng - BookStore</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/staff/customer-detail?id=${u.id}">
                    <style>
                        :root {
                            --bg-primary: #f4f6f9;
                            --bg-secondary: #ffffff;
                            --text-primary: #222;
                            --card-bg: #fff;
                            --panel-bg: #000000;
                            --border-color: #dee2e6;
                            --brand-color: #C92127;
                        }

                        /* Luôn dùng theme sáng */
                        :root {
                            --bg-primary: #f4f6f9;
                            --bg-secondary: #ffffff;
                            --text-primary: #222;
                            --card-bg: #ffffff;
                            --panel-bg: #f8f9fa;
                            --border-color: #dee2e6;
                            --brand-color: #C92127;
                        }

                        .card,
                        .modal-content,
                        .table,
                        .table th,
                        .table td {
                            background-color: var(--card-bg) !important;
                            border-color: var(--border-color) !important;
                            color: var(--text-primary) !important;
                        }

                        .card {
                            box-shadow: 0 4px 14px rgba(31, 40, 51, 0.1);
                        }

                        .card-body,
                        .modal-body {
                            background-color: var(--panel-bg);
                        }

                        .table thead {
                            background: linear-gradient(120deg, #f1f3f7, #e9edf3);
                        }

                        input,
                        select,
                        textarea {
                            background: #fff;
                            color: #212529;
                            border-color: #ced4da;
                        }

                        .btn,
                        .btn-outline-secondary,
                        .form-select,
                        .form-control {
                            border-color: #ced4da !important;
                            color: #212529 !important;
                        }

                        body {
                            background-color: var(--bg-primary);
                            color: var(--text-primary);
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        }

                        .brand-color {
                            color: var(--brand-color);
                        }

                        .bg-brand {
                            background-color: #C92127;
                            color: white;
                        }

                        .btn-brand {
                            background-color: #C92127;
                            color: white;
                            transition: 0.3s;
                        }

                        .btn-brand:hover {
                            background-color: #a31a1f;
                            color: white;
                        }

                        .card {
                            border-radius: 12px;
                        }

                        .table th {
                            background-color: #f8f9fa;
                            color: #555;
                            font-weight: 600;
                            text-transform: uppercase;
                            font-size: 13px;
                            letter-spacing: 0.5px;
                        }

                        .avatar-circle {
                            width: 40px;
                            height: 40px;
                            background-color: #e9ecef;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-weight: bold;
                            color: #6c757d;
                        }

                        .hover-brand:hover {
                            color: #C92127 !important;
                        }

                        /* Override Bootstrap dark utility to make everything light/white */
                        .bg-dark {
                            background-color: #ffffff !important;
                            color: #212529 !important;
                        }

                        .text-light {
                            color: #212529 !important;
                        }

                        .border-secondary {
                            border-color: #ced4da !important;
                        }

                        .table thead th {
                            background-color: #f8f9fa !important;
                        }
                    </style>
                </head>

                <body>
                    <c:if test="${param.noteSaved == '1'}">
                        <div class="alert alert-success text-center m-3" role="alert">
                            Ghi chú đã được lưu và đã cập nhật vào hệ thống.
                        </div>
                    </c:if>
                    <c:if test="${not empty param.marketingResult}">
                        <div class="alert alert-info text-center m-3" role="alert">
                            <c:out value="${param.marketingResult}" />
                        </div>
                    </c:if>
                    <div class="container-fluid py-4 px-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div class="d-flex align-items-center gap-4">
                                <a href="${pageContext.request.contextPath}/staff-dashboard"
                                    class="btn btn-danger rounded-pill px-4 shadow-sm" style="transition: 0.3s;">
                                    <i class="fa-solid fa-chart-line me-2"></i> Về Dashboard
                                </a>

                                <div class="border-start border-2 border-secondary ps-4">
                                    <h2 class="fw-bold brand-color mb-1"><i class="fa-solid fa-comments me-2"></i>Quản
                                        lý khách
                                        hàng</h2>
                                    <p class="text-muted mb-0">Theo dõi và phản hồi trải nghiệm của khách hàng</p>
                                </div>
                            </div>

                            <a href="${pageContext.request.contextPath}/home"
                                class="btn btn-outline-secondary rounded-pill px-4 hover-brand">
                                <i class="fa-solid fa-arrow-left me-2"></i> Về Trang chủ
                            </a>
                        </div>

                        <div class="card shadow-sm border-0">
                            <div class="card-body p-4">
                                <form id="customerBulkForm" action="#" method="POST">

                                    <div
                                        class="row g-3 align-items-end mb-4 bg-dark p-3 rounded-3 mx-0 border border-secondary">
                                        <div class="col-md-12 mb-2">
                                            <div class="fw-bold text-danger"><i class="fa-solid fa-filter me-2"></i>Bộ
                                                lọc Khách
                                                hàng VIP:</div>
                                        </div>

                                        <div class="col-md-3">
                                            <label class="form-label text-muted small mb-1">Hạng thành viên</label>
                                            <select name="memberTier"
                                                class="form-select bg-dark text-light border-secondary shadow-none">
                                                <option value="all">-- Tất cả hạng --</option>
                                                <option value="diamond">💎 Kim Cương</option>
                                                <option value="gold">🥇 Vàng</option>
                                                <option value="silver">🥈 Bạc</option>
                                                <option value="bronze">🥉 Đồng (Mới)</option>
                                            </select>
                                        </div>

                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">F-Point (Từ):</label>
                                            <input type="number" name="minPoint" class="form-control"
                                                value="${param.minPoint}" placeholder="VD: 500">
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label fw-bold">F-Point (Đến):</label>
                                            <input type="number" name="maxPoint" class="form-control"
                                                value="${param.maxPoint}" placeholder="VD: 5000">
                                        </div>

                                        <div class="col-md-5">
                                            <label class="form-label text-muted small mb-1">Tìm kiếm</label>
                                            <div class="input-group">
                                                <input type="text" name="keyword" value="<c:out value='${keyword}' />"
                                                    class="form-control bg-dark text-light border-secondary shadow-none"
                                                    placeholder="Nhập ID, Tên, Email, SĐT...">
                                                <button type="submit" class="btn btn-danger px-4"
                                                    onclick="this.form.action='${pageContext.request.contextPath}/staff/customers'; this.form.method='GET';">Lọc</button>
                                                <a href="${pageContext.request.contextPath}/staff/customers"
                                                    class="btn btn-outline-secondary text-light px-3">Mặc định</a>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="d-flex gap-2">
                                            <button type="button" class="btn btn-sm btn-outline-info"
                                                onclick="openTagModal()">
                                                <i class="fa-solid fa-tags me-1"></i> Gắn nhãn phân loại
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-primary"
                                                onclick="openNoteModal()">
                                                <i class="fa-solid fa-clipboard-user me-1"></i> Thêm ghi chú nội bộ
                                            </button>
                                        </div>
                                        <button type="button" class="btn btn-sm btn-warning fw-bold text-dark"
                                            data-bs-toggle="modal" data-bs-target="#marketingModal">
                                            <i class="fa-solid fa-envelopes-bulk me-1"></i> Gửi Mail Marketing
                                        </button>
                                    </div>

                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead>
                                                <tr>
                                                    <th class="ps-4" style="width: 40px;">
                                                        <input class="form-check-input border-secondary" type="checkbox"
                                                            id="selectAllCus">
                                                    </th>
                                                    <th class="ps-4" style="width: 100px;">
                                                        <div class="dropdown">
                                                            <span class="dropdown-toggle text-dark" role="button"
                                                                data-bs-toggle="dropdown" aria-expanded="false"
                                                                style="cursor: pointer;">
                                                                ID
                                                            </span>
                                                            <ul class="dropdown-menu shadow border-0"
                                                                style="min-width: 180px; max-height: 300px; overflow-y: auto;">
                                                                <li><a class="dropdown-item py-2 fw-bold"
                                                                        href="${pageContext.request.contextPath}/staff/customers?sort=id_asc"><i
                                                                            class="fa-solid fa-arrow-down-1-9 me-2 text-muted"></i>ID
                                                                        Tăng dần</a></li>
                                                                <li><a class="dropdown-item py-2 fw-bold"
                                                                        href="${pageContext.request.contextPath}/staff/customers?sort=id_desc"><i
                                                                            class="fa-solid fa-arrow-down-9-1 me-2 text-muted"></i>ID
                                                                        Giảm dần</a></li>
                                                                <li>
                                                                    <hr class="dropdown-divider">
                                                                </li>
                                                                <li>
                                                                    <h6 class="dropdown-header">Chọn nhanh ID:</h6>
                                                                </li>

                                                                <c:forEach items="${listCustomers}" var="c">
                                                                    <li><a class="dropdown-item"
                                                                            href="${pageContext.request.contextPath}/staff/customers?keyword=${c.id}"><span
                                                                                class="badge bg-secondary me-2">#${c.id}</span>
                                                                            ${c.fullname}</a></li>
                                                                </c:forEach>
                                                            </ul>
                                                        </div>
                                                    </th>

                                                    <th>Khách hàng</th>
                                                    <th>Thông tin liên lạc</th>
                                                    <th class="text-center">Hạng VIP & F-Point</th>
                                                    <th class="text-center">Trạng thái</th>
                                                    <th class="text-end pe-4">Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${listCustomers}" var="u">
                                                    <tr class="customer-row"
                                                        data-href="${pageContext.request.contextPath}/staff/customer-detail?id=${u.id}"
                                                        data-customer-id="${u.id}" style="cursor:pointer;">
                                                        <td class="ps-4 align-middle">
                                                            <input
                                                                class="form-check-input border-secondary cus-checkbox"
                                                                type="checkbox" name="userIds" value="${u.id}">
                                                        </td>
                                                        <td class="ps-4 align-middle text-muted fw-bold">#${u.id}</td>

                                                        <td class="align-middle customer-cell"
                                                            data-customer-id="${u.id}">
                                                            <div class="text-decoration-none d-flex align-items-center"
                                                                style="transition: 0.2s; cursor: pointer;">

                                                                <div class="avatar-circle me-3 text-dark">
                                                                    <i class="fa-regular fa-user"></i>
                                                                </div>

                                                                <div>
                                                                    <div class="fw-bold text-dark hover-brand">
                                                                        <c:out value="${u.fullname}" />
                                                                    </div>
                                                                    <div class="text-muted" style="font-size: 13px;">@
                                                                        <c:out value="${u.username}" />
                                                                    </div>

                                                                    <c:if test="${not empty u.tags}">
                                                                        <div class="mt-1 d-flex flex-wrap gap-1">
                                                                            <c:if test="${u.tags.contains('khach_si')}">
                                                                                <span class="badge bg-primary"
                                                                                    style="font-size: 10px;">Khách
                                                                                    sỉ</span>
                                                                            </c:if>
                                                                            <c:if
                                                                                test="${u.tags.contains('boom_hang')}">
                                                                                <span class="badge bg-danger"
                                                                                    style="font-size: 10px;">Hay boom
                                                                                    hàng</span>
                                                                            </c:if>
                                                                            <c:if
                                                                                test="${u.tags.contains('tiem_nang')}">
                                                                                <span class="badge bg-success"
                                                                                    style="font-size: 10px;">Tiềm
                                                                                    năng</span>
                                                                            </c:if>
                                                                            <c:if test="${u.tags.contains('kho_tinh')}">
                                                                                <span class="badge bg-warning text-dark"
                                                                                    style="font-size: 10px;">Khó
                                                                                    tính</span>
                                                                            </c:if>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </td>

                                                        <td class="align-middle">
                                                            <div class="text-dark"><i
                                                                    class="fa-solid fa-envelope text-muted me-2"></i>
                                                                <c:out value="${u.email}" />
                                                            </div>
                                                            <div class="mt-1" style="font-size: 14px;">
                                                                <c:choose>
                                                                    <c:when test="${not empty u.phone_number}">
                                                                        <i
                                                                            class="fa-solid fa-phone text-muted me-2"></i>
                                                                        <c:out value="${u.phone_number}" />
                                                                    </c:when>
                                                                    <c:otherwise><span
                                                                            class="text-muted fst-italic">Chưa có
                                                                            SĐT</span></c:otherwise>
                                                                </c:choose>
                                                            </div>

                                                        </td>
                                                        <td class="text-center align-middle">
                                                            <c:choose>
                                                                <%-- Sửa lại dùng u.f_points thay vì u.totalSpend --%>
                                                                    <c:when test="${u.f_points >= 5000}">
                                                                        <span
                                                                            class="badge bg-info text-dark rounded-pill px-2">
                                                                            <i class="fa-regular fa-gem"></i> Kim Cương
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${u.f_points >= 2000}">
                                                                        <span
                                                                            class="badge bg-warning text-dark rounded-pill px-2">
                                                                            <i class="fa-solid fa-medal"></i> Vàng
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${u.f_points >= 500}">
                                                                        <span
                                                                            class="badge bg-secondary rounded-pill px-2">
                                                                            🥈 Bạc
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            class="badge bg-dark border border-secondary text-muted rounded-pill px-2">
                                                                            🥉 Đồng
                                                                        </span>
                                                                    </c:otherwise>
                                                            </c:choose>

                                                            <%-- Phần hiển thị F-Point hiện tại --%>
                                                                <div class="mt-2 text-warning fw-bold"
                                                                    style="font-size: 15px;"
                                                                    title="Điểm F-Point tích lũy trong tháng">
                                                                    <i class="fa-solid fa-coins me-1"></i>
                                                                    <fmt:formatNumber value="${u.f_points}"
                                                                        type="number" maxFractionDigits="0" /> điểm
                                                                </div>
                                                        </td>
                                                        <td class="text-center align-middle">
                                                            <c:choose>
                                                                <c:when test="${u.status == 1}">
                                                                    <span
                                                                        class="badge bg-success rounded-pill px-3 py-2 fw-normal"><i
                                                                            class="fa-solid fa-check me-1"></i> Hoạt
                                                                        động</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        class="badge bg-danger rounded-pill px-3 py-2 fw-normal"><i
                                                                            class="fa-solid fa-lock me-1"></i> Đã
                                                                        khóa</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <td class="text-end pe-4 align-middle">
                                                            <a href="https://mail.google.com/mail/?view=cm&fs=1&to=${u.email}"
                                                                target="_blank"
                                                                class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                                                <i class="fa-regular fa-paper-plane me-1"></i> Gửi Mail
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>

                                                <c:if test="${empty listCustomers}">
                                                    <tr>
                                                        <td colspan="5" class="text-center py-5 text-muted">
                                                            <i class="fa-solid fa-box-open fs-1 mb-3"></i><br>Không tìm
                                                            thấy
                                                            khách
                                                            hàng nào.
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <div class="modal fade" id="marketingModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <div class="modal-content bg-dark border-secondary shadow-lg">
                                <div class="modal-header border-secondary">
                                    <h5 class="modal-title fw-bold text-warning"><i
                                            class="fa-solid fa-bullhorn me-2"></i>Chiến
                                        dịch Email Marketing</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>

                                <form action="${pageContext.request.contextPath}/staff/send-marketing" method="post">
                                    <div class="modal-body p-4 text-light">

                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label class="form-label fw-bold text-muted">Gửi đến Tệp khách
                                                    hàng:</label>
                                                <select name="targetGroup"
                                                    class="form-select bg-dark text-light border-secondary">
                                                    <option value="all">Tất cả khách hàng (Newsletter)</option>
                                                    <option value="vip">Chỉ khách hàng VIP (Đã mua > 5tr)</option>
                                                    <option value="inactive">Khách hàng ngủ đông (Không mua 3 tháng)
                                                    </option>
                                                    <option value="cart_abandon">Khách hàng bỏ quên giỏ hàng</option>
                                                </select>
                                            </div>

                                            <div class="col-md-6">
                                                <label class="form-label fw-bold text-muted">Mẫu Email có sẵn:</label>
                                                <select name="emailTemplate"
                                                    class="form-select bg-dark text-light border-secondary">
                                                    <option value="custom">-- Tự soạn thảo mới --</option>
                                                    <option value="sale_10">Thông báo Sale mùng 10/10</option>
                                                    <option value="happy_bday">Chúc mừng sinh nhật tháng này</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label fw-bold text-muted">Chủ đề (Subject):</label>
                                            <input type="text" name="subject"
                                                class="form-control bg-dark text-light border-secondary"
                                                placeholder="VD: [MindBook] Siêu Sale Giữa Tháng giảm 50%!" required>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label fw-bold text-muted">Nội dung (HTML
                                                allowed):</label>
                                            <textarea name="content"
                                                class="form-control bg-dark text-light border-secondary" rows="6"
                                                placeholder="Kính gửi quý khách hàng,..." required></textarea>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <label class="form-label fw-bold text-muted">Đính kèm Banner
                                                    (Ảnh):</label>
                                                <input type="file" name="bannerImage"
                                                    class="form-control bg-dark text-light border-secondary"
                                                    accept="image/*">
                                            </div>
                                            <div class="col-md-6 d-flex flex-column justify-content-end">
                                                <div class="form-check form-switch mb-2">
                                                    <input class="form-check-input" type="checkbox" id="trackOpen"
                                                        name="trackOpen" checked>
                                                    <label class="form-check-label text-muted" for="trackOpen">Theo dõi
                                                        lượt mở
                                                        Email (Tracking)</label>
                                                </div>
                                                <div class="form-check form-switch">
                                                    <input class="form-check-input" type="checkbox" id="scheduleSend"
                                                        name="scheduleSend">
                                                    <label class="form-check-label text-muted" for="scheduleSend">Lên
                                                        lịch gửi
                                                        (Gửi vào 8h sáng mai)</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer border-secondary">
                                        <button type="button" class="btn btn-secondary rounded-pill px-4"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit"
                                            class="btn btn-warning rounded-pill px-4 fw-bold text-dark">
                                            <i class="fa-regular fa-paper-plane me-2"></i> Khởi chạy Chiến dịch
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="modal fade" id="tagModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content bg-dark border-secondary shadow-lg">
                                <div class="modal-header border-secondary bg-info bg-opacity-10">
                                    <h5 class="modal-title fw-bold text-info"><i class="fa-solid fa-tags me-2"></i>Gắn
                                        nhãn Phân
                                        loại</h5>
                                    <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"></button>
                                </div>
                                <form action="${pageContext.request.contextPath}/staff/tag-customers" method="post">
                                    <div class="modal-body p-4 text-light">
                                        <input type="hidden" name="taggedUserIds" id="taggedUserIds">
                                        <p class="text-muted small mb-3">Chọn các nhãn để dán cho <strong
                                                class="text-info" id="tagCount">0</strong> khách hàng đã chọn:</p>

                                        <div class="row g-3">
                                            <div class="col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input border-secondary" type="checkbox"
                                                        name="tags" value="khach_si" id="tag1">
                                                    <label class="form-check-label text-light" for="tag1"><span
                                                            class="badge bg-primary">Khách mua sỉ</span></label>
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input border-secondary" type="checkbox"
                                                        name="tags" value="boom_hang" id="tag2">
                                                    <label class="form-check-label text-light" for="tag2"><span
                                                            class="badge bg-danger">Hay Boom hàng</span></label>
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input border-secondary" type="checkbox"
                                                        name="tags" value="tiem_nang" id="tag3">
                                                    <label class="form-check-label text-light" for="tag3"><span
                                                            class="badge bg-success">Khách tiềm năng</span></label>
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="form-check">
                                                    <input class="form-check-input border-secondary" type="checkbox"
                                                        name="tags" value="kho_tinh" id="tag4">
                                                    <label class="form-check-label text-light" for="tag4"><span
                                                            class="badge bg-warning text-dark">Khách khó
                                                            tính</span></label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer border-secondary">
                                        <button type="button"
                                            class="btn btn-outline-secondary rounded-pill px-4 text-light"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-info rounded-pill px-4 fw-bold">Lưu thay
                                            đổi</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="modal fade" id="noteModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content bg-dark border-secondary shadow-lg">
                                <div class="modal-header border-secondary bg-primary bg-opacity-10">
                                    <h5 class="modal-title fw-bold text-primary"><i
                                            class="fa-solid fa-clipboard-user me-2"></i>Ghi chú Chăm sóc</h5>
                                    <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"></button>
                                </div>
                                <form action="${pageContext.request.contextPath}/staff/note-customers" method="post">
                                    <div class="modal-body p-4 text-light">
                                        <input type="hidden" name="notedUserIds" id="notedUserIds">
                                        <p class="text-muted small mb-3">Đang thêm ghi chú cho <strong
                                                class="text-primary" id="noteCount">0</strong> khách hàng:</p>

                                        <div class="mb-3">
                                            <label class="form-label text-muted">Kênh tương tác</label>
                                            <select name="contactChannel"
                                                class="form-select bg-dark text-light border-secondary">
                                                <option value="call">☎️ Gọi điện thoại</option>
                                                <option value="email">📧 Gửi Email cá nhân</option>
                                                <option value="zalo">💬 Nhắn tin Zalo</option>
                                                <option value="other">Thoại trực tiếp</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label text-muted">Nội dung trao đổi</label>
                                            <textarea name="internalNote"
                                                class="form-control bg-dark text-light border-secondary" rows="3"
                                                placeholder="Ví dụ: Đã gọi điện tư vấn sách mới..." required></textarea>
                                        </div>

                                        <div class="mb-2">
                                            <label class="form-label text-muted">Lịch hẹn gọi lại (Follow-up
                                                Date)</label>
                                            <input type="date" name="followUpDate"
                                                class="form-control bg-dark text-light border-secondary">
                                        </div>
                                    </div>
                                    <div class="modal-footer border-secondary">
                                        <button type="button"
                                            class="btn btn-outline-secondary rounded-pill px-4 text-light"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Lưu ghi
                                            chú</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Modal hiển thị thông tin chi tiết khách hàng -->
                    <div class="modal fade" id="customerInfoModal" tabindex="-1"
                        aria-labelledby="customerInfoModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="customerInfoModalLabel">Thông tin khách hàng</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body" id="customerInfoBody">
                                    <div class="text-center py-5"><i class="fa-solid fa-spinner fa-spin"></i> Đang
                                        tải...</div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Đóng</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script>
                        const contextPath = "${pageContext.request.contextPath}";
                        // Check/Uncheck tất cả
                        document.getElementById('selectAllCus').addEventListener('change', function () {
                            let checkboxes = document.querySelectorAll('.cus-checkbox');
                            for (let checkbox of checkboxes) {
                                checkbox.checked = this.checked;
                            }
                        });

                        // Xử lý mở Modal Gắn Nhãn
                        function openTagModal() {
                            let checkedBoxes = document.querySelectorAll('.cus-checkbox:checked');
                            if (checkedBoxes.length === 0) {
                                alert('Vui lòng tích chọn ít nhất 1 khách hàng để gắn nhãn!');
                                return;
                            }
                            let ids = Array.from(checkedBoxes).map(cb => cb.value).join(',');
                            document.getElementById('taggedUserIds').value = ids;
                            document.getElementById('tagCount').innerText = checkedBoxes.length;

                            var myModal = new bootstrap.Modal(document.getElementById('tagModal'));
                            myModal.show();
                        }

                        // Xử lý mở Modal Ghi chú
                        function openNoteModal() {
                            let checkedBoxes = document.querySelectorAll('.cus-checkbox:checked');
                            if (checkedBoxes.length === 0) {
                                alert('Vui lòng tích chọn ít nhất 1 khách hàng để ghi chú!');
                                return;
                            }
                            let ids = Array.from(checkedBoxes).map(cb => cb.value).join(',');
                            document.getElementById('notedUserIds').value = ids;
                            document.getElementById('noteCount').innerText = checkedBoxes.length;

                            var myModal = new bootstrap.Modal(document.getElementById('noteModal'));
                            myModal.show();
                        }

                        function renderCustomerModal(data) {
                            let html = '';
                            html += '<div class="row">';
                            html += '<div class="col-md-6">';
                            html += '<p><strong>Tên:</strong> ' + (data.customer.fullname || '') + '</p>';
                            html += '<p><strong>Username:</strong> @' + (data.customer.username || '') + '</p>';
                            html += '<p><strong>Email:</strong> ' + (data.customer.email || '') + '</p>';
                            html += '</div>';
                            html += '<div class="col-md-6">';
                            html += '<p><strong>SĐT:</strong> ' + (data.customer.phone_number || '<span class="text-muted">Chưa cập nhật</span>') + '</p>';
                            html += '<p><strong>Trạng thái:</strong> ' + (data.customer.status == 1 ? '<span class="badge bg-success">Hoạt động</span>' : '<span class="badge bg-danger">Khóa</span>') + '</p>';
                            html += '<p><strong>Tags:</strong> ' + (data.customer.tags || '<span class="text-muted">Không có</span>') + '</p>';
                            html += '</div>';
                            html += '</div>';
                            html += '<hr />';
                            html += '<h6>Lịch sử ghi chú</h6>';
                            if (!data.notes || data.notes.length === 0) {
                                html += '<p class="text-muted">Chưa có ghi chú.</p>';
                            }
                            html += '<div class="list-group">';
                            if (data.notes && data.notes.length > 0) {
                                data.notes.forEach(function (n) {
                                    html += '<div class="list-group-item">';
                                    html += '<div class="d-flex justify-content-between">';
                                    html += '<small><strong>' + (n.contactChannel || '') + '</strong></small>';
                                    html += '<small class="text-muted">' + (n.createAt || '') + '</small>';
                                    html += '</div>';
                                    html += '<p class="mb-1">' + (n.noteContent || '') + '</p>';
                                    if (n.followUpDate) {
                                        html += '<small class="text-danger">Lịch hẹn: ' + n.followUpDate + '</small>';
                                    }
                                    html += '</div>';
                                });
                            }
                            html += '</div>';

                            document.getElementById('customerInfoBody').innerHTML = html;
                        }

                        function openCustomerModal(customerId) {
                            let modal = new bootstrap.Modal(document.getElementById('customerInfoModal'));
                            document.getElementById('customerInfoBody').innerHTML = '<div class="text-center py-5"><i class="fa-solid fa-spinner fa-spin"></i> Đang tải... </div>';
                            modal.show();

                            let url = contextPath + '/staff/customer-detail?ajax=1&id=' + encodeURIComponent(customerId);
                            fetch(url, { cache: 'no-store' })
                                .then(res => {
                                    if (!res.ok) {
                                        throw new Error('HTTP ' + res.status + ' ' + res.statusText);
                                    }
                                    return res.text();
                                })
                                .then(text => {
                                    try {
                                        let data = JSON.parse(text);
                                        if (data.error) {
                                            document.getElementById('customerInfoBody').innerHTML = '<div class="alert alert-danger">' + data.error + '</div>';
                                        } else {
                                            renderCustomerModal(data);
                                        }
                                    } catch (parseErr) {
                                        console.error('JSON parse error, response:', text);
                                        document.getElementById('customerInfoBody').innerHTML = '<div class="alert alert-danger">Lỗi phân tích dữ liệu từ server.</div>';
                                    }
                                })
                                .catch(err => {
                                    document.getElementById('customerInfoBody').innerHTML = '<div class="alert alert-danger">Lỗi tải dữ liệu: ' + err.message + '</div>';
                                    console.error('Fetch error', err);
                                });
                        }

                        document.querySelectorAll('tr.customer-row').forEach(function (row) {
                            row.addEventListener('click', function (event) {
                                if (event.target.closest('input[type="checkbox"]') ||
                                    event.target.closest('button') ||
                                    event.target.closest('a.btn') ||
                                    event.target.closest('.form-control') ||
                                    event.target.closest('.form-select')) {
                                    return;
                                }
                                let customerId = this.dataset.customerId;
                                if (customerId) {
                                    openCustomerModal(customerId);
                                }
                            });
                        });
                    </script>
                </body>

                </html>