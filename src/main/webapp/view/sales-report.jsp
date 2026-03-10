<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Daily Sales Analytics - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background-color: #f8f9fa; }
        .card-custom { border-radius: 8px; border: none; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .border-left-green { border-left: 5px solid #28a745 !important; }
        .border-left-blue { border-left: 5px solid #007bff !important; }
        .border-left-yellow { border-left: 5px solid #ffc107 !important; }
        .text-green { color: #28a745; }
        .text-blue { color: #007bff; }
        .text-yellow { color: #ffc107; }
    </style>
</head>
<body>
    <div class="container-fluid mt-4 px-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="${pageContext.request.contextPath}/staff-dashboard" class="btn btn-sm btn-outline-secondary mb-2">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại Dashboard
                </a>
                <h2 class="fw-bold mb-0">Daily Sales Analytics</h2>
                <p class="text-muted">Báo cáo hoạt động kinh doanh theo ngày</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/staff/reports" method="GET" class="bg-white p-3 rounded shadow-sm d-flex gap-3 align-items-end">
                <div>
                    <label class="form-label text-muted fw-bold mb-1" style="font-size: 12px;">CHỌN NGÀY</label>
                    <input type="date" name="reportDate" value="${reportDate}" class="form-control">
                </div>
                <button type="submit" class="btn btn-primary px-4 fw-bold">
                    <i class="fa-solid fa-filter me-1"></i> Lọc
                </button>
            </form>
        </div>

        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card card-custom border-left-green p-3">
                    <h6 class="text-muted fw-bold mb-3">DOANH THU TRONG NGÀY</h6>
                    <h3 class="fw-bold text-green mb-0">
                        <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ"/>
                    </h3>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card card-custom border-left-blue p-3">
                    <h6 class="text-muted fw-bold mb-3">TỔNG SỐ ĐƠN</h6>
                    <h3 class="fw-bold text-blue mb-0">${totalOrders}</h3>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card card-custom border-left-yellow p-3">
                    <h6 class="text-muted fw-bold mb-3">ĐƠN HOÀN THÀNH</h6>
                    <h3 class="fw-bold text-yellow mb-0">${completedOrders}</h3>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <div class="card card-custom p-4 h-100">
                    <h6 class="fw-bold mb-4">Xu hướng doanh thu (7 ngày qua)</h6>
                    <canvas id="revenueChart" height="100"></canvas>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card card-custom p-4 h-100">
                    <h6 class="fw-bold mb-4">Trạng thái đơn hàng trong ngày</h6>
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Mẹo bọc biến JSP vào chuỗi ngoặc kép để VS Code không gạch đỏ báo lỗi
        const revLabelsStr = "${revenueLabels}";
        const revDataStr = "${revenueData}";
        const statDataStr = "${statusData}";

        // Chuyển chuỗi về dạng mảng (Array) để Chart.js đọc được
        const revLabels = eval(revLabelsStr);
        const revData = eval(revDataStr);
        const statData = eval(statDataStr);

        // 1. Cấu hình biểu đồ doanh thu (Line Chart)
        const ctxRevenue = document.getElementById('revenueChart').getContext('2d');
        new Chart(ctxRevenue, {
            type: 'line',
            data: {
                labels: revLabels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: revData,
                    borderColor: '#007bff',
                    backgroundColor: 'rgba(0, 123, 255, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.3
                }]
            },
            options: { 
                responsive: true, 
                scales: { 
                    y: { 
                        beginAtZero: true 
                    } 
                } 
            }
        });

        // 2. Cấu hình biểu đồ trạng thái (Doughnut Chart)
        const ctxStatus = document.getElementById('statusChart').getContext('2d');
        new Chart(ctxStatus, {
            type: 'doughnut',
            data: {
                labels: ['Chờ xử lý', 'Đang giao', 'Hoàn thành', 'Đã hủy'],
                datasets: [{
                    data: statData,
                    backgroundColor: ['#ffc107', '#00c0ef', '#28a745', '#dc3545'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                cutout: '65%',
                plugins: { 
                    legend: { position: 'top', labels: { boxWidth: 20 } } 
                }
            }
        });
    </script>
</body>
</html>