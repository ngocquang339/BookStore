<%-- File: /view/admin/admin-notifications.jsp --%>
<div id="notification-container" style="position: fixed; top: 20px; right: 20px; z-index: 9999;"></div>

<script>
    function fetchNotifications() {
        fetch('${pageContext.request.contextPath}/admin/api/notifications')
            .then(response => response.json())
            .then(data => {
                const container = document.getElementById('notification-container');
                container.innerHTML = ''; 
                data.forEach(notification => {
                    const alertBox = document.createElement('div');
                    alertBox.style.cssText = "background: #fff3cd; color: #856404; padding: 15px; margin-bottom: 10px; border-radius: 5px; border-left: 5px solid #ffeeba; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 300px; display: flex; justify-content: space-between; align-items: center;";
                    
                    alertBox.innerHTML = `
                        <div>
                            <strong><i class="fa-solid fa-bell"></i> New Alert!</strong><br>
                            <span style="font-size: 0.9em;">` + notification.message + `</span>
                        </div>
                        <button onclick="dismissNotification(` + notification.id + `)" style="background: none; border: none; font-size: 1.2em; cursor: pointer; color: #856404;">&times;</button>
                    `;
                    container.appendChild(alertBox);
                });
            })
            .catch(err => console.error("Polling error:", err));
    }

    function dismissNotification(id) {
        fetch('${pageContext.request.contextPath}/admin/api/notifications', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'id=' + id
        }).then(() => { fetchNotifications(); });
    }

    setInterval(fetchNotifications, 15000);
    window.onload = fetchNotifications; 
</script>