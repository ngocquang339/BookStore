<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Manage Return Requests</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* A simple, clean table style for your dashboard */
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .admin-table th,
        .admin-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }

        .admin-table th {
            background-color: #343a40; /* Updated to dark grey to match orders */
            font-weight: bold;
            color: #fff;
        }

        .badge {
            display: inline-block;
            white-space: nowrap;
            padding: 6px 12px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            text-align: center;
            vertical-align: middle;
        }

        .badge-pending { background-color: #ffc107; color: #000; }
        .badge-approved { background-color: #198754; color: white; }
        .badge-rejected { background-color: #dc3545; color: white; }
        .badge-action { background-color: #0dcaf0; color: #000; }

        .btn-review {
            background: #0d6efd;
            color: white;
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 4px;
            font-size: 0.9em;
            white-space: nowrap;
            display: inline-block;
        }

        .btn-review:hover { background: #0b5ed7; }

        /* Filter Bar Styles */
        .filter-container {
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            display: inline-block;
        }

        .filter-select {
            padding: 8px 12px;
            border-radius: 4px;
            border: 1px solid #ced4da;
            font-size: 0.95rem;
            outline: none;
            min-width: 250px;
        }
        
        .filter-select:focus {
            border-color: #86b7fe;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
    </style>
</head>

<body style="background-color: #f4f6f9; font-family: Arial, sans-serif; padding: 20px;">

    <div style="margin-bottom: 20px;">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link"
            style="text-decoration: none; color: #2c3e50; font-weight: 600; font-size: 0.95rem;">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <h2><i class="fa-solid fa-rotate-left"></i> Customer Return Requests</h2>

    <div class="filter-container">
        <label for="statusFilter" style="font-weight: bold; margin-right: 10px; color: #495057;">Filter by Status:</label>
        <select id="statusFilter" class="filter-select" onchange="filterTable()">
            <option value="all">All Statuses</option>
            <option value="1">Pending Review</option>
            <option value="2">Action Required</option>
            <option value="3">Approved (Awaiting Item)</option>
            <option value="4">Failed QC</option>
            <option value="5">Refunded (Returned)</option>
            <option value="6">Rejected Upfront</option>
            <option value="7">Refunded (Keeps Item)</option>
            <option value="8">Ready for Refund (Passed QC)</option>
        </select>
    </div>

    <table class="admin-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Order #</th>
                <th>Customer</th>
                <th>Book Details</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody id="returnsTableBody">
            <c:forEach items="${returnList}" var="r">
                <tr class="return-row" data-status="${r.status}">
                    <td>#${r.returnId}</td>
                    <td><a href="${pageContext.request.contextPath}/admin/order/detail?id=${r.orderId}">${r.orderId}</a></td>
                    <td>${r.customerName}</td>
                    <td>
                        <strong>${r.bookTitle}</strong><br>
                        <span style="color: #666; font-size: 0.85em;">Qty: ${r.quantity} | Pref: ${r.refundPreference}</span>
                    </td>
                    <td style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${r.customerReason}">
                        ${r.customerReason}
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${r.status == 1}"><span class="badge badge-pending">Pending Review</span></c:when>
                            <c:when test="${r.status == 2}"><span class="badge badge-action">Action Required</span></c:when>
                            <c:when test="${r.status == 3}"><span class="badge badge-approved">Approved (Awaiting Item)</span></c:when>
                            <c:when test="${r.status == 4}"><span class="badge badge-rejected">Failed QC</span></c:when>
                            <c:when test="${r.status == 5}"><span class="badge badge-success" style="background-color: #198754; color: white;">Refunded (Returned)</span></c:when>
                            <c:when test="${r.status == 6}"><span class="badge badge-rejected">Rejected Upfront</span></c:when>
                            <c:when test="${r.status == 7}"><span class="badge badge-success" style="background-color: #198754; color: white;">Refunded (Keeps Item)</span></c:when>
                            <c:when test="${r.status == 8}"><span class="badge" style="background-color: #0dcaf0; color: #000;">Ready for Refund</span></c:when>
                            <c:otherwise><span class="badge" style="background-color: #6c757d; color: white;">Unknown</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/returns/review?id=${r.returnId}" class="btn-review">
                            Review <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty returnList}">
                <tr>
                    <td colspan="7" style="text-align: center; color: #888; padding: 30px;">No return requests found.</td>
                </tr>
            </c:if>
            
            <tr id="noMatchRow" style="display: none;">
                <td colspan="7" style="text-align: center; color: #888; padding: 30px;">No returns match the selected filter.</td>
            </tr>
        </tbody>
    </table>

    <script>
        function filterTable() {
            // Get the selected status from the dropdown
            const filterValue = document.getElementById("statusFilter").value;
            // Get all table rows that represent returns
            const rows = document.querySelectorAll(".return-row");
            const noMatchRow = document.getElementById("noMatchRow");
            let visibleCount = 0;

            // Loop through each row
            rows.forEach(row => {
                const rowStatus = row.getAttribute("data-status");
                
                // If "all" is selected OR the row's status matches the dropdown
                if (filterValue === "all" || rowStatus === filterValue) {
                    row.style.display = ""; // Show row
                    visibleCount++;
                } else {
                    row.style.display = "none"; // Hide row
                }
            });

            // Show "No matches" message if the filter hides everything
            if (visibleCount === 0 && rows.length > 0) {
                noMatchRow.style.display = "";
            } else {
                noMatchRow.style.display = "none";
            }
        }
    </script>
</body>
</html>