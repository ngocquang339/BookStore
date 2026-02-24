<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Sơ Đồ Vị Trí Kho</title>

            <!-- Google Font -->
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">

            <!-- CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            <style>
                body {
                    background-color: #f8f9fa;
                    font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
                    font-size: 14px;
                    color: #343a40;
                }

                .table-container {
                    background: white;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 0 15px rgba(0, 0, 0, 0.05);
                }

                h3 {
                    font-weight: 700;
                    letter-spacing: 0.3px;
                }

                table.dataTable {
                    font-size: 13.5px;
                }

                .table th {
                    font-weight: 600;
                    text-transform: uppercase;
                    font-size: 12.5px;
                    letter-spacing: 0.4px;
                    color: #495057;
                }

                .table td {
                    vertical-align: middle;
                }

                .location-code {
                    font-weight: 700;
                    font-size: 15px;
                    color: #0d6efd;
                    letter-spacing: 0.5px;
                }

                .text-note {
                    color: #6c757d;
                    font-size: 13px;
                }

                .badge-category {
                    font-size: 12px;
                    font-weight: 500;
                }

                .btn {
                    font-size: 13px;
                    font-weight: 500;
                }

                .modal-title {
                    font-weight: 600;
                }

                .form-label {
                    font-size: 13px;
                    font-weight: 600;
                }
            </style>
        </head>

        <body>

            <div class="container-fluid px-4 mt-4 mb-5">
                <div class="mb-3 d-flex justify-content-between align-items-center">
                    <div>
                        <a href="dashboard" class="btn btn-outline-secondary me-2">
                            <i class="fa-solid fa-arrow-left"></i> Dashboard
                        </a>
                        <h3 class="d-inline-block m-0 text-info">
                            <i class="fa-solid fa-map-location-dot"></i> Thiết Lập Vị Trí Kho
                        </h3>
                    </div>
                    <button class="btn btn-info text-white" data-bs-toggle="modal" data-bs-target="#addModal">
                        <i class="fa-solid fa-plus"></i> Thêm Vị Trí
                    </button>
                </div>

                <div class="table-container border-top border-info border-4">
                    <table id="locationTable" class="table table-bordered table-hover align-middle w-100">
                        <thead class="table-light">
                            <tr>
                                <th class="text-center" width="5%">STT</th>
                                <th class="text-center" width="15%">Mã Vị Trí</th>
                                <th class="text-center" width="10%">Khu</th>
                                <th class="text-center" width="10%">Kệ</th>
                                <th class="text-center" width="10%">Tầng</th>
                                <th class="text-center" width="20%">Dành cho Thể loại</th>
                                <th class="text-center" width="20%">Ghi chú</th>
                                <th class="text-center" width="10%">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listL}" var="l" varStatus="status">
                                <tr>
                                    <td class="text-center fw-bold text-muted">${status.count}</td>
                                    <td class="text-center location-code">${l.locationCode}</td>
                                    <td class="text-center">${l.zone}</td>
                                    <td class="text-center">${l.rack}</td>
                                    <td class="text-center">${l.shelf}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${l.categoryName != null}">
                                                <span class="category-pill">${l.categoryName}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="category-none">Tất cả thể loại</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-note">${l.description}</td>
                                    <td class="text-center text-nowrap">
                                        <button class="btn btn-sm btn-warning" data-bs-toggle="modal"
                                            data-bs-target="#editModal"
                                            onclick="loadEditData('${l.id}', '${l.zone}', '${l.rack}', '${l.shelf}', '${l.categoryId}', '${l.description}')">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <form action="location" method="post" class="d-inline"
                                            onsubmit="return confirm('Bạn có chắc chắn muốn xóa vị trí này?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${l.id}">
                                            <button type="submit" class="btn btn-sm btn-danger">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- MODALS -->
            <c:forEach var="modalType" items="add,edit">
                <div class="modal fade" id="${modalType}Modal" tabindex="-1">
                    <div class="modal-dialog">
                        <form action="location" method="post" class="modal-content">
                            <div class="modal-header ${modalType == 'add' ? 'bg-info text-white' : 'bg-warning'}">
                                <h5 class="modal-title">
                                    ${modalType == 'add' ? 'Thêm Vị Trí Mới' : 'Cập Nhật Vị Trí'}
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>

                            <div class="modal-body">
                                <input type="hidden" name="action" value="${modalType == 'add' ? 'add' : 'update'}">
                                <input type="hidden" name="id" id="${modalType}-id">

                                <div class="row mb-3">
                                    <div class="col-4">
                                        <label class="form-label">Khu (VD: A)</label>
                                        <input type="text" name="zone" id="${modalType}-zone"
                                            class="form-control text-uppercase" required>
                                    </div>
                                    <div class="col-4">
                                        <label class="form-label">Kệ (VD: 01)</label>
                                        <input type="text" name="rack" id="${modalType}-rack" class="form-control"
                                            required>
                                    </div>
                                    <div class="col-4">
                                        <label class="form-label">Tầng (VD: 01)</label>
                                        <input type="text" name="shelf" id="${modalType}-shelf" class="form-control"
                                            required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Dành cho Thể loại</label>
                                    <select name="categoryId" id="${modalType}-categoryId" class="form-select">
                                        <option value="0">-- Dùng chung (Tất cả) --</option>
                                        <c:forEach items="${listC}" var="c">
                                            <option value="${c.id}">${c.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Ghi chú</label>
                                    <textarea name="description" id="${modalType}-description" class="form-control"
                                        rows="2"></textarea>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit"
                                    class="btn ${modalType == 'add' ? 'btn-info text-white' : 'btn-warning'}">
                                    Lưu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:forEach>

            <!-- JS -->
            <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
            <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

            <script>
                $(document).ready(function () {
                    $('#locationTable').DataTable({
                        language: {
                            url: "//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json"
                        }
                    });
                });

                function loadEditData(id, zone, rack, shelf, categoryId, description) {
                    document.getElementById('edit-id').value = id;
                    document.getElementById('edit-zone').value = zone;
                    document.getElementById('edit-rack').value = rack;
                    document.getElementById('edit-shelf').value = shelf;
                    document.getElementById('edit-categoryId').value = categoryId ? categoryId : "0";
                    document.getElementById('edit-description').value = description;
                }
            </script>

        </body>

        </html>