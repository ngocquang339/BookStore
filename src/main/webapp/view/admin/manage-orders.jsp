<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <title>Order Management</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage-orders.css?v=5">
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

                    <form action="order" method="get" class="filter-bar">
                        <div class="filter-group filter-group-search">
                            <label class="filter-label">Search Order</label>
                            <div class="search-input-wrapper">
                                <input type="text" name="keyword" value="${keyword}" class="form-control search-input"
                                    placeholder="Enter ID, Customer Name or Phone...">
                                <i class="fa-solid fa-magnifying-glass search-icon"></i>
                            </div>
                        </div>

                        <div class="filter-group">
                            <label class="filter-label">From Date</label>
                            <input type="date" name="fromDate" value="${fromDate}" class="form-control">
                        </div>

                        <div class="filter-group">
                            <label class="filter-label">To Date</label>
                            <input type="date" name="toDate" value="${toDate}" class="form-control">
                        </div>

                        <div class="filter-group filter-group-status">
                            <label class="filter-label">Status</label>
                            <select name="status" class="form-control">
                                <option value="">All Statuses</option>
                                <option value="1" ${status=='1' ? 'selected' : '' }>Pending</option>
                                <option value="2" ${status=='2' ? 'selected' : '' }>Processing</option>
                                <option value="3" ${status=='3' ? 'selected' : '' }>Packed</option>
                                <option value="4" ${status=='4' ? 'selected' : '' }>Shipping</option>
                                <option value="5" ${status=='5' ? 'selected' : '' }>Delivered</option>
                                <option value="6" ${status=='6' ? 'selected' : '' }>Cancelled</option>
                            </select>
                        </div>

                        <div class="filter-actions">
                            <button type="submit" class="btn-sm btn-filter">
                                <i class="fa-solid fa-filter"></i> Filter
                            </button>
                            <a href="order" class="btn-sm btn-reset">
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
                                                    <span class="customer-phone">${o.phoneNumber}</span>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${o.orderDate}"
                                                        pattern="dd/MM/yyyy HH:mm:ss" />
                                                </td>
                                                <td class="total-amount">
                                                    <fmt:formatNumber value="${o.totalAmount}" type="currency"
                                                        currencySymbol="đ" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${o.status == 1}">
                                                            <span class="status-badge status-1">Pending</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 2}">
                                                            <span class="status-badge status-2">Processing</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 3}">
                                                            <span class="status-badge status-3">Packed</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 4}">
                                                            <span class="status-badge status-4">Shipping</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 5}">
                                                            <span class="status-badge status-5">Delivered</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 6}">
                                                            <span class="status-badge status-6">Cancelled</span>
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

                                <div class="pagination">
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