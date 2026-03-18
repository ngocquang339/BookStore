<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Mã Giảm Giá Mới - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Căn giữa toàn bộ trang, làm nền tối màu để làm nổi bật Form */
        body { 
            background-color: #6c757d; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            min-height: 100vh; 
            margin: 0; 
            padding: 20px;
        }
        
        /* Cấu trúc thẻ Card y hệt Modal trong ảnh */
        .voucher-card { 
            width: 100%; 
            max-width: 550px; 
            background: #fff; 
            border-radius: 8px; 
            overflow: hidden; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.3); 
        }
        
        /* HEADER: Nền đen, chữ trắng */
        .v-header { 
            background: #212529; 
            color: white; 
            padding: 15px 20px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        .v-header h5 { margin: 0; font-weight: bold; font-size: 18px; }
        .btn-close-white { filter: invert(1) grayscale(100%) brightness(200%); }
        
        /* BODY: Nền xám nhạt */
        .v-body { padding: 20px; background: #f8f9fa; }
        
        /* FOOTER: Nền xám xám chứa nút bấm */
        .v-footer { 
            padding: 15px 20px; 
            background: #e9ecef; 
            display: flex; 
            justify-content: flex-end; 
            gap: 10px; 
            border-top: 1px solid #dee2e6; 
        }

        /* Định dạng lại chữ và ô nhập liệu */
        .form-label { font-weight: bold; color: #333; font-size: 14px; margin-bottom: 5px; }
        .form-control, .form-select { 
            border-radius: 6px; 
            border: 1px solid #ced4da; 
            padding: 10px; 
            font-size: 14px; 
        }
        .form-control:focus, .form-select:focus { 
            border-color: #198754; 
            box-shadow: 0 0 0 0.25rem rgba(25, 135, 84, 0.25); 
        }
    </style>
</head>
<body>

    <div class="voucher-card">
        <form action="${pageContext.request.contextPath}/vouchers-management" method="POST" id="addVoucherForm">
            
            <div class="v-header">
                <h5><i class="fa-solid fa-ticket"></i> Thêm Mã Giảm Giá Mới</h5>
                <a href="${pageContext.request.contextPath}/vouchers-management" class="btn-close btn-close-white" aria-label="Close"></a>
            </div>

            <div class="v-body">
                <div class="mb-3">
                    <label class="form-label">Mã Code (VD: FREESHIP)</label>
                    <input type="text" name="code" class="form-control" required style="text-transform: uppercase;">
                </div>

                <div class="row mb-3">
                    <div class="col-6">
                        <label class="form-label">Loại giảm giá</label>
                        <select name="discountType" id="discountTypeSelect" class="form-select" required>
                            <option value="1">Giảm Số tiền (đ)</option>
                            <option value="2">Giảm Phần trăm (%)</option>
                        </select>
                    </div>
                    <div class="col-6">
                        <label class="form-label">Mức giảm</label>
                        <input type="number" name="discountValue" class="form-control" required min="1">
                    </div>
                    
                    <div class="col-12 mt-3" id="maxDiscountBox" style="display: none;">
                        <label class="form-label">Giảm tối đa (VNĐ)</label>
                        <input type="number" name="maxDiscount" id="maxDiscountInput" class="form-control" placeholder="Bỏ trống nếu không giới hạn">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Áp dụng cho đơn tối thiểu từ (VNĐ)</label>
                    <input type="number" name="minOrderValue" class="form-control" required min="0">
                </div>

                <div class="mb-3">
                    <label class="form-label">Số lượng phát hành</label>
                    <input type="number" name="usageLimit" class="form-control" required min="1">
                </div>

                <div class="row">
                    <div class="col-6">
                        <label class="form-label">Từ ngày</label>
                        <input type="date" name="startDate" id="startDate" class="form-control" required>
                    </div>
                    <div class="col-6">
                        <label class="form-label">Đến ngày</label>
                        <input type="date" name="endDate" id="endDate" class="form-control" required>
                    </div>
                </div>
            </div>

            <div class="v-footer">
                <a href="${pageContext.request.contextPath}/vouchers-management" class="btn btn-secondary px-4">Hủy</a>
                <button type="submit" class="btn btn-success px-4 fw-bold">Lưu Voucher</button>
            </div>

        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // JS 1: Ẩn/Hiện ô nhập "Mức giảm tối đa" khi đổi dropdown
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

        // JS 2: Bắt lỗi Validation ngày tháng trước khi Submit
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