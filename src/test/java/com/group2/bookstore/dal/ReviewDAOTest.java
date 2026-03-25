package com.group2.bookstore.dal;
import org.junit.Assert;
import org.junit.Test;

public class ReviewDAOTest {

    // Test Case 1: Thêm Review thành công
    @Test
    public void testInsertReview_Success() {
        // 1. Khởi tạo đối tượng chứa hàm cần test
        ReviewDAO dao = new ReviewDAO(); 
        
        // 2. Chuẩn bị dữ liệu đầu vào (Lưu ý: userId và bookId này PHẢI TỒN TẠI trong Database của bạn)
        int userId = 1; 
        int bookId = 1; 
        int rating = 5;
        String comment = "Sách rất hay, đáng đọc!";

        // 3. Thực thi hàm
        int resultId = dao.insertReview(userId, bookId, rating, comment);

        // 4. Kiểm tra kết quả (Assert) thay vì dùng System.out.println
        // Nếu insert thành công, ID trả về phải lớn hơn 0
        Assert.assertTrue("Insert thất bại, ID trả về không hợp lệ", resultId > 0);
    }

    // Test Case 2: Thêm Review thất bại (Ví dụ: userId không tồn tại)
    @Test
    public void testInsertReview_Fail_InvalidUser() {
        ReviewDAO dao = new ReviewDAO();
        
        // Cố tình truyền một userId không tồn tại trong Database (ví dụ: -999) 
        // để kích hoạt lỗi Foreign Key Constraint
        int invalidUserId = -999; 
        int bookId = 1; 
        int rating = 3;
        String comment = "Test lỗi";

        int resultId = dao.insertReview(invalidUserId, bookId, rating, comment);

        // Do có lỗi ở khối try, hàm sẽ nhảy vào catch và trả về -1
        Assert.assertEquals("Hàm phải trả về -1 khi có lỗi xảy ra", -1, resultId);
    }
}
