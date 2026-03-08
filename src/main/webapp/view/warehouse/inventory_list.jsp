<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Danh sách tồn kho</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    body {
                        background-color: #f8f9fa;
                    }

                    .table-container,
                    .filter-container {
                        background: white;
                        padding: 20px;
                        border-radius: 8px;
                        box-shadow: 0 0 15px rgba(0, 0, 0, 0.05);
                        margin-bottom: 20px;
                    }
                </style>
            </head>

            <body>

                <div class="container-fluid px-4 mt-4 mb-5">
                    <div class="mb-3">
                        <a href="dashboard" class="btn btn-outline-secondary btn-sm mb-2 shadow-sm">
                            <i class="fa-solid fa-arrow-left"></i>Dashboard
                        </a>
                        <h3 class="text-uppercase fw-bold text-dark"><i class="fa-solid fa-warehouse text-primary"></i>
                            DANH SÁCH TỒN KHO</h3>
                    </div>

                    <div class="filter-container">
                        <form action="inventory" method="get" class="row g-3">

                            <div class="col-md-3">
                                <label class="form-label fw-bold">Từ khóa (Tên sách)</label>
                                <input type="text" name="keyword" class="form-control" placeholder="Nhập tên sách..."
                                    value="${param.keyword}">
                            </div>

                            <div class="col-md-2">
                                <label class="form-label fw-bold">Thể loại</label>
                                <select name="categoryId" class="form-select">
                                    <option value="0">-- Tất cả --</option>
                                    <c:forEach items="${listC}" var="c">
                                        <option value="${c.id}" ${param.categoryId==c.id ? 'selected' : '' }>${c.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-2">
                                <label class="form-label fw-bold">Tác giả</label>
                                <select name="author" class="form-select">
                                    <option value="">-- Tất cả --</option>
                                    <c:forEach items="${listA}" var="a">
                                        <option value="${a}" ${param.author==a ? 'selected' : '' }>${a}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-2">
                                <label class="form-label fw-bold">Nhà xuất bản</label>
                                <select name="publisher" class="form-select">
                                    <option value="">-- Tất cả --</option>
                                    <c:forEach items="${listP}" var="p">
                                        <option value="${p}" ${param.publisher==p ? 'selected' : '' }>${p}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2 w-50"><i
                                        class="fa-solid fa-filter"></i> Lọc</button>
                                <a href="inventory" class="btn btn-secondary w-50"><i
                                        class="fa-solid fa-rotate-right"></i> Xóa lọc</a>
                            </div>
                        </form>
                    </div>

                    <div class="table-container">
                        <table id="inventoryTable"
                            class="table table-bordered table-striped table-hover align-middle w-100">
                            <thead class="table-dark">
                                <tr>
                                    <th class="text-center" width="5%">#</th>
                                    <th class="text-center" width="7%">Ảnh</th>
                                    <th width="22%">Tên sách</th>
                                    <th width="12%">Thể loại</th>
                                    <th class="text-center" width="10%">Vị trí kệ</th>
                                    <th width="14%">Tác giả</th>
                                    <th width="14%">Nhà xuất bản</th>
                                    <th width="10%">Giá bán</th>
                                    <th class="text-center" width="8%">Tồn kho</th>
                                    <th class="text-center" width="8%">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${listB}" var="b">
                                    <tr>
                                        <td class="text-center fw-bold text-muted">${b.id}</td>
                                        <td class="text-center">
                                            <img src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}"
                                                alt="book" style="width: 45px; height: 65px; object-fit: cover;"
                                                onerror="this.src='https://placehold.co/45x65?text=Img'">
                                        </td>
                                        <td class="fw-bold text-primary">${b.title}</td>

                                        <td>${b.categoryName != null ? b.categoryName : 'Chưa phân loại'}</td>

                                        <td class="text-center fw-bold text-info">
                                            ${b.locationCode != null ? b.locationCode : '<span
                                                class="text-muted small">Chưa xếp kệ</span>'}
                                        </td>

                                        <td>${b.author}</td>
                                        <td>${b.publisher}</td>
                                        <td class="fw-bold text-danger" data-order="${b.price}">
                                            <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ"
                                                maxFractionDigits="0" />
                                        </td>
                                        <td class="text-center fs-5 fw-bold text-secondary">${b.stockQuantity}</td>
                                        <td class="text-center text-nowrap">
                                            <c:choose>
                                                <c:when test="${b.stockQuantity <= 0}"><span
                                                        class="badge bg-secondary">Hết hàng</span></c:when>
                                                <c:when test="${b.stockQuantity < 5}"><span
                                                        class="badge bg-warning text-dark">Sắp hết</span></c:when>
                                                <c:otherwise><span class="badge bg-success">Còn hàng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

                    <script>
                        $(document).ready(function () {
                            $('#inventoryTable').DataTable({
                                "language": { "url": "//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json" },
                                "pageLength": 10,
                                "searching": false,
                                "columnDefs": [
                                    { "orderable": false, "targets": 1 }
                                ],
                                "order": [[0, "desc"]]
                            });
                        });
                    </script>

            </body>

            </html>