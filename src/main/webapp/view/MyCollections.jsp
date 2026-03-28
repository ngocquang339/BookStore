<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bộ sưu tập của tôi - BookStore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .collection-wrapper {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            min-height: 500px;
        }
        
        .collection-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }

        /* Thẻ Bộ sưu tập (Card) */
        .collection-card {
            border: 1px solid #eaeaea;
            border-radius: 10px;
            overflow: hidden;
            transition: 0.3s;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .collection-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transform: translateY(-3px);
        }
        .collection-color-bar {
            height: 8px;
            width: 100%;
        }
        .collection-body {
            padding: 15px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        .collection-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .collection-desc {
            font-size: 13px;
            color: #666;
            margin-bottom: 15px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            flex-grow: 1;
        }
        .collection-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            color: #888;
            margin-top: auto;
            padding-top: 10px;
            border-top: 1px dashed #eee;
        }
        .action-btns {
            display: flex;
            gap: 10px;
        }
        .action-btns button, .action-btns form button {
            background: none;
            border: none;
            color: #888;
            transition: 0.2s;
            padding: 0;
        }
        .action-btns button:hover.edit-btn { color: #2f80ed; }
        .action-btns button:hover.delete-btn { color: #dc3545; }
        
        .badge-public { background-color: #e6f8ec; color: #28a745; font-size: 11px; padding: 4px 8px; }
        .badge-private { background-color: #f8f9fa; color: #6c757d; font-size: 11px; padding: 4px 8px; }
    </style>
</head>
<body>

    <jsp:include page="component/header.jsp" />

    <div class="container profile-container py-4">
        <div class="row">
            <div class="col-md-3">
                <jsp:include page="component/sidebar.jsp" />
            </div>

            <div class="col-md-9">
                <div class="collection-wrapper">
                    
                    <div class="collection-header">
                        <h4 class="m-0 fw-bold" style="color: #333;"><i class="fa-solid fa-swatchbook me-2" style="color: #C92127;"></i> Giá Sách Của Tôi</h4>
                        <button class="btn text-white fw-bold" style="background-color: #C92127;" data-bs-toggle="modal" data-bs-target="#createModal">
                            <i class="fa-solid fa-plus me-1"></i> Tạo mới
                        </button>
                    </div>

                    <c:if test="${not empty sessionScope.successMsg}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fa-solid fa-circle-check me-2"></i>${sessionScope.successMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="successMsg" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMsg}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fa-solid fa-circle-xmark me-2"></i>${sessionScope.errorMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="errorMsg" scope="session" />
                    </c:if>

                    <div class="row">
                        <c:choose>
                            <c:when test="${empty listCollections}">
                                <div class="col-12 text-center py-5">
                                    <img src="https://cdni.iconscout.com/illustration/premium/thumb/empty-state-2130362-1800926.png" width="150" alt="Trống">
                                    <h6 class="text-muted mt-3">Bạn chưa có bộ sưu tập nào. Hãy tạo mới ngay!</h6>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${listCollections}">
                                    <div class="col-md-4 col-sm-6 mb-4">
                                        <div class="collection-card">
                                            <div class="collection-color-bar" style="background-color: ${c.coverColor};"></div>
                                            
                                            <div class="collection-body">
                                                <a href="${pageContext.request.contextPath}/collection-detail?id=${c.id}" style="text-decoration: none; color: inherit;">
                                                    <div class="collection-title" style="transition: color 0.3s;" onmouseover="this.style.color='${c.coverColor}'" onmouseout="this.style.color='#333'">
                                                        ${c.name}
                                                    </div>
                                                </a>
                                                
                                                <div class="mb-2">
                                                    <c:if test="${c.isPublic()}">
                                                        <span class="badge rounded-pill badge-public"><i class="fa-solid fa-earth-americas"></i> Công khai</span>
                                                    </c:if>
                                                    <c:if test="${not c.isPublic()}">
                                                        <span class="badge rounded-pill badge-private"><i class="fa-solid fa-lock"></i> Riêng tư</span>
                                                    </c:if>
                                                </div>

                                                <div class="collection-desc">${empty c.description ? 'Không có mô tả.' : c.description}</div>
                                                
                                                <div class="collection-meta">
                                                    <span><i class="fa-solid fa-book-open text-muted me-1"></i> ${c.totalBooks} cuốn</span>
                                                    
                                                    <div class="action-btns">
                                                        <button type="button" class="edit-btn" title="Chỉnh sửa" 
                                                                onclick="openEditModal(${c.id}, '${c.name}', '${c.description}', ${c.isPublic()}, '${c.coverColor}')">
                                                            <i class="fa-solid fa-pen-to-square"></i>
                                                        </button>
                                                        
                                                        <form action="${pageContext.request.contextPath}/my-collections" method="POST" style="margin:0;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa bộ sưu tập này? Mọi sách bên trong sẽ bị gỡ khỏi danh sách.');">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="collectionId" value="${c.id}">
                                                            <button type="submit" class="delete-btn" title="Xóa"><i class="fa-solid fa-trash-can"></i></button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="createModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-folder-plus text-danger me-2"></i>Tạo Giá Sách Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/my-collections" method="POST">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên giá sách <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" required maxlength="50" placeholder="VD: Truyện trinh thám cày đêm...">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Mô tả ngắn</label>
                            <textarea class="form-control" name="description" rows="2" maxlength="250" placeholder="Sách mua từ năm 2026..."></textarea>
                        </div>
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label fw-bold">Quyền riêng tư</label>
                                <select class="form-select" name="isPublic">
                                    <option value="1">Công khai (Mọi người có thể xem)</option>
                                    <option value="0">Riêng tư (Chỉ mình tôi)</option>
                                </select>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label fw-bold">Màu đại diện</label>
                                <input type="color" class="form-control form-control-color w-100" name="coverColor" value="#C92127">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn text-white fw-bold" style="background-color: #C92127;">Tạo ngay</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-pen-to-square text-primary me-2"></i>Sửa Giá Sách</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/my-collections" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="collectionId" id="edit_id">
                    
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên giá sách <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" id="edit_name" required maxlength="50">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Mô tả ngắn</label>
                            <textarea class="form-control" name="description" id="edit_desc" rows="2" maxlength="250"></textarea>
                        </div>
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label fw-bold">Quyền riêng tư</label>
                                <select class="form-select" name="isPublic" id="edit_public">
                                    <option value="1">Công khai</option>
                                    <option value="0">Riêng tư</option>
                                </select>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label fw-bold">Màu đại diện</label>
                                <input type="color" class="form-control form-control-color w-100" name="coverColor" id="edit_color">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary fw-bold">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="component/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function openEditModal(id, name, desc, isPublic, color) {
            document.getElementById('edit_id').value = id;
            document.getElementById('edit_name').value = name;
            
            
            if (desc !== 'null' && desc !== '') {
                document.getElementById('edit_desc').value = desc;
            } else {
                document.getElementById('edit_desc').value = '';
            }
            
            document.getElementById('edit_public').value = isPublic ? "1" : "0";
            document.getElementById('edit_color').value = color;
            
            // Bật Modal lên
            var editModal = new bootstrap.Modal(document.getElementById('editModal'));
            editModal.show();
        }
    </script>
</body>
</html>