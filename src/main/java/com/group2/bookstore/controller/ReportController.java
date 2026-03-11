package com.group2.bookstore.controller;

import com.group2.bookstore.dal.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Map;

@WebServlet("/staff/reports")
public class ReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Lấy tham số NGÀY từ form giao diện (Chỉ dùng 1 tham số reportDate)
        String reportDateStr = req.getParameter("reportDate");

        // 2. Mặc định là ngày hôm nay nếu người dùng chưa chọn
        if (reportDateStr == null || reportDateStr.isEmpty()) {
            reportDateStr = LocalDate.now().toString(); // Định dạng: yyyy-MM-dd
        }

        ReportDAO dao = new ReportDAO();
        
        // ====================================================================
        // A. DỮ LIỆU TRONG NGÀY (Dành cho 3 thẻ Thống kê & Biểu đồ Tròn)
        // Truyền cùng 1 ngày (reportDateStr) vào cả fromDate và toDate
        // ====================================================================
        int[] statusCounts = dao.getOrderStatusCounts(reportDateStr, reportDateStr);
        // Mảng trả về theo Index: 0=Pending, 1=Shipping, 2=Completed, 3=Cancelled
        int totalOrders = statusCounts[0] + statusCounts[1] + statusCounts[2] + statusCounts[3];
        int completedOrders = statusCounts[2];

        // Lấy doanh thu của đúng ngày đó
        Map<String, Double> dailyRevenueMap = dao.getRevenueByDate(reportDateStr, reportDateStr);
        double totalRevenue = dailyRevenueMap.isEmpty() ? 0 : dailyRevenueMap.values().iterator().next();

        // ====================================================================
        // B. DỮ LIỆU XU HƯỚNG (Dành cho Biểu đồ Đường - 7 Ngày)
        // Lùi lại 6 ngày từ ngày được chọn để vẽ ra đường xu hướng hợp lý
        // ====================================================================
        LocalDate targetDate = LocalDate.parse(reportDateStr);
        String fromDateTrend = targetDate.minusDays(6).toString();
        Map<String, Double> revenueTrendMap = dao.getRevenueByDate(fromDateTrend, reportDateStr);
        
        StringBuilder revLabels = new StringBuilder("[");
        StringBuilder revData = new StringBuilder("[");
        
        for (Map.Entry<String, Double> entry : revenueTrendMap.entrySet()) {
            revLabels.append("'").append(entry.getKey()).append("',"); // Nhãn (Ngày)
            revData.append(entry.getValue()).append(",");              // Dữ liệu (Tiền)
        }
        
        // Cắt bỏ dấu phẩy thừa ở cuối chuỗi nếu có
        if (revLabels.length() > 1) revLabels.setLength(revLabels.length() - 1);
        if (revData.length() > 1) revData.setLength(revData.length() - 1);
        
        revLabels.append("]");
        revData.append("]");

        // 3. Đẩy dữ liệu sang file JSP
        req.setAttribute("reportDate", reportDateStr); // Giữ lại ngày đang chọn để hiển thị trên input
        req.setAttribute("totalRevenue", totalRevenue);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("completedOrders", completedOrders);

        // Dữ liệu cho biểu đồ
        req.setAttribute("revenueLabels", revLabels.length() > 2 ? revLabels.toString() : "['Không có dữ liệu']");
        req.setAttribute("revenueData", revData.length() > 2 ? revData.toString() : "[0]");
        req.setAttribute("statusData", Arrays.toString(statusCounts)); // "[2, 0, 0, 0]"

        // 4. Chuyển tiếp tới giao diện
        req.getRequestDispatcher("/view/sales-report.jsp").forward(req, resp);
    }
}