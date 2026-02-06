<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <title>Order Management</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage-orders.css?v=1">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>

                <div class="page-container">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">
                        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
                    </a>

                    <div class="header-actions">
                        <h1><i class="fa-solid fa-cart-shopping"></i> Order Management</h1>
                    </div>

                    <c:choose>
                        <c:when test="${empty listOrders}">
                            <div class="empty-state">
                                <i class="fa-solid fa-box-open"></i>
                                <p>No orders found yet.</p>
                                <small>When customers checkout, their orders will appear here.</small>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="table-responsive">
                                <div class="filter-bar"
                                    style="display:flex; gap:10px; margin-bottom: 20px; align-items:center; background:#f8f9fa; padding:15px; border-radius:8px;">
                                    <div style="display:flex; flex-direction:column;">
                                        <label style="font-size:12px; font-weight:bold; margin-bottom:2px;">From
                                            Date</label>
                                        <input type="date" id="dateFrom" class="form-control" onchange="filterOrders()">
                                    </div>

                                    <div style="display:flex; flex-direction:column;">
                                        <label style="font-size:12px; font-weight:bold; margin-bottom:2px;">To
                                            Date</label>
                                        <input type="date" id="dateTo" class="form-control" onchange="filterOrders()">
                                    </div>

                                    <div style="display:flex; flex-direction:column;">
                                        <label
                                            style="font-size:12px; font-weight:bold; margin-bottom:2px;">Status</label>
                                        <select id="statusFilter" class="form-control"
                                            style="width:150px; height: 38px;" onchange="filterOrders()">
                                            <option value="all">All Statuses</option>
                                            <option value="pending">Pending</option>
                                            <option value="shipping">Shipping</option>
                                            <option value="completed">Completed</option>
                                            <option value="cancelled">Cancelled</option>
                                        </select>
                                    </div>

                                    <div style="display:flex; flex-direction:column; justify-content: flex-end;">
                                        <button onclick="resetFilters()" class="btn-sm"
                                            style="background:#6c757d; color:white; border:none; padding:10px 15px; cursor:pointer; height: 38px; border-radius:4px; margin-top: 18px;">
                                            <i class="fa-solid fa-rotate-right"></i> Reset
                                        </button>
                                    </div>
                                </div>
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th onclick="sortTable(0)">Order ID</th>
                                            <th onclick="sortTable(1)">Customer</th>
                                            <th onclick="sortTable(2)">Order Date</th>
                                            <th onclick="sortTable(3)">Total Amount</th>
                                            <th onclick="sortTable(4)">Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${listOrders}" var="o">
                                            <tr>
                                                <td>#${o.id}</td>
                                                <td>
                                                    <strong>${o.userName}</strong><br>
                                                    <span style="font-size: 0.9em; color: #666;">${o.phoneNumber}</span>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${o.orderDate}"
                                                        pattern="MMM dd, yyyy HH:mm" />
                                                </td>
                                                <td style="font-weight: bold; color: #C92127;">
                                                    <fmt:formatNumber value="${o.totalAmount}" type="currency"
                                                        currencySymbol="đ" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${o.status == 1}"><span
                                                                class="status-badge status-1">Pending</span></c:when>
                                                        <c:when test="${o.status == 2}"><span
                                                                class="status-badge status-2">Shipping</span></c:when>
                                                        <c:when test="${o.status == 3}"><span
                                                                class="status-badge status-3">Completed</span></c:when>
                                                        <c:when test="${o.status == 4}"><span
                                                                class="status-badge status-4">Cancelled</span></c:when>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/admin/order/detail?id=${o.id}"
                                                        class="btn-view">
                                                        <i class="fa-solid fa-eye"></i> View
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
                <script>
                    function filterOrders() {
                        // 1. Get Input Values
                        let fromInput = document.getElementById("dateFrom").value;
                        let toInput = document.getElementById("dateTo").value;
                        let statusFilter = document.getElementById("statusFilter").value.toLowerCase();

                        let fromDate = fromInput ? new Date(fromInput) : null;
                        let toDate = toInput ? new Date(toInput) : null;

                        // Set 'To Date' to end of day (23:59:59) so it includes orders from that specific day
                        if (toDate) toDate.setHours(23, 59, 59);

                        // 2. Get Table Rows
                        let table = document.querySelector(".admin-table");
                        let tr = table.getElementsByTagName("tr");

                        // 3. Loop through rows (Start at 1 to skip Header)
                        for (let i = 1; i < tr.length; i++) {
                            let showRow = true;

                            // --- IMPORTANT: ADJUST THESE NUMBERS IF FILTER DOESN'T WORK ---
                            // Look at your table headers. If Date is the 3rd column, use index 2.
                            let dateCell = tr[i].getElementsByTagName("td")[2]; // Index 2 = 3rd Column
                            let statusCell = tr[i].getElementsByTagName("td")[4]; // Index 4 = 5th Column

                            if (dateCell && statusCell) {
                                let rowDateStr = dateCell.innerText.trim();
                                let rowStatus = statusCell.innerText.trim().toLowerCase();
                                let rowDate = new Date(rowDateStr);

                                // A. Check Status
                                if (statusFilter !== 'all' && !rowStatus.includes(statusFilter)) {
                                    showRow = false;
                                }

                                // B. Check Date Range
                                if (fromDate && rowDate < fromDate) showRow = false;
                                if (toDate && rowDate > toDate) showRow = false;
                            }

                            // 4. Toggle Visibility
                            tr[i].style.display = showRow ? "" : "none";
                        }
                    }

                    function resetFilters() {
                        document.getElementById("dateFrom").value = "";
                        document.getElementById("dateTo").value = "";
                        document.getElementById("statusFilter").value = "all";
                        filterOrders(); // Re-run to show all
                    }

                    /**
 * Universal Table Sorter
 * n = Column Index (0, 1, 2...)
 */
                    function sortTable(n) {
                        var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
                        table = document.querySelector(".admin-table");
                        switching = true;
                        dir = "asc"; // Set the sorting direction to ascending:

                        while (switching) {
                            switching = false;
                            rows = table.rows;

                            // Loop through all table rows (except the header)
                            for (i = 1; i < (rows.length - 1); i++) {
                                shouldSwitch = false;

                                // Get the two elements to compare
                                x = rows[i].getElementsByTagName("TD")[n];
                                y = rows[i + 1].getElementsByTagName("TD")[n];

                                // CLEAN DATA for accurate comparison
                                // 1. Get text
                                var xContent = x.innerText.toLowerCase();
                                var yContent = y.innerText.toLowerCase();

                                // 2. Remove Currency symbols ($) and commas if present
                                var xNum = parseFloat(xContent.replace(/[^0-9.-]+/g, ""));
                                var yNum = parseFloat(yContent.replace(/[^0-9.-]+/g, ""));

                                // 3. Check if it's a valid Number/Currency
                                var isNumeric = !isNaN(xNum) && !isNaN(yNum) && xContent.length > 0;

                                if (dir == "asc") {
                                    if (isNumeric) {
                                        if (xNum > yNum) { shouldSwitch = true; break; }
                                    } else {
                                        if (xContent > yContent) { shouldSwitch = true; break; }
                                    }
                                } else if (dir == "desc") {
                                    if (isNumeric) {
                                        if (xNum < yNum) { shouldSwitch = true; break; }
                                    } else {
                                        if (xContent < yContent) { shouldSwitch = true; break; }
                                    }
                                }
                            }

                            if (shouldSwitch) {
                                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                                switching = true;
                                switchcount++;
                            } else {
                                if (switchcount == 0 && dir == "asc") {
                                    dir = "desc";
                                    switching = true;
                                }
                            }
                        }
                    }
                </script>

            </body>

            </html>