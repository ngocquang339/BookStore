Tải maven
Link: maven.apache.org/download.cgi
Tìm dòng Binary zip archive.
Bấm vào link tải file .zip. Chọn apache-maven-3.9.12-bin.zip.

Quy trình lấy dự án
GIAI ĐOẠN 1: KHỞI TẠO (Chỉ làm 1 lần đầu tiên)
Bước 1: Lấy dự án về máy (Clone)
Mở VS Code hoặc Terminal tại thư mục muốn lưu dự án, chạy lệnh:

git clone https://github.com/ngocquang339/BookStore.git

Bước 2: Đồng bộ thư viện Maven (Quan trọng)
Sau khi clone xong, Mở thư mục BookStore bằng VS Code.

Cách 1 (Tự động): Chờ khoảng 1-2 phút, nhìn góc dưới bên phải thấy VS Code báo Java Ready hoặc Importing Maven... là xong.

Cách 2 (Thủ công - Nếu mạng lag): Mở Terminal trong VS Code và chạy lệnh này để ép nó tải thư viện về:

Windows: .\mvnw clean install

Mac/Linux: ./mvnw clean install

Bước 3: Cấu hình Server (Tomcat)
Vào tab Mục Server bên trái.

Chuột phải Tomcat -> Add Deployment.

Chọn Exploded (hoặc chọn file .war trong thư mục target).

GIAI ĐOẠN 2: BẮT ĐẦU CODE (Làm hàng ngày)
⚠️ QUY TẮC VÀNG: Tuyệt đối không được viết code trực tiếp trên nhánh main.

Bước 1: Cập nhật code mới nhất từ nhóm
Trước khi bắt đầu làm việc, hãy chắc chắn nhánh main ở máy mình là mới nhất:

git checkout main
git pull origin main

Bước 2: Tạo nhánh riêng để làm chức năng (Branch)
Ví dụ bạn làm chức năng "Đăng nhập", hãy tạo một nhánh riêng từ main:

git checkout -b feature/login
(Thay feature/login bằng tên chức năng bạn làm, ví dụ: feature/cart, feature/payment...)

Bước 3: Code và Chạy thử
Lúc này bạn cứ code, sửa lỗi, chạy server thoải mái. Mọi thay đổi chỉ nằm trên nhánh con này thôi, không ảnh hưởng đến ai cả.

GIAI ĐOẠN 3: NỘP BÀI (Sau khi code xong)
Bước 1: Lưu code (Commit)
Khi đã code xong và test chạy ngon lành:

git add .
git commit -m "Hoan thanh chuc nang dang nhap"

Bước 2: Đẩy nhánh lên GitHub (Push)
Đẩy cái nhánh con bạn vừa làm lên kho chứa (Lưu ý: Đẩy nhánh con, không đẩy vào main):

git push origin feature/login
GIAI ĐOẠN 4: GỘP CODE (Merge - Dành cho Nhóm trưởng hoặc Người làm xong)
Sau khi push xong, code vẫn nằm riêng ở nhánh con. Để gộp nó vào dự án chính (main), bạn làm như sau:

Truy cập vào trang GitHub của dự án.

Bạn sẽ thấy một thanh thông báo màu vàng/xanh hiện lên: "Compare & pull request". Bấm vào đó.

Viết tiêu đề (VD: Merge chức năng Login vào Main).

Bấm Create pull request.

Review code: Nhóm trưởng (hoặc các thành viên khác) vào xem code có lỗi gì không.

Nếu ổn, bấm nút màu xanh lá Merge pull request -> Confirm merge.

👉 XONG! Lúc này code của chức năng Đăng nhập đã chính thức nằm trong nhánh main.
