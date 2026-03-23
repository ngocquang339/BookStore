<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Lịch Sử Tồn Kho - Warehouse</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

                <style>
                    body {
                        background-color: #f8f9fa;
                    }

                    .card-custom {
                        border: none;
                        border-radius: 12px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                    }

                    .table-custom th {
                        background-color: #2c3e50;
                        color: white;
                        font-weight: 500;
                    }

                    .table-custom td {
                        vertical-align: middle;
                    }

                    .qty-positive {
                        color: #198754;
                        font-weight: bold;
                        font-size: 1.1rem;
                    }

                    .qty-negative {
                        color: #dc3545;
                        font-weight: bold;
                        font-size: 1.1rem;
                    }

                    /* Style cho nút sắp xếp (Sort) */
                    .sort-link {
                        color: white;
                        text-decoration: none;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .sort-link:hover {
                        color: #f1c40f;
                    }

                    .sort-icon {
                        font-size: 0.8rem;
                        opacity: 0.6;
                    }

                    .sort-icon.active {
                        opacity: 1;
                        color: #f1c40f;
                    }
                </style>
            </head>

            <body>

                <div class="container-fluid py-4 px-4">
                    <div class="position-relative mb-4">
                        <a href="${pageContext.request.contextPath}/warehouse/dashboard"
                            class="btn btn-secondary position-absolute start-0 top-50 translate-middle-y">
                            <i class="fas fa-arrow-left"></i> Back
                        </a>

                        <h2 class="text-center mb-0 text-dark fw-bold">
                            <i class="fas fa-history me-2 text-primary"></i> Lịch Sử Biến Động Kho
                        </h2>

                        <form action="${pageContext.request.contextPath}/warehouse/inventory-history" method="GET"
                            class="position-absolute end-0 top-50 translate-middle-y d-flex align-items-center">
                            <input type="hidden" name="sortBy" value="${sortBy}">
                            <input type="hidden" name="sortDir" value="${sortDir}">

                            <label class="me-2 fw-bold text-secondary">Lọc:</label>
                            <select name="filter" onchange="this.form.submit()" class="form-select shadow-sm border-0"
                                style="width: 200px; cursor: pointer;">
                                <option value="">-- Tất cả --</option>
                                <option value="IMPORT" ${currentFilter=='IMPORT' ? 'selected' : '' }>⬇️ Nhập kho
                                </option>
                                <option value="EXPORT" ${currentFilter=='EXPORT' ? 'selected' : '' }>⬆️ Xuất bán
                                </option>
                                <option value="RETURN" ${currentFilter=='RETURN' ? 'selected' : '' }>🔄 Khách trả
                                </option>
                            </select>
                        </form>
                    </div>

                    <div class="card card-custom">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover table-custom mb-0 text-start">
                                    <thead>
                                        <tr>
                                            <th style="width: 20%;">
                                                <a href="?filter=${currentFilter}&sortBy=date&sortDir=${sortBy == 'date' && sortDir == 'DESC' ? 'ASC' : 'DESC'}"
                                                    class="sort-link ps-3">
                                                    Thời Gian
                                                    <i
                                                        class="fas fa-sort${sortBy == 'date' ? (sortDir == 'ASC' ? '-up active' : '-down active') : ''} sort-icon"></i>
                                                </a>
                                            </th>

                                            <th style="width: 25%;">
                                                <a href="?filter=${currentFilter}&sortBy=book&sortDir=${sortBy == 'book' && sortDir == 'ASC' ? 'DESC' : 'ASC'}"
                                                    class="sort-link">
                                                    Tên Sách
                                                    <i
                                                        class="fas fa-sort${sortBy == 'book' ? (sortDir == 'ASC' ? '-up active' : '-down active') : ''} sort-icon"></i>
                                                </a>
                                            </th>

                                            <th style="width: 15%; padding-top: 11px;">Loại Giao Dịch</th>

                                            <th style="width: 15%;" class="text-center">
                                                <a href="?filter=${currentFilter}&sortBy=qty&sortDir=${sortBy == 'qty' && sortDir == 'DESC' ? 'ASC' : 'DESC'}"
                                                    class="sort-link justify-content-center">
                                                    Số Lượng
                                                    <i
                                                        class="fas fa-sort${sortBy == 'qty' ? (sortDir == 'ASC' ? '-up active' : '-down active') : ''} sort-icon ms-2"></i>
                                                </a>
                                            </th>

                                            <th style="width: 15%; padding-top: 11px;" class="text-center">Mã Tham Chiếu
                                            </th>
                                            <th style="width: 10%; padding-top: 11px;">Người Thực Hiện</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty historyList}">
                                                <tr>
                                                    <td colspan="6" class="text-center py-5 text-muted">
                                                        <i class="fas fa-folder-open fa-3x mb-3 text-light"></i><br>
                                                        Chưa có dữ liệu lịch sử nào phù hợp.
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="item" items="${historyList}">
                                                    <tr>
                                                        <td class="ps-4 text-secondary">
                                                            <i class="far fa-clock me-1"></i>
                                                            <fmt:formatDate value="${item.createdAt}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td class="fw-bold text-dark">${item.bookTitle}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${item.transactionType == 'IMPORT'}">
                                                                    <span
                                                                        class="badge bg-success bg-opacity-10 text-success border border-success"><i
                                                                            class="fas fa-arrow-down me-1"></i> Nhập
                                                                        Kho</span>
                                                                </c:when>
                                                                <c:when test="${item.transactionType == 'EXPORT'}">
                                                                    <span
                                                                        class="badge bg-danger bg-opacity-10 text-danger border border-danger"><i
                                                                            class="fas fa-arrow-up me-1"></i> Xuất
                                                                        Bán</span>
                                                                </c:when>
                                                                <c:when test="${item.transactionType == 'RETURN'}">
                                                                    <span
                                                                        class="badge bg-warning bg-opacity-10 text-dark border border-warning"><i
                                                                            class="fas fa-undo-alt me-1"></i> Khách
                                                                        Trả</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${item.quantityChanged > 0}"><span
                                                                        class="qty-positive">+${item.quantityChanged}</span>
                                                                </c:when>
                                                                <c:otherwise><span
                                                                        class="qty-negative">${item.quantityChanged}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:if test="${not empty item.relatedId}">
                                                                <span class="badge bg-secondary">${item.transactionType
                                                                    == 'IMPORT' ? 'PO' : 'ORD'}-${item.relatedId}</span>
                                                            </c:if>
                                                            <c:if test="${empty item.relatedId}"><span
                                                                    class="text-muted">-</span></c:if>
                                                        </td>
                                                        <td>
                                                            <i class="fas fa-user-circle text-secondary me-1"></i> ${not
                                                            empty item.createdByName ? item.createdByName : 'Hệ thống'}
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <c:if test="${totalPages > 1}">
                                <div class="card-footer bg-white py-3 d-flex justify-content-center border-0">
                                    <nav>
                                        <ul class="pagination mb-0 shadow-sm">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage - 1}&filter=${currentFilter}&sortBy=${sortBy}&sortDir=${sortDir}">Quay
                                                    lại</a>
                                            </li>

                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="?page=${i}&filter=${currentFilter}&sortBy=${sortBy}&sortDir=${sortDir}">${i}</a>
                                                </li>
                                            </c:forEach>

                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="?page=${currentPage + 1}&filter=${currentFilter}&sortBy=${sortBy}&sortDir=${sortDir}">Tiếp
                                                    theo</a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </c:if>

                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>