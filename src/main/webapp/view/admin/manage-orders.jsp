<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>


            <!DOCTYPE html>
            <html lang="en">

            <head>
                <title>Order Management</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage-orders.css?v=2">
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
                    <form action="order" method="get" class="filter-bar"
                        style="display:flex; gap:15px; margin-bottom: 20px; align-items:flex-end; background:#f8f9fa; padding:20px; border-radius:8px; flex-wrap: wrap; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">

                        <div style="display:flex; flex-direction:column; flex-grow: 1; min-width: 250px;">
                            <label style="font-size:12px; font-weight:bold; margin-bottom:5px; color: #555;">Search
                                Order</label>
                            <div style="position: relative;">
                                <input type="text" name="keyword" value="${keyword}" class="form-control"
                                    placeholder="Enter ID, Customer Name or Phone..."
                                    style="width: 100%; padding-left: 35px; height: 38px; border: 1px solid #ced4da; border-radius: 4px;">
                                <i class="fa-solid fa-magnifying-glass"
                                    style="position: absolute; left: 12px; top: 11px; color: #999;"></i>
                            </div>
                        </div>

                        <div style="display:flex; flex-direction:column; min-width: 140px;">
                            <label style="font-size:12px; font-weight:bold; margin-bottom:5px; color: #555;">From
                                Date</label>
                            <input type="date" name="fromDate" value="${fromDate}" class="form-control"
                                style="height: 38px; border: 1px solid #ced4da; border-radius: 4px;">
                        </div>

                        <div style="display:flex; flex-direction:column; min-width: 140px;">
                            <label style="font-size:12px; font-weight:bold; margin-bottom:5px; color: #555;">To
                                Date</label>
                            <input type="date" name="toDate" value="${toDate}" class="form-control"
                                style="height: 38px; border: 1px solid #ced4da; border-radius: 4px;">
                        </div>

                        <div style="display:flex; flex-direction:column; min-width: 150px;">
                            <label
                                style="font-size:12px; font-weight:bold; margin-bottom:5px; color: #555;">Status</label>
                            <select name="status" class="form-control"
                                style="height: 38px; border: 1px solid #ced4da; border-radius: 4px;">
                                <option value="">All Statuses</option>
                                <option value="Pending" ${status=='Pending' ? 'selected' : '' }>Pending
                                </option>
                                <option value="Shipping" ${status=='Shipping' ? 'selected' : '' }>Shipping
                                </option>
                                <option value="Completed" ${status=='Completed' ? 'selected' : '' }>
                                    Completed</option>
                                <option value="Cancelled" ${status=='Cancelled' ? 'selected' : '' }>
                                    Cancelled</option>
                            </select>
                        </div>

                        <div style="display:flex; gap: 8px;">
                            <button type="submit" class="btn-sm"
                                style="background:#0d6efd; color:white; border:none; padding:0 20px; cursor:pointer; height: 38px; border-radius:4px; font-weight: 500; display: flex; align-items: center; gap: 6px;">
                                <i class="fa-solid fa-filter"></i> Filter
                            </button>

                            <a href="order" class="btn-sm"
                                style="background:#6c757d; color:white; border:none; padding:0 15px; cursor:pointer; height: 38px; border-radius:4px; display: flex; align-items: center; justify-content: center; text-decoration: none;">
                                <i class="fa-solid fa-rotate-right"></i>
                            </a>
                        </div>

                    </form>

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

                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>
                                                <a
                                                    href="order?sortBy=order_id&sortOrder=${sortOrder == 'ASC' ? 'DESC' : 'ASC'}&index=${tag}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&status=${status}">
                                                    Order ID <i
                                                        class="fa-solid fa-sort${sortBy == 'order_id' ? (sortOrder == 'ASC' ? '-up' : '-down') : ''}"></i>
                                                </a>
                                            </th>

                                            <th>
                                                <a
                                                    href="order?sortBy=customer&sortOrder=${sortOrder == 'ASC' ? 'DESC' : 'ASC'}&index=${tag}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&status=${status}">
                                                    Customer <i
                                                        class="fa-solid fa-sort${sortBy == 'customer' ? (sortOrder == 'ASC' ? '-up' : '-down') : ''}"></i>
                                                </a>
                                            </th>

                                            <th>
                                                <a
                                                    href="order?sortBy=order_date&sortOrder=${sortOrder == 'ASC' ? 'DESC' : 'ASC'}&index=${tag}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&status=${status}">
                                                    Order Date <i
                                                        class="fa-solid fa-sort${sortBy == 'order_date' ? (sortOrder == 'ASC' ? '-up' : '-down') : ''}"></i>
                                                </a>
                                            </th>

                                            <th>
                                                <a
                                                    href="order?sortBy=total_amount&sortOrder=${sortOrder == 'ASC' ? 'DESC' : 'ASC'}&index=${tag}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&status=${status}">
                                                    Total Amount <i
                                                        class="fa-solid fa-sort${sortBy == 'total_amount' ? (sortOrder == 'ASC' ? '-up' : '-down') : ''}"></i>
                                                </a>
                                            </th>

                                            <th>
                                                <a
                                                    href="order?sortBy=status&sortOrder=${sortOrder == 'ASC' ? 'DESC' : 'ASC'}&index=${tag}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&status=${status}">
                                                    Status <i
                                                        class="fa-solid fa-sort${sortBy == 'status' ? (sortOrder == 'ASC' ? '-up' : '-down') : ''}"></i>
                                                </a>
                                            </th>

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
                                                        pattern="dd/MM/yyyy HH:mm:ss" />
                                                </td>
                                                <td style="font-weight: bold; color: #C92127;">
                                                    <fmt:formatNumber value="${o.totalAmount}" type="currency"
                                                        currencySymbol="đ" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${o.status == 1}"><span
                                                                class="status-badge status-1">Pending</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 2}"><span
                                                                class="status-badge status-2">Shipping</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 3}"><span
                                                                class="status-badge status-3">Completed</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 4}"><span
                                                                class="status-badge status-4">Cancelled</span>
                                                        </c:when>
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
                                <div class="pagination"
                                    style="display: flex; justify-content: center; margin-top: 20px; gap: 5px;">
                                    <c:if test="${tag > 1}">
                                        <a href="order?index=${tag-1}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&status=${status}&sortBy=${sortBy}&sortOrder=${sortOrder}"
                                            class="page-btn">&laquo;</a>
                                    </c:if>

                                    <c:forEach begin="1" end="${endPage}" var="i">
                                        <a href="order?index=${i}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&status=${status}&sortBy=${sortBy}&sortOrder=${sortOrder}"
                                            class="page-btn ${tag == i ? 'active' : ''}">${i}</a>
                                    </c:forEach>

                                    <c:if test="${tag < endPage}">
                                        <a href="order?index=${tag+1}&keyword=${keyword}&fromDate=${fromDate}&toDate=${toDate}&status=${status}&sortBy=${sortBy}&sortOrder=${sortOrder}"
                                            class="page-btn">&raquo;</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>


            </body>

            </html>