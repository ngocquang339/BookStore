<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <title>Order #${order.id} Details</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-detail.css?v=1">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


            </head>

            <body>

                <div class="page-container">
                    <a href="${pageContext.request.contextPath}/admin/order" class="back-link">
                        <i class="fa-solid fa-arrow-left"></i> Back to Orders
                    </a>

                    <h1>Order Details #${order.id}</h1>

                    <div class="order-container">

                        <div class="order-info">
                            <h3>Customer Info</h3>
                            <div class="info-group">
                                <label>Customer Name:</label> ${order.userName}
                            </div>
                            <div class="info-group">
                                <label>Phone:</label> ${order.phoneNumber}
                            </div>
                            <div class="info-group">
                                <label>Shipping Address:</label> ${order.shippingAddress}
                            </div>
                            <div class="info-group">
                                <label>Order Date:</label>
                                <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm" />
                            </div>

                            <c:choose>
                                <%-- 1. Lock the UI if the order is Completed (Status 3) --%>
                                    <c:when test="${order.status == 3}">
                                        <div style="margin-top: 20px; background-color: #d1e7dd; color: #0f5132; padding: 15px; border-radius: 8px; border: 1px solid #badbcc;">
                                            <div><i class="fa-solid fa-lock"></i> This order is <strong>Completed</strong> and archived. The status can no longer be modified.</div>
                                            
                                            <%-- Safely display the note if it exists --%>
                                            <c:if test="${not empty order.statusNote}">
                                                <div style="margin-top: 10px; padding-top: 10px; border-top: 1px solid #badbcc; font-size: 0.95em;">
                                                    <strong><i class="fa-solid fa-comment-dots"></i> Note:</strong> ${order.statusNote}
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:when>

                                    <%-- 2. Lock the UI if the order is Cancelled (Checking both 0 and 4 just in case!) --%>
                                    <c:when test="${order.status == 0 || order.status == 4}">
                                        <div style="margin-top: 20px; background-color: #f8d7da; color: #842029; padding: 15px; border-radius: 8px; border: 1px solid #f5c2c7;">
                                            <div><i class="fa-solid fa-ban"></i> This order is <strong>Cancelled</strong> and archived. The status can no longer be modified.</div>
                                            
                                            <%-- Safely display the reason if it exists --%>
                                            <c:if test="${not empty order.statusNote}">
                                                <div style="margin-top: 10px; padding-top: 10px; border-top: 1px solid #f5c2c7; font-size: 0.95em;">
                                                    <strong><i class="fa-solid fa-circle-exclamation"></i> Reason:</strong> ${order.statusNote}
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:when>

                                        <%-- 3. Show the update form only if the order is Pending or Shipping --%>

                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/admin/order/update"
                                                    method="post"
                                                    style="margin-top: 20px; background: #f8f9fa; padding: 15px; border-radius: 8px;">
                                                    <input type="hidden" name="orderId" value="${order.id}">
                                                    <label style="font-weight:bold;">Update Order Status:</label>

                                                    <%-- CRITICAL: Added id and onchange here --%>
                                                        <select name="status" id="statusDropdown" class="status-select"
                                                            onchange="toggleReasonField()">
                                                            <option value="1" ${order.status==1 ? 'selected' : '' }>
                                                                Pending
                                                            </option>
                                                            <option value="2" ${order.status==2 ? 'selected' : '' }>
                                                                Shipping
                                                            </option>
                                                            <option value="3">Completed</option>
                                                            <option value="0">Cancelled</option>
                                                        </select>

                                                        <%-- CRITICAL: The hidden reason box --%>
                                                            <div id="reasonBox"
                                                                style="display: none; margin-top: 15px;">
                                                                <label style="font-weight:bold; color: #dc3545;">Reason
                                                                    / Note (Required):</label>
                                                                <textarea name="statusNote" id="statusNoteInput"
                                                                    class="form-control" rows="3"
                                                                    placeholder="Explain why this order is being completed or cancelled..."
                                                                    style="width: 100%; margin-top: 5px; padding: 10px; border: 1px solid #ced4da; border-radius: 4px;"></textarea>
                                                            </div>

                                                            <button type="submit" class="btn-update"
                                                                style="margin-top: 15px; background-color: #28a745; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer;">Update
                                                                Status</button>
                                                </form>

                                                <%-- CRITICAL: The JavaScript to make it toggle --%>
                                                    <script>
                                                        function toggleReasonField() {
                                                            var dropdown = document.getElementById("statusDropdown");
                                                            var reasonBox = document.getElementById("reasonBox");
                                                            var reasonInput = document.getElementById("statusNoteInput");

                                                            // Check for 3 (Completed) or 0 (Cancelled)
                                                            if (dropdown.value === "3" || dropdown.value === "0") {
                                                                reasonBox.style.display = "block";
                                                                reasonInput.required = true;
                                                            } else {
                                                                reasonBox.style.display = "none";
                                                                reasonInput.required = false;
                                                                reasonInput.value = "";
                                                            }
                                                        }
                                                    </script>
                                            </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="order-items">
                            <h3>Order Items</h3>
                            <c:forEach items="${details}" var="d">
                                <div class="item-row">
                                    <img src="${pageContext.request.contextPath}/assets/image/books/${d.book.imageUrl}"
                                        class="item-img" onerror="this.src='https://placehold.co/50x75?text=No+Img'">

                                    <div style="flex: 1;">
                                        <div style="font-weight: bold; font-size: 1.1em;">${d.book.title}</div>
                                        <div style="color: #666;">ID: ${d.bookId}</div>
                                    </div>

                                    <div style="text-align: right;">
                                        <div>x${d.quantity}</div>
                                        <div style="font-weight: bold; color: #C92127;">
                                            <fmt:formatNumber value="${d.price}" type="currency" currencySymbol="đ" />
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <div style="text-align: right; margin-top: 20px; font-size: 1.2em; font-weight: bold;">
                                Total Amount: <span style="color: #C92127;">
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="đ" />
                                </span>
                            </div>
                        </div>

                    </div>
                </div>

            </body>

            </html>