<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <title>Sales Reports</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

            <style>
                /* FIX: Force standard font to prevent Cursive fallback */
                body,
                h1,
                h2,
                h3,
                h4,
                h5,
                h6,
                p,
                a,
                span,
                div {
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif !important;
                }

                .chart-container {
                    background: white;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
                    margin-bottom: 20px;
                }

                .charts-grid {
                    display: grid;
                    grid-template-columns: 2fr 1fr;
                    /* Revenue chart is wider */
                    gap: 20px;
                }

                /* BACK LINK STYLE */
                .back-link {
                    display: inline-flex;
                    align-items: center;
                    text-decoration: none;
                    color: #6c757d;
                    /* Grey text */
                    font-weight: 600;
                    margin-bottom: 20px;
                    font-size: 16px;
                    transition: color 0.3s ease;
                }

                .back-link i {
                    margin-right: 8px;
                    /* Space between arrow and text */
                }

                .back-link:hover {
                    color: #0d6efd;
                    /* Blue on hover */
                    text-decoration: underline;
                }
            </style>
        </head>

        <body>

            <div class="page-container">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">
                    <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
                </a>

                <button onclick="exportToPDF()" class="btn-add-new"
                    style="background-color: #dc3545; border:none; cursor:pointer; color:white; padding:10px 15px; border-radius:5px;">
                    <i class="fa-solid fa-file-pdf"></i> Export to PDF
                </button>

                <h1><i class="fa-solid fa-chart-line"></i> Sales Analytics</h1>

                <div class="charts-grid">
                    <div class="chart-container">
                        <h3>Revenue (Last 7 Days)</h3>
                        <canvas id="revenueChart"></canvas>
                    </div>

                    <div class="chart-container">
                        <h3>Top 5 Best Sellers</h3>
                        <canvas id="booksChart"></canvas>
                    </div>
                </div>
            </div>

            <script>
                // --- 1. REVENUE CHART CONFIG ---
                const ctxRev = document.getElementById('revenueChart');
                new Chart(ctxRev, {
                    type: 'line', // Line graph for trends
                    data: {
                        labels: [${ chartDates }], // From Servlet
                        datasets: [{
                            label: 'Revenue (VND)',
                            data: [${ chartRevenue }], // From Servlet
                            borderColor: '#0d6efd',
                            backgroundColor: 'rgba(13, 110, 253, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            tension: 0.3 // Makes the line curved and smooth
                        }]
                    },
                    options: {
                        scales: {
                            y: { beginAtZero: true }
                        }
                    }
                });

                // --- 2. TOP BOOKS CHART CONFIG ---
                const ctxBooks = document.getElementById('booksChart');
                new Chart(ctxBooks, {
                    type: 'doughnut', // Doughnut chart for distribution
                    data: {
                        labels: [${ chartBooks }], // From Servlet
                        datasets: [{
                            label: 'Sold Quantity',
                            data: [${ chartSold }], // From Servlet
                            backgroundColor: [
                                '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF'
                            ],
                            hoverOffset: 4
                        }]
                    }
                });

                function exportToPDF() {
                    // 1. Select the content to print (The entire container)
                    const element = document.querySelector(".page-container");

                    // 2. Hide the buttons so they don't appear in the PDF
                    const btn = document.querySelector("button[onclick='exportToPDF()']");
                    const link = document.querySelector(".back-link");
                    btn.style.display = 'none';
                    link.style.display = 'none';

                    // 3. Configure settings
                    const opt = {
                        margin: 0.5,
                        filename: 'Sales_Report.pdf',
                        image: { type: 'jpeg', quality: 0.98 },
                        html2canvas: { scale: 2 }, // Higher scale = sharper text/charts
                        jsPDF: { unit: 'in', format: 'letter', orientation: 'landscape' } // Landscape is better for charts
                    };

                    // 4. Generate PDF, then show buttons again
                    html2pdf().set(opt).from(element).save().then(() => {
                        btn.style.display = 'block';
                        link.style.display = 'flex'; // or 'inline-block' depending on your css
                    });
                }
            </script>

        </body>

        </html>