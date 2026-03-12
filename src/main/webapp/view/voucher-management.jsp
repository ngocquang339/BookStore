<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Mã Giảm Giá - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .table-hover tbody tr:hover { background-color: #f1f1f1; }
    </style>
</head>
<body>
    <div class="container-fluid mt-4 px-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
            <a href="${pageContext.request.contextPath}/staff-dashboard" class="btn btn-dark fw-bold d-flex align-items-center gap-2">
                <i class="fa-solid fa-house"></i> Quay lại Dashboard
            </a>
            <h2 class="text-primary m-0 fw-bold">QUẢN LÝ MÃ GIẢM GIÁ (VOUCHER)</h2>
            <button type="button" class="btn btn-success fw-bold" data-bs-toggle="modal" data-bs-target="#addVoucherModal">
                <i class="fa-solid fa-plus"></i> Thêm Voucher
            </button>
        </div>

        <div class="table-responsive bg-white shadow-sm rounded border">
            
            <jsp:useBean id="now" class="java.util.Date" />

            <table class="table table-bordered table-hover align-middle mb-0">
                <thead class="table-dark text-center align-middle">
                    <tr>
                        <th style="width: 5%;">ID</th>
                        <th style="width: 15%;">Mã CODE</th>
                        <th style="width: 15%;">Mức giảm</th>
                        <th style="width: 15%;">Đơn tối thiểu</th>
                        <th style="width: 10%;">Lượt dùng</th>
                        <th style="width: 20%;">Thời hạn</th>
                        <th style="width: 10%;">Trạng thái</th>
                        <th style="width: 10%;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${vouchers}" var="v">
                        <tr>
                            <td class="text-center fw-bold">#${v.id}</td>
                            <td class="text-center"><span class="badge bg-warning text-dark fs-6">${v.code}</span></td>
                            
                            <td class="text-end fw-bold text-danger">
                                <c:choose>
                                    <c:when test="${v.discountPercent > 0}">
                                        ${v.discountPercent}%
                                        <c:if test="${v.maxDiscount > 0}">
                                            <br>
                                            <small class="text-muted fw-normal" style="font-size: 12px;">
                                                (Tối đa <fmt:formatNumber value="${v.maxDiscount}" type="currency" currencySymbol="đ"/>)
                                            </small>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="${v.discountAmount}" type="currency" currencySymbol="đ"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            
                            <td class="text-end fw-bold text-secondary">
                                <fmt:formatNumber value="${v.minOrderValue}" type="currency" currencySymbol="đ"/>
                            </td>
                            
                            <td class="text-center fw-bold">${v.usageLimit}</td>
                            
                            <td class="text-center text-muted">
                                <fmt:formatDate value="${v.startDate}" pattern="dd/MM/yyyy"/> <br> 
                                <i class="fa-solid fa-arrow-down fa-xs"></i> <br>
                                <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy"/>
                            </td>
                            
                            <td class="text-center">
                                <c:choose>
                                    <%-- Ưu tiên 1: Bị tắt thủ công bởi người quản lý (Công tắc cao nhất) --%>
                                    <c:when test="${v.status == 0}">
                                        <span class="badge bg-secondary px-2 py-2" style="width: 100px;">Đã khóa</span>
                                    </c:when>
                                    
                                    <%-- Ưu tiên 2: Bị hết số lượng sử dụng --%>
                                    <c:when test="${v.usageLimit <= 0}">
                                        <span class="badge bg-dark px-2 py-2" style="width: 100px;">Hết lượt</span>
                                    </c:when>
                                    
                                    <%-- Ưu tiên 3: Chưa tới giờ bắt đầu --%>
                                    <c:when test="${v.startDate > now}">
                                        <span class="badge bg-warning text-dark px-2 py-2" style="width: 100px;">Sắp diễn ra</span>
                                    </c:when>
                                    
                                    <%-- Ưu tiên 4: Đã trôi qua hạn chót --%>
                                    <c:when test="${v.endDate < now}">
                                        <span class="badge bg-danger px-2 py-2" style="width: 100px;">Đã hết hạn</span>
                                    </c:when>
                                    
                                    <%-- Còn lại: Mã hoàn toàn khỏe mạnh và đang được dùng --%>
                                    <c:otherwise>
                                        <span class="badge bg-success px-2 py-2" style="width: 100px;">Đang hoạt động</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            
                            <td class="text-center">
                                <div class="d-flex justify-content-center gap-2">
                                <button class="btn btn-sm btn-outline-primary" title="Sửa mã">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
        
                                <button class="btn btn-sm btn-outline-info" title="Xem thống kê">
                                    <i class="fa-solid fa-chart-column"></i>
                                </button>

                                <a href="${pageContext.request.contextPath}/vouchers-management?action=delete&id=${v.id}" class="btn btn-sm btn-outline-danger" title="Xóa mã" onclick="return confirm('Bạn có chắc chắn muốn xóa mã giảm giá [ ${v.code} ] này không? Hành động này không thể hoàn tác!');">
                                    <i class="fa-solid fa-trash-can"></i>
                                    </a>
                                </div>
                                </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty vouchers}">
                        <tr>
                            <td colspan="8" class="text-center py-4 text-muted">
                                Chưa có mã giảm giá nào trong hệ thống.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="addVoucherModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/vouchers-management" method="POST">
                    <div class="modal-header bg-dark text-white">
                        <h5 class="modal-title fw-bold"><i class="fa-solid fa-ticket me-2"></i>Thêm Mã Giảm Giá Mới</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Mã Code (VD: FREESHIP)</label>
                            <input type="text" name="code" class="form-control border-primary" required style="text-transform: uppercase;">
                        </div>
                        
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label fw-bold">Loại giảm giá</label>
                                <select name="discountType" id="discountTypeSelect" class="form-select border-primary" required>
                                    <option value="1">Giảm Số tiền (đ)</option>
                                    <option value="2">Giảm Phần trăm (%)</option>
                                </select>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label fw-bold">Mức giảm</label>
                                <input type="number" name="discountValue" class="form-control" required min="1">
                            </div>
                            
                            <div class="col-12 mb-3" id="maxDiscountBox" style="display: none;">
                                <label class="form-label fw-bold">Giảm tối đa (VNĐ)</label>
                                <input type="number" name="maxDiscount" id="maxDiscountInput" class="form-control" placeholder="Bỏ trống nếu không giới hạn">
                                <small class="text-muted">* Chỉ áp dụng khi chọn giảm theo Phần trăm (%)</small>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Áp dụng cho đơn tối thiểu từ (VNĐ)</label>
                            <input type="number" name="minOrderValue" class="form-control" required min="0">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Số lượng phát hành</label>
                            <input type="number" name="usageLimit" class="form-control" required min="1">
                        </div>
                        
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label fw-bold">Từ ngày</label>
                                <input type="date" name="startDate" class="form-control" required>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label fw-bold">Đến ngày</label>
                                <input type="date" name="endDate" class="form-control" required>
                            </div>
                        </div>
                        
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success fw-bold">Lưu Voucher</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Xử lý Ẩn/Hiện ô nhập "Mức giảm tối đa" khi đổi loại giảm giá
        document.getElementById('discountTypeSelect').addEventListener('change', function() {
            let maxDiscountBox = document.getElementById('maxDiscountBox');
            let maxDiscountInput = document.getElementById('maxDiscountInput');
            
            if (this.value === '2') { 
                // Nếu chọn loại 2 (Giảm %) -> Hiện ô nhập tối đa
                maxDiscountBox.style.display = 'block';
            } else { 
                // Nếu chọn loại 1 (Giảm tiền) -> Ẩn ô nhập tối đa và xóa dữ liệu thừa
                maxDiscountBox.style.display = 'none';
                maxDiscountInput.value = ''; 
            }
        });
    </script>
</body>
</html>