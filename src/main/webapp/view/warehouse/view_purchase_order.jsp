<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Quản lý Đơn Nhập Hàng</title>

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <style>
                    body {
                        background-color: #f8f9fa;
                        font-family: Arial, sans-serif;
                    }

                    .card {
                        border: none;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                    }

                    .table th {
                        background-color: #f1f4f8;
                    }

                    .badge-status {
                        font-size: 13px;
                        padding: 6px 10px;
                        border-radius: 6px;
                    }

                    .text-gradient {
                        background: linear-gradient(45deg, #0d6efd, #20c997);
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                    }
                </style>
            </head>

            <body>

                <div class="container-fluid mt-4 mb-5 px-4">

                    <!-- HEADER -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold text-gradient m-0">
                            <i class="fas fa-boxes"></i> Quản lý Đơn Nhập Hàng (Purchase Orders)
                        </h2>

                        <div>
                            <a href="${pageContext.request.contextPath}/warehouse/dashboard"
                                class="btn btn-outline-secondary me-2">
                                <i class="fas fa-arrow-left"></i> Dashboard
                            </a>

                            <a href="${pageContext.request.contextPath}/warehouse/create-po"
                                class="btn btn-primary shadow-sm">
                                <i class="fas fa-plus"></i> Tạo Đơn Mới
                            </a>
                        </div>
                    </div>

                    <!-- FILTER -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form action="view-po" method="get" class="row g-3 align-items-end">

                                <div class="col-md-4">
                                    <label class="form-label fw-bold text-muted">Tên Nhà Cung Cấp</label>
                                    <input type="text" name="searchSupplier" class="form-control"
                                        value="${searchSupplier}" placeholder="Nhập tên NCC...">
                                </div>

                                <div class="col-md-3">
                                    <label class="form-label fw-bold text-muted">Trạng Thái</label>
                                    <select name="status" class="form-select">
                                        <option value="">-- Tất cả trạng thái --</option>
                                        <option value="0" ${currentStatus==0 ? 'selected' : '' }>Pending</option>
                                        <option value="1" ${currentStatus==1 ? 'selected' : '' }>Approved</option>
                                        <option value="2" ${currentStatus==2 ? 'selected' : '' }>Received</option>
                                        <option value="3" ${currentStatus==3 ? 'selected' : '' }>Cancelled</option>
                                    </select>
                                </div>

                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-dark w-100">
                                        <i class="fas fa-search"></i> Lọc
                                    </button>
                                </div>

                                <div class="col-md-2">
                                    <a href="view-po" class="btn btn-outline-secondary w-100">
                                        <i class="fas fa-sync"></i> Reset
                                    </a>
                                </div>

                            </form>
                        </div>
                    </div>

                    <!-- TABLE -->
                    <div class="card">
                        <div class="card-body p-0">
                            <table class="table table-hover align-middle mb-0">

                                <thead>
                                    <tr>
                                        <th class="ps-4">Mã PO</th>
                                        <th>Nhà Cung Cấp</th>
                                        <th>Ngày Tạo</th>
                                        <th>Người Tạo</th>
                                        <th class="text-center">Tổng SL</th>
                                        <th class="text-end">Tổng Tiền</th>
                                        <th class="text-center">Trạng Thái</th>
                                        <th class="text-center pe-4">Thao Tác</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <c:forEach items="${poList}" var="po">
                                        <tr>

                                            <td class="ps-4 fw-bold text-primary">
                                                #PO-${po.purchaseOrderId}
                                            </td>

                                            <td class="fw-bold">${po.supplierName}</td>

                                            <td>
                                                <fmt:formatDate value="${po.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>

                                            <td>${po.createdByName}</td>

                                            <td class="text-center">${po.totalQuantity}</td>

                                            <td class="text-end fw-bold text-danger">
                                                <fmt:formatNumber value="${po.totalAmount}" type="currency"
                                                    currencySymbol="₫" maxFractionDigits="0" />
                                            </td>

                                            <!-- STATUS -->
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${po.status == 0}">
                                                        <span
                                                            class="badge bg-warning text-dark badge-status">Pending</span>
                                                    </c:when>
                                                    <c:when test="${po.status == 1}">
                                                        <span
                                                            class="badge bg-info text-dark badge-status">Approved</span>
                                                    </c:when>
                                                    <c:when test="${po.status == 2}">
                                                        <span class="badge bg-success badge-status">Received</span>
                                                    </c:when>
                                                    <c:when test="${po.status == 3}">
                                                        <span class="badge bg-danger badge-status">Cancelled</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>

                                            <!-- ACTION -->
                                            <td class="text-center pe-4">

                                                <!-- Chỉ cho bấm khi Approved -->
                                                <c:if test="${po.status == 1}">
                                                    <a href="${pageContext.request.contextPath}/warehouse/receive-goods?poId=${po.purchaseOrderId}"
                                                        class="btn btn-sm btn-success">
                                                        Received
                                                    </a>
                                                </c:if>

                                                <!-- Disable các status khác -->
                                                <c:if test="${po.status != 1}">
                                                    <button class="btn btn-sm btn-secondary" disabled>
                                                        <i class="fas fa-ban"></i> Received
                                                    </button>
                                                </c:if>

                                            </td>

                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty poList}">
                                        <tr>
                                            <td colspan="8" class="text-center py-4 text-muted">
                                                Không có dữ liệu!
                                            </td>
                                        </tr>
                                    </c:if>

                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- PAGINATION -->
                    <c:if test="${totalPages > 1}">
                        <nav class="mt-4">
                            <ul class="pagination justify-content-center">

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link"
                                            href="view-po?page=${i}&searchSupplier=${searchSupplier}&status=${currentStatus}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>

                            </ul>
                        </nav>
                    </c:if>

                </div>

            </body>

            </html>