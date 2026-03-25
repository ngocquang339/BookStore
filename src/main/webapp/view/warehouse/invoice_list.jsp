<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Warehouse - Invoice Management</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

                <style>
                    body {
                        background-color: #f4f6f9;
                    }

                    .invoice-container {
                        margin-top: 30px;
                        background: #fff;
                        padding: 25px;
                        border-radius: 8px;
                        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                    }

                    .table th {
                        background-color: #343a40;
                        color: white;
                    }

                    .modal-header {
                        background-color: #0d6efd;
                        color: white;
                    }
                </style>
            </head>

            <body>

                <div class="container invoice-container">

                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <a href="${pageContext.request.contextPath}/warehouse/dashboard"
                            class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Back
                        </a>

                        <h2 class="m-0 text-center flex-grow-1">
                            <i class="fas fa-file-invoice-dollar"></i> Quản lý Hóa đơn
                        </h2>

                        <div style="width: 120px;"></div>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <form action="${pageContext.request.contextPath}/warehouse/invoices" method="GET"
                            class="d-flex align-items-center">
                            <label class="me-2 fw-bold text-nowrap"><i class="fas fa-filter"></i> Phân loại:</label>
                            <select name="filter" class="form-select w-auto" onchange="this.form.submit()">
                                <option value="" ${empty currentFilter ? 'selected' : '' }>Tất cả hóa đơn</option>
                                <option value="SALE" ${currentFilter=='SALE' ? 'selected' : '' }>Sale Invoice (Hóa đơn
                                    Bán)</option>
                                <option value="PURCHASE" ${currentFilter=='PURCHASE' ? 'selected' : '' }>Purchase
                                    Invoice (Hóa đơn Nhập)</option>
                            </select>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle">
                            <thead>
                                <tr class="text-center">
                                    <th>Invoice ID</th>
                                    <th>Type</th>
                                    <th>Created Date</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty invoices}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted">
                                                Không tìm thấy hóa đơn nào phù hợp.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${invoices}" var="inv">
                                            <tr class="text-center">
                                                <td class="fw-bold">INV-${inv.invoiceId}</td>

                                                <td>
                                                    <span
                                                        class="badge ${inv.invoiceType == 'SALE' ? 'bg-success' : 'bg-primary'}">
                                                        ${inv.invoiceType}
                                                    </span>
                                                </td>

                                                <td>
                                                    <fmt:formatDate value="${inv.createdDate}"
                                                        pattern="dd/MM/yyyy HH:mm" />
                                                </td>

                                                <td class="text-end text-danger fw-bold">
                                                    <fmt:formatNumber value="${inv.totalAmount}" type="currency"
                                                        currencySymbol="VNĐ" maxFractionDigits="0" />
                                                </td>

                                                <td>
                                                    <span class="badge bg-secondary">${inv.status}</span>
                                                </td>

                                                <td>
                                                    <a href="${pageContext.request.contextPath}/warehouse/invoices?action=detail&id=${inv.invoiceId}&type=${inv.invoiceType}&filter=${currentFilter}"
                                                        class="btn btn-sm btn-info text-white">
                                                        <i class="fas fa-eye"></i> View Detail
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="modal fade" id="invoiceModal" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">

                            <c:if test="${not empty invoiceDetail}">
                                <div class="modal-header">
                                    <h5 class="modal-title">
                                        <i class="fas fa-file-invoice"></i> Chi tiết Hóa đơn:
                                        INV-${invoiceDetail.invoiceId}
                                    </h5>
                                    <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"></button>
                                </div>

                                <div class="modal-body">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <p><strong>Loại hóa đơn:</strong>
                                                <span
                                                    class="badge ${type == 'SALE' ? 'bg-success' : 'bg-primary'}">${type}</span>
                                            </p>
                                            <p><strong>Ngày tạo:</strong>
                                                <fmt:formatDate value="${invoiceDetail.createdDate}"
                                                    pattern="dd/MM/yyyy HH:mm" />
                                            </p>
                                            <p><strong>Trạng thái:</strong> ${invoiceDetail.status}</p>
                                        </div>

                                        <div class="col-md-6 border-start">
                                            <c:choose>
                                                <c:when test="${type == 'SALE'}">
                                                    <h6><strong>Khách hàng (#${invoiceDetail.relatedId})</strong></h6>
                                                    <p class="mb-1">${invoiceDetail.customerName}</p>
                                                    <p class="mb-1">${invoiceDetail.customerPhone}</p>
                                                    <p class="mb-1">${invoiceDetail.customerEmail}</p>
                                                    <p class="mb-0">${invoiceDetail.customerAddress}</p>
                                                </c:when>

                                                <c:when test="${type == 'PURCHASE'}">
                                                    <h6><strong>Nhà cung cấp (#${invoiceDetail.relatedId})</strong></h6>
                                                    <p class="mb-1">${invoiceDetail.supplierName}</p>
                                                    <p class="mb-1">${invoiceDetail.supplierPhone}</p>
                                                    <p class="mb-0">${invoiceDetail.supplierAddress}</p>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <hr>

                                    <h6 class="fw-bold mb-3">Danh sách hàng hóa</h6>

                                    <table class="table table-sm table-striped">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>STT</th>
                                                <th>Tên Sách</th>
                                                <th class="text-center">Số lượng</th>
                                                <th class="text-end">Đơn giá</th>
                                                <th class="text-end">Thành tiền</th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <c:forEach items="${invoiceDetail.items}" var="item" varStatus="loop">
                                                <tr>
                                                    <td>${loop.index + 1}</td>
                                                    <td>${item.title}</td>
                                                    <td class="text-center">${item.quantity}</td>
                                                    <td class="text-end">
                                                        <fmt:formatNumber value="${item.price}" maxFractionDigits="0" />
                                                        đ
                                                    </td>
                                                    <td class="text-end fw-bold">
                                                        <fmt:formatNumber value="${item.quantity * item.price}"
                                                            maxFractionDigits="0" /> đ
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>

                                        <tfoot>
                                            <tr>
                                                <th colspan="4" class="text-end">Tổng cộng:</th>
                                                <th class="text-end text-danger fs-5">
                                                    <fmt:formatNumber value="${invoiceDetail.totalAmount}"
                                                        maxFractionDigits="0" /> đ
                                                </th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>

                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Đóng</button>
                                </div>
                            </c:if>

                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <c:if test="${openModal}">
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            var myModal = new bootstrap.Modal(document.getElementById('invoiceModal'));
                            myModal.show();

                            // Xóa param action, id, type trên URL để F5 không bị load lại modal
                            // NHƯNG GIỮ LẠI param filter để lưới (bảng) không bị mất bộ lọc hiện tại
                            const url = new URL(window.location);
                            url.searchParams.delete('action');
                            url.searchParams.delete('id');
                            url.searchParams.delete('type');
                            window.history.replaceState({}, document.title, url);
                        });
                    </script>
                </c:if>

            </body>

            </html>