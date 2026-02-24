<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Sales Analytics | Admin</title>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <style>
                    /* --- 1. GLOBAL FONT RESET (Fixes the Cursive Font Issue) --- */
                    body,
                    h1,
                    h2,
                    h3,
                    h4,
                    h5,
                    h6,
                    p,
                    span,
                    div,
                    label,
                    input,
                    button {
                        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif !important;
                    }

                    /* --- 2. PAGE LAYOUT --- */
                    body {
                        background-color: #f8f9fa;
                        margin: 0;
                        padding: 20px;
                    }

                    .page-container {
                        max-width: 1200px;
                        margin: 0 auto;
                    }

                    /* --- 3. FORM STYLING (Date Pickers & Button) --- */
                    .filter-form {
                        display: flex;
                        gap: 15px;
                        background: white;
                        padding: 15px 20px;
                        border-radius: 8px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                        align-items: flex-end;
                    }

                    .form-group {
                        display: flex;
                        flex-direction: column;
                    }

                    .form-label {
                        font-size: 12px;
                        font-weight: 700;
                        color: #555;
                        margin-bottom: 5px;
                        text-transform: uppercase;
                    }

                    .form-control {
                        padding: 8px 12px;
                        border: 1px solid #ced4da;
                        border-radius: 5px;
                        font-size: 14px;
                        color: #495057;
                        outline: none;
                        transition: border-color 0.15s ease-in-out;
                    }

                    .form-control:focus {
                        border-color: #86b7fe;
                        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
                    }

                    .btn-update {
                        background-color: #0d6efd;
                        color: white;
                        border: none;
                        padding: 9px 20px;
                        border-radius: 5px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: background-color 0.2s;
                        height: 38px;
                        /* Match input height */
                    }

                    .btn-update:hover {
                        background-color: #0b5ed7;
                    }

                    /* --- 4. CARD & CHART STYLING --- */
                    .stat-card {
                        background: white;
                        padding: 20px;
                        border-radius: 8px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                    }

                    .chart-container {
                        background: white;
                        padding: 20px;
                        border-radius: 8px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                    }

                    /* Add this inside the <style> tag */
                    a[href*="dashboard"]:hover {
                        color: #0d6efd !important;
                        /* Bootstrap Blue */
                    }
                </style>
            </head>

            <body>

                <div class="page-container">

                    <div style="margin-bottom: 15px;">
                        <a href="${pageContext.request.contextPath}/admin/dashboard"
                            style="text-decoration: none; color: #6c757d; font-weight: 600; font-size: 14px; display: inline-flex; align-items: center; gap: 5px; transition: color 0.2s;">
                            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>
                    <div
                        style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 25px;">
                        <div>
                            <h2 style="margin: 0; color: #343a40; font-weight: 700;">Sales Analytics</h2>
                            <p style="margin: 5px 0 0; color: #6c757d; font-size: 14px;">Overview of store performance
                            </p>
                        </div>

                        <form action="reports" method="get" class="filter-form">
                            <div class="form-group">
                                <label class="form-label">From Date</label>
                                <input type="date" name="fromDate" value="${fromDate}" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">To Date</label>
                                <input type="date" name="toDate" value="${toDate}" class="form-control" required>
                            </div>
                            <button type="submit" class="btn-update">
                                <i class="fa-solid fa-sync"></i> Update
                            </button>
                        </form>
                    </div>

                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px;">
                        <div class="stat-card" style="border-left: 4px solid #198754;">
                            <h6
                                style="color: #6c757d; margin: 0; font-size: 12px; font-weight: 700; text-transform: uppercase;">
                                Total Revenue (Period)</h6>
                            <h3 style="margin: 10px 0 0; color: #198754; font-weight: 700;">
                                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ"
                                    maxFractionDigits="0" />
                            </h3>
                        </div>
                        <div class="stat-card" style="border-left: 4px solid #0d6efd;">
                            <h6
                                style="color: #6c757d; margin: 0; font-size: 12px; font-weight: 700; text-transform: uppercase;">
                                Total Orders</h6>
                            <h3 style="margin: 10px 0 0; color: #0d6efd; font-weight: 700;">${totalOrders}</h3>
                        </div>
                        <div class="stat-card" style="border-left: 4px solid #ffc107;">
                            <h6
                                style="color: #6c757d; margin: 0; font-size: 12px; font-weight: 700; text-transform: uppercase;">
                                Completed Orders</h6>
                            <h3 style="margin: 10px 0 0; color: #ffc107; font-weight: 700;">${completedOrders}</h3>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px;">

                        <div class="chart-container">
                            <h5 style="margin-bottom: 20px; font-weight: 700;">Revenue Trend</h5>
                            <canvas id="revenueChart" height="150"></canvas>
                        </div>

                        <div class="chart-container">
                            <h5 style="margin-bottom: 20px; font-weight: 700;">Order Status</h5>
                            <canvas id="statusChart" height="200"></canvas>
                        </div>

                        <div class="chart-container" style="grid-column: 1 / -1;">
                            <h5 style="margin-bottom: 20px; font-weight: 700;">Top 5 Best Selling Books</h5>
                            <canvas id="bestSellerChart" height="80"></canvas>
                        </div>

                    </div>
                </div>

                <script>
                    // 1. REVENUE CHART
                    const ctxRevenue = document.getElementById('revenueChart').getContext('2d');
                    new Chart(ctxRevenue, {
                        type: 'line',
                        data: {
                            labels: ${ dateLabels },
                        datasets: [{
                            label: 'Revenue (VND)',
                            data: ${ revenueData },
                        borderColor: '#0d6efd',
                        backgroundColor: 'rgba(13, 110, 253, 0.1)',
                        fill: true,
                        tension: 0.3
            }]
        },
                        options: {
                        scales: { y: { beginAtZero: true } }
                    }
    });

                    // 2. STATUS CHART
                    const ctxStatus = document.getElementById('statusChart').getContext('2d');
                    new Chart(ctxStatus, {
                        type: 'doughnut',
                        data: {
                            labels: ['Pending', 'Shipping', 'Completed', 'Cancelled'],
                            datasets: [{
                                data: ${ statusCounts },
                                backgroundColor: ['#ffc107', '#0dcaf0', '#198754', '#dc3545']
            }]
                    }
    });

                    // 3. BEST SELLERS CHART (FIXED: INTEGERS ONLY)
                    const ctxSeller = document.getElementById('bestSellerChart').getContext('2d');
                    new Chart(ctxSeller, {
                        type: 'bar',
                        data: {
                            labels: ${ bookLabels },
                        datasets: [{
                            label: 'Units Sold',
                            data: ${ bookData },
                        backgroundColor: '#6610f2'
            }]
        },
                        options: {
                        indexAxis: 'y',
                        scales: {
                            x: {
                                beginAtZero: true,
                                // --- FIX IS HERE: FORCE INTEGERS ---
                                ticks: {
                                    stepSize: 1,  // Only show 1, 2, 3...
                                    precision: 0  // No decimals
                                }
                            }
                        }
                    }
    });
                </script>

            </body>

            </html>