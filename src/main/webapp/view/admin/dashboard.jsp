<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Admin Dashboard - BookStore</title>

                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/admin-dashboard-stats.css?v=2">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


            </head>

            <body>

                <header class="main-header">
                    <div class="container">
                        <div class="logo">
                            <a href="${pageContext.request.contextPath}/home">
                                <span style="color: #C92127; font-weight: 900; font-size: 28px;">MIND</span>BOOK
                            </a>
                            <span style="color: white; margin-left: 10px; font-weight: 300;">| ADMIN PANEL</span>
                        </div>
                        <%-- Admin Activity Feed Panel --%>
                            <%-- Notification Bell Dropdown Wrapper --%>
                                <div class="notification-wrapper"
                                    style="position: relative; display: inline-block; margin-right: 20px;">

                                    <%-- The Bell Button --%>
                                        <button id="bell-button" onclick="toggleNotifDropdown()"
                                            style="background: none; border: none; color: white; cursor: pointer; position: relative; padding: 5px;">
                                            <i class="fa-solid fa-bell" style="font-size: 1.4em;"></i>
                                            <%-- The Red Badge (Hidden by default until JS finds alerts) --%>
                                                <span id="notif-badge"
                                                    style="position: absolute; top: -2px; right: -5px; background: #dc3545; color: white; border-radius: 50%; padding: 2px 6px; font-size: 0.7em; font-weight: bold; display: none;">0</span>
                                        </button>

                                        <%-- The Dropdown Menu (Hidden by default) --%>
                                            <div id="notif-dropdown"
                                                style="display: none; position: absolute; top: 45px; right: 0; width: 350px; background: white; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); border-top: 4px solid #17a2b8; z-index: 1000; text-align: left;">

                                                <%-- Dropdown Header --%>
                                                    <div
                                                        style="padding: 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
                                                        <strong style="color: #333; margin: 0;">Recent Activity</strong>
                                                        <span id="notif-count-text"
                                                            style="font-size: 0.8em; background: #17a2b8; color: white; padding: 2px 8px; border-radius: 12px;">0
                                                            New</span>
                                                    </div>

                                                    <%-- The scrollable list where JavaScript will inject the alerts
                                                        --%>
                                                        <div id="notif-list"
                                                            style="max-height: 300px; overflow-y: auto; padding: 0;">
                                                            <%-- Items go here --%>
                                                        </div>

                                            </div>
                                </div>
                                <div class="header-icons">
                                    <span style="color: white; margin-right: 15px;">
                                        <i class="fa-solid fa-user-shield"></i> Welcome, ${sessionScope.user.fullname}
                                    </span>
                                    <a href="${pageContext.request.contextPath}/logout"
                                        style="color: #ffcccc; text-decoration: none;">
                                        <i class="fa-solid fa-right-from-bracket"></i> Logout
                                    </a>
                                </div>
                    </div>
                </header>

                <main class="dashboard-container">
                    <div class="dashboard-header">
                        <h1><i class="fa-solid fa-gauge-high"></i> Dashboard Overview</h1>
                        <a href="${pageContext.request.contextPath}/home" class="btn-back">
                            <i class="fa-solid fa-house"></i> Back to Shop
                        </a>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card" style="border-left-color: #198754;">
                            <div class="stat-icon" style="color: #198754;"><i class="fa-solid fa-sack-dollar"></i></div>
                            <div class="stat-info">
                                <h3>
                                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ"
                                        maxFractionDigits="0" />
                                </h3>
                                <p>Total Revenue</p>
                            </div>
                        </div>

                        <div class="stat-card" style="border-left-color: #0d6efd;">
                            <div class="stat-icon" style="color: #0d6efd;"><i class="fa-solid fa-cart-shopping"></i>
                            </div>
                            <div class="stat-info">
                                <h3>${totalOrders}</h3>
                                <p>Total Orders</p>
                            </div>
                        </div>

                        <div class="stat-card" style="border-left-color: #ffc107;">
                            <div class="stat-icon" style="color: #ffc107;"><i class="fa-solid fa-book"></i></div>
                            <div class="stat-info">
                                <h3>${totalBooks}</h3>
                                <p>Books Managed</p>
                            </div>
                        </div>

                        <div class="stat-card" style="border-left-color: #6c757d;">
                            <div class="stat-icon" style="color: #6c757d;"><i class="fa-solid fa-users"></i></div>
                            <div class="stat-info">
                                <h3>${totalCustomers}</h3>
                                <p>Customers</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-grid">
                        <a href="${pageContext.request.contextPath}/admin/product/list" class="admin-card">
                            <i class="fa-solid fa-book"></i>
                            <h3>Product Manager</h3>
                            <p>Add, Edit, or Hide books</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/order" class="admin-card">
                            <i class="fa-solid fa-list-check"></i>
                            <h3>Orders</h3>
                            <p>View and process customer orders</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/users" class="admin-card">
                            <i class="fa-solid fa-users"></i>
                            <h3>Users</h3>
                            <p>Manage accounts and roles</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/reports" class="admin-card">
                            <i class="fa-solid fa-chart-simple"></i>
                            <h3>Reports</h3>
                            <p>Sales statistics</p>
                        </a>
                    </div>
                </main>
                <%@ include file="admin-notifications.jsp" %>
                    <script>
                        // 1. Toggle the dropdown visibility
                        function toggleNotifDropdown() {
                            var dropdown = document.getElementById("notif-dropdown");
                            if (dropdown.style.display === "none") {
                                dropdown.style.display = "block";
                                fetchNotifications(); // Fetch fresh data right when they open it
                            } else {
                                dropdown.style.display = "none";
                            }
                        }

                        // 2. Close dropdown if clicked outside
                        document.addEventListener('click', function (event) {
                            var bell = document.getElementById('bell-button');
                            var dropdown = document.getElementById('notif-dropdown');
                            if (!bell.contains(event.target) && !dropdown.contains(event.target)) {
                                dropdown.style.display = 'none';
                            }
                        });

                        // 3. The Polling Logic (Updated for the dropdown)
                        function fetchNotifications() {
                            fetch('${pageContext.request.contextPath}/admin/api/notifications')
                                .then(response => response.json())
                                .then(data => {
                                    const list = document.getElementById('notif-list');
                                    const badge = document.getElementById('notif-badge');
                                    const countText = document.getElementById('notif-count-text');

                                    list.innerHTML = ''; // Clear old items

                                    // Update the red badge number
                                    if (data.length > 0) {
                                        badge.style.display = 'inline-block';
                                        badge.innerText = data.length;
                                        countText.innerText = data.length + " New";
                                    } else {
                                        badge.style.display = 'none';
                                        countText.innerText = "0 New";
                                        list.innerHTML = `<div style="padding: 20px; text-align: center; color: #888;">
                                        <i class="fa-regular fa-bell-slash" style="font-size: 1.5em; margin-bottom: 5px;"></i><br>
                                        No new notifications
                                      </div>`;
                                        return;
                                    }

                                    // Inject the actual alerts
                                    data.forEach(notification => {
                                        const item = document.createElement('div');
                                        item.style.cssText = "padding: 12px 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; transition: background 0.2s;";
                                        item.onmouseover = function () { this.style.backgroundColor = '#f8f9fa'; }
                                        item.onmouseout = function () { this.style.backgroundColor = 'transparent'; }

                                        item.innerHTML = `
                        <div style="flex: 1; font-size: 0.9em; color: #444;">
                            <div style="margin-bottom: 4px;">` + notification.message + `</div>
                            <a href="${pageContext.request.contextPath}/admin/order/detail?id=` + notification.orderId + `" style="color: #0d6efd; text-decoration: none; font-size: 0.85em;">View Order &rarr;</a>
                        </div>
                        <button onclick="dismissNotification(` + notification.id + `)" style="background: none; border: none; color: #ccc; cursor: pointer; padding: 0; margin-top: -2px;">&times;</button>
                    `;
                                        list.appendChild(item);
                                    });
                                })
                                .catch(err => console.error("Polling error:", err));
                        }

                        // 4. Mark as read
                        function dismissNotification(id) {
                            fetch('${pageContext.request.contextPath}/admin/api/notifications', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'id=' + id
                            }).then(() => { fetchNotifications(); }); // Refresh the list
                        }

                        // Start the 15-second background polling
                        setInterval(fetchNotifications, 15000);
                        window.onload = fetchNotifications;
                    </script>
            </body>

            </html>