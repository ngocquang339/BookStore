<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Live Chat - Sale Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f0f2f5; height: 100vh; overflow: hidden; }
        .chat-container { height: calc(100vh - 90px); background: white; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; }
        .chat-sidebar { border-right: 1px solid #ddd; height: 100%; display: flex; flex-direction: column; background: #fff; }
        .sidebar-header { padding: 15px; border-bottom: 1px solid #ddd; background: #f8f9fa; }
        .user-list { overflow-y: auto; flex: 1; }
        .user-item { padding: 15px; border-bottom: 1px solid #eee; cursor: pointer; display: flex; align-items: center; transition: background 0.2s; }
        .user-item:hover { background: #f8f9fa; }
        .user-item.active { background: #e7f1ff; border-left: 4px solid #0d6efd; }
        .user-avatar { width: 50px; height: 50px; border-radius: 50%; object-fit: cover; margin-right: 15px; border: 2px solid #ddd; }
        .user-info { flex: 1; }
        .user-name { font-weight: bold; margin-bottom: 2px; color: #333; }
        .user-msg { font-size: 13px; color: #666; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 180px; }
        .chat-main { display: flex; flex-direction: column; height: 100%; background: #fff; }
        .chat-header { padding: 15px 20px; border-bottom: 1px solid #ddd; background: #fff; display: flex; justify-content: space-between; align-items: center; }
        .chat-messages { flex: 1; padding: 20px; overflow-y: auto; background: #e4e9f0; display: flex; flex-direction: column; gap: 15px; }
        .msg-bubble { max-width: 60%; padding: 12px 16px; border-radius: 15px; font-size: 15px; line-height: 1.4; }
        .msg-customer { background: #fff; color: #333; align-self: flex-start; border-bottom-left-radius: 4px; box-shadow: 0 1px 2px rgba(0,0,0,0.1); }
        .msg-staff { background: #0d6efd; color: white; align-self: flex-end; border-bottom-right-radius: 4px; box-shadow: 0 1px 2px rgba(0,0,0,0.1); }
        .chat-input-area { padding: 15px; border-top: 1px solid #ddd; background: #fff; display: flex; align-items: center; gap: 10px; }
        .chat-input-area input { flex: 1; padding: 12px 20px; border-radius: 25px; border: 1px solid #ddd; outline: none; background: #f8f9fa; }
        .btn-send { background: #0d6efd; color: white; border: none; width: 45px; height: 45px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 18px; cursor: pointer; transition: 0.2s; }
    </style>
</head>
<body>
    <div class="container-fluid mt-3 px-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <a href="${pageContext.request.contextPath}/staff-dashboard" class="btn btn-dark fw-bold">Về Dashboard</a>
            <h3 class="text-primary fw-bold mb-0"><i class="fa-brands fa-rocketchat me-2"></i> QUẢN LÝ CHAT NHIỀU NGƯỜI</h3>
            <div style="width: 140px;"></div>
        </div>

        <div class="row chat-container mx-0">
            <div class="col-md-4 col-lg-3 px-0 chat-sidebar">
                <div class="sidebar-header">
                    <input type="text" class="form-control rounded-pill" placeholder="Tìm kiếm khách hàng...">
                </div>
                <div class="user-list" id="userList">
                    </div>
            </div>

            <div class="col-md-8 col-lg-9 px-0 chat-main">
                <div class="chat-header">
                    <div class="d-flex align-items-center">
                        <img src="https://ui-avatars.com/api/?name=Book&background=random" class="user-avatar" style="width: 40px; height: 40px;" alt="Avatar">
                        <div>
                            <h5 class="mb-0 fw-bold" id="headerName">Chưa chọn khách hàng</h5>
                        </div>
                    </div>
                </div>

                <div class="chat-messages" id="chatBox">
                    <div class="text-center my-2"><span class="badge bg-secondary opacity-50">Hãy chọn một khách hàng bên trái để bắt đầu</span></div>
                </div>

                <div class="chat-input-area">
                    <input type="text" id="staffMsg" placeholder="Nhập câu trả lời..." onkeypress="handleEnter(event)">
                    <button class="btn-send" onclick="sendStaffMessage()"><i class="fa-solid fa-paper-plane"></i></button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // BỘ NHỚ RAM TẠI TRÌNH DUYỆT (Lưu toàn bộ phòng chat)
        let chatData = {}; 
        let currentCustomer = null; // Đang chat với ai?

        const wsUrl = "ws://" + window.location.host + "${pageContext.request.contextPath}/livechat";
        const websocket = new WebSocket(wsUrl);

        websocket.onopen = function() {
            websocket.send("REGISTER_STAFF");
        };

        // NHẬN TIN TỪ SERVER (Tách luồng dữ liệu)
        websocket.onmessage = function(event) {
            const data = event.data;
            const parts = data.split("|||");
            
            const command = parts[0]; 
            const customerName = parts[1];

            // Nếu người này chưa từng nhắn, tạo phòng chat mới cho họ
            if (!chatData[customerName]) {
                chatData[customerName] = [];
            }

            if (command === "HISTORY") {
                const type = parts[2]; // CUST hoặc STAFF
                const content = parts.slice(3).join("|||"); 
                chatData[customerName].push({ sender: type, text: content });
            } 
            else if (command === "SYNC_CUST") {
                const content = parts.slice(2).join("|||");
                chatData[customerName].push({ sender: 'CUST', text: content });
            } 
            else if (command === "SYNC_STAFF") {
                const content = parts.slice(2).join("|||");
                chatData[customerName].push({ sender: 'STAFF', text: content });
            }

            renderSidebar(); // Vẽ lại danh sách bên trái

            // Nếu đang mở khung chat của người đó, thì vẽ lại khung chat bên phải
            if (currentCustomer === customerName) {
                renderChatBox();
            }
        };

        // Hàm TỰ ĐỘNG VẼ DANH SÁCH BÊN TRÁI
        function renderSidebar() {
            const userList = document.getElementById('userList');
            userList.innerHTML = '';
            
            // Lặp qua danh sách từ điển
            for (let custName in chatData) {
                let msgs = chatData[custName];
                let lastMsg = msgs.length > 0 ? msgs[msgs.length - 1].text : '';
                let activeClass = (custName === currentCustomer) ? 'active' : '';
                
                let itemHtml = '<div class="user-item ' + activeClass + '" onclick="selectCustomer(\'' + custName + '\')">' +
                               '<img src="https://ui-avatars.com/api/?name=' + custName + '&background=random" class="user-avatar">' +
                               '<div class="user-info">' +
                               '<div class="user-name">' + custName + '</div>' +
                               '<div class="user-msg">' + lastMsg + '</div>' +
                               '</div></div>';
                userList.innerHTML += itemHtml;
            }
        }

        // KHI STAFF CLICK CHỌN 1 NGƯỜI
        function selectCustomer(custName) {
            currentCustomer = custName;
            document.getElementById('headerName').innerText = custName;
            renderSidebar(); 
            renderChatBox(); // Tải lịch sử của người đó ra
        }

        // Hàm VẼ TIN NHẮN BÊN PHẢI
        function renderChatBox() {
            const chatBox = document.getElementById('chatBox');
            chatBox.innerHTML = '<div class="text-center my-2"><span class="badge bg-secondary opacity-50">Lịch sử trò chuyện</span></div>';
            
            if (currentCustomer && chatData[currentCustomer]) {
                let msgs = chatData[currentCustomer];
                msgs.forEach(m => {
                    if (m.sender === 'CUST') {
                        chatBox.innerHTML += '<div class="msg-bubble msg-customer">' + m.text + '</div>';
                    } else {
                        chatBox.innerHTML += '<div class="msg-bubble msg-staff">' + m.text + '</div>';
                    }
                });
            }
            chatBox.scrollTop = chatBox.scrollHeight;
        }

        function sendStaffMessage() {
            const input = document.getElementById('staffMsg');
            const message = input.value.trim();
            
            if (message !== '' && currentCustomer) {
                // Gửi về Server chỉ định đích danh người nhận
                websocket.send("STAFF|||" + currentCustomer + "|||" + message);
                input.value = '';
            } else if (!currentCustomer) {
                alert("Vui lòng click chọn một khách hàng bên trái trước khi gửi tin nhắn!");
            }
        }

        function handleEnter(e) {
            if (e.key === 'Enter') sendStaffMessage();
        }
    </script>
</body>
</html>