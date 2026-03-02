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
                    <c:if test="${not empty errorMessage}"> 
                        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                            <strong><i class="fa-solid fa-triangle-exclamation"></i> Lỗi!</strong> ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                            <strong><i class="fa-solid fa-circle-check"></i> Thành công!</strong> ${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="mb-3 d-flex justify-content-between align-items-center">
                        <div>
                            <a href="dashboard" class="btn btn-outline-secondary me-2"><i
                                    class="fa-solid fa-arrow-left"></i> Dashboard</a>
                            <h3 class="d-inline-block m-0 text-success"><i class="fa-solid fa-truck-fast"></i> Nhà Cung
                                Cấp</h3>
                        </div>
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addModal">
                            <i class="fa-solid fa-plus"></i> Thêm mới
                        </button>
                    </div>

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
                                                onclick="loadEditData('${s.id}', '${s.name}', '${s.contactPerson}', '${s.phone}', '${s.email}', '${s.address}')">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </button>
                                            <form action="supplier" method="post" class="d-inline"
                                                onsubmit="return confirm('Bạn có chắc chắn muốn xóa nhà cung cấp này?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${s.id}">
                                                <button type="submit" class="btn btn-sm btn-danger"><i
                                                        class="fa-solid fa-trash"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
            </div>

            <div class="modal fade" id="addModal" tabindex="-1">
                <div class="modal-dialog">
                    <form action="supplier" method="POST" class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title">Thêm Nhà Cung Cấp</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="add">

                            <div class="mb-3">
                                <label class="form-label">Tên nhà cung cấp <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="name" required minlength="2"
                                    placeholder="VD: NXB Kim Đồng">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Người liên hệ</label>
                                <input type="text" class="form-control" name="contactPerson"
                                    placeholder="VD: Nguyễn Văn A">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="phone" required pattern="[0-9]{10,11}"
                                    title="Vui lòng nhập số điện thoại hợp lệ (10-11 số)" placeholder="VD: 0912345678">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" name="email" required
                                    placeholder="VD: cskh@nxbkimdong.com.vn">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="address" required minlength="5"
                                    placeholder="Nhập địa chỉ chi tiết...">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">Thêm Nhà Cung Cấp</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal fade" id="editModal" tabindex="-1">
                <div class="modal-dialog">
                    <form action="supplier" method="post" class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title">Cập Nhật Nhà Cung Cấp</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" id="edit-id">

                            <div class="mb-3">
                                <label class="form-label">Tên NCC <span class="text-danger">*</span></label>
                                <input type="text" name="name" id="edit-name" class="form-control" required
                                    minlength="2">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Người liên hệ</label>
                                <input type="text" name="contactPerson" id="edit-contact" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Điện thoại <span class="text-danger">*</span></label>
                                <input type="text" name="phone" id="edit-phone" class="form-control" required
                                    pattern="[0-9]{10,11}" title="Vui lòng nhập số điện thoại hợp lệ (10-11 số)">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email <span class="text-danger">*</span></label>
                                <input type="email" name="email" id="edit-email" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                                <textarea name="address" id="edit-address" class="form-control" rows="2" required
                                    minlength="5"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
            <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

            <script>
                $(document).ready(function () {
                    $('#supplierTable').DataTable({
                        "language": { "url": "//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json" }
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