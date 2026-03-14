<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Tích Điểm (F-Point) - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>
<body style="background-color: #212529;"> <jsp:include page="../component/header.jsp" />

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="d-flex align-items-center gap-4">
                <a href="${pageContext.request.contextPath}/staff-dashboard" class="btn btn-danger rounded-pill px-4 shadow-sm">
                    <i class="fa-solid fa-chart-line me-2"></i> Về Dashboard
                </a>
                <div class="border-start border-2 border-secondary ps-4">
                    <h2 class="fw-bold text-warning mb-1"><i class="fa-solid fa-coins me-2"></i>Hệ thống F-Point</h2>
                    <p class="text-muted mb-0 text-light">Thao tác cộng/trừ điểm thưởng cho khách hàng</p>
                </div>
            </div>
        </div>

        <div class="row mb-5">
            <div class="col-md-5">
                <div class="card shadow border-secondary bg-dark text-light">
                    <div class="card-header bg-secondary text-white fw-bold py-3 border-0">
                        <i class="fa-solid fa-wand-magic-sparkles me-2"></i> Lệnh Thực Thi Điểm
                    </div>
                    <div class="card-body p-4">
                        <form action="#" method="post">
                            <div class="mb-3">
                                <label class="form-label text-muted">ID Khách hàng / Email:</label>
                                <input type="text" name="userInfo" class="form-control bg-dark text-light border-secondary" placeholder="Nhập ID hoặc Email..." required>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-6">
                                    <label class="form-label text-muted">Thao tác:</label>
                                    <select name="actionType" class="form-select bg-dark text-light border-secondary">
                                        <option value="add">🟢 Cộng điểm (+)</option>
                                        <option value="sub">🔴 Trừ điểm (-)</option>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label class="form-label text-muted">Số lượng:</label>
                                    <input type="number" name="amount" class="form-control bg-dark text-light border-secondary" placeholder="0" min="1" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label text-muted">Lý do (Ghi chú hệ thống):</label>
                                <textarea name="reason" class="form-control bg-dark text-light border-secondary" rows="2" placeholder="VD: Tặng điểm sinh nhật, đền bù lỗi..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-warning w-100 fw-bold mb-2 text-dark"><i class="fa-solid fa-check me-2"></i> Xác nhận thực thi</button>
                            <button type="reset" class="btn btn-outline-secondary w-100 text-light">Nhập lại</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <div class="card shadow border-secondary bg-dark text-light h-100">
                    <div class="card-header bg-secondary text-white fw-bold py-3 border-0 d-flex justify-content-between">
                        <span><i class="fa-solid fa-clock-rotate-left me-2"></i> Lịch sử biến động</span>
                        <button class="btn btn-sm btn-light text-dark"><i class="fa-solid fa-download"></i> Tải Log</button>
                    </div>
                    <div class="card-body p-4">
                        <div class="row g-2 mb-4">
                            <div class="col-md-4"><input type="date" class="form-control bg-dark text-light border-secondary form-control-sm"></div>
                            <div class="col-md-4"><input type="date" class="form-control bg-dark text-light border-secondary form-control-sm"></div>
                            <div class="col-md-3">
                                <select class="form-select bg-dark text-light border-secondary form-select-sm">
                                    <option>Tất cả loại</option>
                                    <option>Chỉ cộng</option>
                                    <option>Chỉ trừ</option>
                                </select>
                            </div>
                            <div class="col-md-1"><button class="btn btn-sm btn-danger w-100"><i class="fa-solid fa-filter"></i></button></div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-dark table-hover align-middle" style="font-size: 14px;">
                                <thead>
                                    <tr class="text-muted text-uppercase">
                                        <th>Thời gian</th>
                                        <th>Khách hàng</th>
                                        <th>Biến động</th>
                                        <th>Lý do</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>12/03/2026 14:20</td>
                                        <td>@sa (#4)</td>
                                        <td class="text-success fw-bold">+ 5,000</td>
                                        <td>Tặng sinh nhật</td>
                                    </tr>
                                    <tr>
                                        <td>10/03/2026 09:15</td>
                                        <td>@quang (#1011)</td>
                                        <td class="text-danger fw-bold">- 1,200</td>
                                        <td>Đổi quà Voucher</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        
                        <nav aria-label="Page navigation">
                            <ul class="pagination pagination-sm justify-content-end mt-3">
                                <li class="page-item disabled"><a class="page-link bg-dark border-secondary text-muted" href="#">Trước</a></li>
                                <li class="page-item active"><a class="page-link bg-danger border-danger text-light" href="#">1</a></li>
                                <li class="page-item"><a class="page-link bg-dark border-secondary text-light" href="#">2</a></li>
                                <li class="page-item"><a class="page-link bg-dark border-secondary text-light" href="#">Sau</a></li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="../component/footer.jsp" />
</body>
</html>