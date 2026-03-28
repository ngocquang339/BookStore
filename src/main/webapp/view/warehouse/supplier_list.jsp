<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Quản lý Nhà cung cấp</title>

            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            <style>
                body {
                    background-color: #f8f9fa;
                }

                .table-container {
                    background: white;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 0 15px rgba(0, 0, 0, 0.05);
                }
            </style>
        </head>

        <body>

            <div class="container-fluid px-4 mt-4 mb-5">

                <!-- ALERT -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm">
                        <strong><i class="fa-solid fa-triangle-exclamation"></i> Lỗi!</strong> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm">
                        <strong><i class="fa-solid fa-circle-check"></i> Thành công!</strong> ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- HEADER -->
                <div class="d-flex justify-content-between align-items-center mb-4">

                    <!-- LEFT -->
                    <a href="${pageContext.request.contextPath}/warehouse/dashboard" class="btn btn-outline-secondary">
                        <i class="fa-solid fa-arrow-left"></i> Dashboard
                    </a>

                    <!-- CENTER TITLE -->
                    <h4 class="fw-bold text-success m-0 text-center">
                        <i class="fa-solid fa-truck-fast me-2"></i>
                        Nhà Cung Cấp
                    </h4>

                    <!-- RIGHT BUTTON -->
                    <div>
                        <button class="btn btn-dark me-2" data-bs-toggle="modal" data-bs-target="#archiveModal">
                            <i class="fa-solid fa-box-archive"></i> Kho lưu trữ
                        </button>

                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addModal">
                            <i class="fa-solid fa-plus"></i> Thêm mới
                        </button>
                    </div>

                </div>

                <!-- TABLE ACTIVE -->
                <div class="table-container">
                    <table id="supplierTable" class="table table-bordered table-hover align-middle w-100">
                        <thead class="table-success">
                            <tr>
                                <th width="5%">STT</th>
                                <th width="20%">Tên Nhà Cung Cấp</th>
                                <th width="15%">Người liên hệ</th>
                                <th width="12%">Điện thoại</th>
                                <th width="18%">Email</th>
                                <th width="20%">Địa chỉ</th>
                                <th class="text-center" width="10%">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listS}" var="s" varStatus="status">
                                <tr>
                                    <td class="text-center fw-bold text-muted">${status.count}</td>
                                    <td class="fw-bold">${s.name}</td>
                                    <td>${s.contactPerson}</td>
                                    <td>${s.phone}</td>
                                    <td>${s.email}</td>
                                    <td>${s.address}</td>
                                    <td class="text-center text-nowrap">

                                        <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                            data-bs-target="#editModal"
                                            onclick="loadEditData('${s.id}','${s.name}','${s.contactPerson}','${s.phone}','${s.email}','${s.address}')">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>

                                        <form action="${pageContext.request.contextPath}/warehouse/supplier" method="post" class="d-inline"
                                            onsubmit="return confirm('Bạn có chắc muốn xóa?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${s.id}">
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

            <!-- ======================= MODAL KHO LƯU TRỮ ======================= -->
            <div class="modal fade" id="archiveModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">

                        <div class="modal-header bg-warning">
                            <h5 class="modal-title">
                                <i class="fa-solid fa-box-archive"></i> Danh sách đã xóa
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">

                            <div class="table-responsive">
                                <table class="table table-sm table-hover">
                                    <thead>
                                        <tr>
                                            <th>Tên Nhà Cung Cấp</th>
                                            <th>Điện thoại</th>
                                            <th class="text-center">Khôi phục</th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <c:forEach items="${listDeleted}" var="sd">
                                            <tr>
                                                <td>${sd.name}</td>
                                                <td>${sd.phone}</td>
                                                <td class="text-center">
                                                    <form action="${pageContext.request.contextPath}/warehouse/supplier" method="post">
                                                        <input type="hidden" name="action" value="restore">
                                                        <input type="hidden" name="id" value="${sd.id}">
                                                        <button type="submit" class="btn btn-sm btn-success">
                                                            <i class="fa-solid fa-rotate-left"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                    </tbody>
                                </table>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <!-- ======================= MODAL ADD ======================= -->
            <div class="modal fade" id="addModal" tabindex="-1">
                <div class="modal-dialog">
                    <form action="${pageContext.request.contextPath}/warehouse/supplier" method="POST" class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title">Thêm Nhà Cung Cấp</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">
                            <input type="hidden" name="action" value="add">

                            <div class="mb-3">
                                <label class="form-label">Tên Nhà Cung Cấp *</label>
                                <input type="text" class="form-control" name="name" required minlength="2">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Người liên hệ</label>
                                <input type="text" class="form-control" name="contactPerson">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Điện thoại *</label>
                                <input type="text" class="form-control" name="phone" required pattern="[0-9]{10,11}">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Email *</label>
                                <input type="email" class="form-control" name="email" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Địa chỉ *</label>
                                <input type="text" class="form-control" name="address" required minlength="5">
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">Thêm</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- ======================= MODAL EDIT ======================= -->
            <div class="modal fade" id="editModal" tabindex="-1">
                <div class="modal-dialog">
                    <form action="${pageContext.request.contextPath}/warehouse/supplier" method="post" class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title">Cập nhật NCC</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" id="edit-id">

                            <input type="text" id="edit-name" name="name" class="form-control mb-2" required>
                            <input type="text" id="edit-contact" name="contactPerson" class="form-control mb-2">
                            <input type="text" id="edit-phone" name="phone" class="form-control mb-2" required>
                            <input type="email" id="edit-email" name="email" class="form-control mb-2" required>
                            <textarea id="edit-address" name="address" class="form-control" rows="2"
                                required></textarea>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- SCRIPTS -->
            <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
            <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

            <script>
                $(document).ready(function () {
                    $('#supplierTable').DataTable({
                        "language": {
                            "url": "//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json"
                        }
                    });
                });

                function loadEditData(id, name, contact, phone, email, address) {
                    document.getElementById('edit-id').value = id;
                    document.getElementById('edit-name').value = name;
                    document.getElementById('edit-contact').value = contact;
                    document.getElementById('edit-phone').value = phone;
                    document.getElementById('edit-email').value = email;
                    document.getElementById('edit-address').value = address;
                }
            </script>

        </body>

        </html>