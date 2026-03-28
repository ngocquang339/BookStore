<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Cảnh báo Sắp hết hàng</title>

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

                    <!-- HEADER -->
                    <div class="mb-3 d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/warehouse/dashboard"
                            class="btn btn-outline-secondary">
                            <i class="fa-solid fa-arrow-left"></i> Dashboard
                        </a>

                        <h3 class="fw-bold text-warning m-0">
                            <i class="fa-solid fa-triangle-exclamation me-2"></i>
                            SÁCH SẮP HẾT HÀNG
                        </h3>

                        <a href="${pageContext.request.contextPath}/warehouse/create-po" class="btn btn-success">
                            <i class="fa-solid fa-boxes-packing"></i> Nhập hàng ngay
                        </a>
                    </div>

                    <!-- FILTER -->
                    <div class="filter-container">
                        <form action="${pageContext.request.contextPath}/warehouse/low-stock" method="get" class="row g-3">

                            <div class="col-md-3">
                                <label class="form-label fw-bold">Tên sách</label>
                                <input type="text" name="keyword" class="form-control" value="${param.keyword}">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label fw-bold">Thể loại</label>
                                <select name="categoryId" class="form-select">
                                    <option value="0">-- Tất cả --</option>
                                    <c:forEach items="${listC}" var="c">
                                        <option value="${c.id}" ${param.categoryId==c.id ? 'selected' : '' }>
                                            ${c.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label fw-bold">Nhà xuất bản</label>
                                <select name="publisher" class="form-select">
                                    <option value="">-- Tất cả --</option>
                                    <c:forEach items="${listP}" var="p">
                                        <option value="${p}" ${param.publisher==p ? 'selected' : '' }>
                                            ${p}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-3 d-flex align-items-end">
                                <button class="btn btn-warning w-50 me-2">
                                    <i class="fa-solid fa-filter"></i> Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/warehouse/low-stock" class="btn btn-secondary w-50">
                                    Làm mới
                                </a>
                            </div>

                        </form>
                    </div>

                    <!-- TABLE -->
                    <div class="table-container border-top border-danger border-4">
                        <table id="lowStockTable" class="table table-bordered table-hover align-middle w-100">

                            <thead class="table-danger">
                                <tr>
                                    <th class="text-center" width="5%">STT</th>
                                    <th class="text-center" width="7%">Ảnh</th>
                                    <th width="30%">Tên sách</th>
                                    <th width="15%">Thể loại</th>
                                    <th width="15%">Nhà xuất bản</th>
                                    <th class="text-center" width="15%">Tồn kho</th>
                                    <th class="text-center" width="13%">Mức độ</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach items="${listB}" var="b" varStatus="status">
                                    <tr>
                                        <td class="text-center fw-bold text-muted">
                                            ${status.count}
                                        </td>

                                        <td class="text-center">
                                            <img src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}"
                                                style="width: 45px; height: 65px; object-fit: cover;"
                                                onerror="this.src='https://placehold.co/45x65?text=Img'">
                                        </td>

                                        <td class="fw-bold text-primary">${b.title}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty b.categoryName}">
                                                    ${b.categoryName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small">Chưa phân loại</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>${b.publisher}</td>

                                        <td class="text-center fw-bold">
                                            ${b.stockQuantity}
                                        </td>

                                        <td class="text-center text-nowrap">
                                            <c:choose>
                                                <c:when test="${b.stockQuantity <= 0}">
                                                    <span class="badge bg-danger">Hết hàng</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark">Cần nhập gấp</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>

                        </table>
                    </div>
                </div>

                <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

                <script>
                    $(document).ready(function () {
                        $('#lowStockTable').DataTable({
                            "language": {
                                "url": "//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json"
                            },
                            "pageLength": 10,
                            "searching": false,
                            "columnDefs": [
                                { "orderable": false, "targets": [1] }
                            ]
                        });
                    });
                </script>

            </body>

            </html>