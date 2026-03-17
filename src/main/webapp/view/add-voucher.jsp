<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Mã Giảm Giá Mới - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
    </style>
</head>
<body>
    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                
                <div class="card shadow-lg border-0 rounded-3">
                    <div class="card-header bg-success text-white py-3">
                        <h4 class="mb-0 fw-bold"><i class="fa-solid fa-ticket me-2"></i>Thêm Mã Giảm Giá Mới</h4>
                    </div>
                    
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/vouchers-management" method="POST" id="addVoucherForm">
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold">Mã Code (VD: FREESHIP)</label>
                                <input type="text" name="code" class="form-control form-control-lg border-success" required style="text-transform: uppercase;" placeholder="Nhập mã code tại đây...">
                            </div>
                            
                            <div class="row bg-light p-3 rounded mb-4 border">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Loại giảm giá</label>
                                    <select name="discountType" id="discountTypeSelect" class="form-select" required>
                                        <option value="1">Giảm Số tiền (đ)</option>
                                        <option value="2">Giảm Phần trăm (%)</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Mức giảm</label>
                                    <input type="number" name="discountValue" class="form-control" required min="1">
                                </div>
                                
                                <div class="col-12" id="maxDiscountBox" style="display: none;">
                                    <label class="form-label fw-bold">Giảm tối đa (VNĐ)</label>
                                    <input type="number" name="maxDiscount" id="maxDiscountInput" class="form-control border-warning" placeholder="Bỏ trống nếu không giới hạn">
                                    <small class="text-danger mt-1 d-block"><i class="fa-solid fa-circle-info fa-sm"></i> Chỉ áp dụng khi chọn giảm theo Phần trăm (%)</small>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Áp dụng cho đơn tối thiểu từ (VNĐ)</label>
                                    <input type="number" name="minOrderValue" class="form-control" required min="0" value="0">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Số lượng phát hành</label>
                                    <input type="number" name="usageLimit" class="form-control" required min="1" value="100">
                                </div>
                            </div>
                            
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Từ ngày</label>
                                    <input type="date" name="startDate" id="startDate" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Đến ngày</label>
                                    <input type="date" name="endDate" id="endDate" class="form-control" required>
                                </div>
                            </div>
                            
                            <hr class="mb-4">
                            
                            <div class="d-flex justify-content-between align-items-center">
                                <a href="${pageContext.request.contextPath}/vouchers-management" class="btn btn-outline-secondary px-4 fw-bold">
                                    <i class="fa-solid fa-arrow-left me-2"></i> Quay lại danh sách
                                </a>
                                <button type="submit" class="btn btn-success btn-lg px-5 fw-bold shadow-sm">
                                    Lưu Voucher <i class="fa-solid fa-check ms-2"></i>
                                </button>
                            </div>
                            
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Ẩn/Hiện ô nhập "Mức giảm tối đa"
        document.getElementById('discountTypeSelect').addEventListener('change', function() {
            let maxDiscountBox = document.getElementById('maxDiscountBox');
            let maxDiscountInput = document.getElementById('maxDiscountInput');
            
            if (this.value === '2') { 
                maxDiscountBox.style.display = 'block';
            } else { 
                maxDiscountBox.style.display = 'none';
                maxDiscountInput.value = ''; 
            }
        });

        // Chặn lỗi người dùng chọn ngày kết thúc bé hơn ngày bắt đầu
        document.getElementById('addVoucherForm').addEventListener('submit', function(event) {
            let startDate = document.getElementById('startDate').value;
            let endDate = document.getElementById('endDate').value;
            
            if (startDate && endDate) {
                let start = new Date(startDate);
                let end = new Date(endDate);
                
                if (end < start) {
                    event.preventDefault(); 
                    alert('LỖI: Ngày kết thúc không được phép nhỏ hơn Ngày bắt đầu!');
                }
            }
        });
    </script>
</body>
</html>