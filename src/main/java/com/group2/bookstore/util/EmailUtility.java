package com.group2.bookstore.util;

import java.util.Properties;
import java.util.Random;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtility {

    public static void sendEmail(String toEmail, String otpCode) {
        // 1. Cấu hình thông tin Server của Google
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); // SMTP Host
        props.put("mail.smtp.port", "587"); // TLS Port
        props.put("mail.smtp.auth", "true"); // Enable Auth
        props.put("mail.smtp.starttls.enable", "true"); // Enable TLS

        // 2. Tài khoản Gmail của bạn (Người gửi)
        final String fromEmail = "quangakashi@gmail.com";
        final String password = "mxql uvdw avbd cjtx"; // KHÔNG PHẢI PASS ĐĂNG NHẬP

        // 3. Tạo phiên làm việc (Session)
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            // 4. Tạo nội dung Email
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("Mã xác thực đăng ký BookStore");
            msg.setText("Chào bạn,\n\nMã xác thực (OTP) của bạn là: " + otpCode + "\n\nMã này sẽ hết hạn trong 5 phút.");

            // 5. Gửi đi
            Transport.send(msg);
            System.out.println("Gửi mail thành công!");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public static void sendMarketingEmail(String toEmail, String subject, String body) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        final String fromEmail = "quangakashi@gmail.com";
        final String password = "mxql uvdw avbd cjtx";

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(fromEmail));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject);
        msg.setText(body);

        Transport.send(msg);
    }

    // Hàm sinh mã OTP ngẫu nhiên 6 số
    public static String getRandomOTP() {
        Random rnd = new Random();
        int number = rnd.nextInt(999999);
        return String.format("%06d", number);
    }

    // ... keep your existing sendEmail and getRandomOTP methods ...
    // Thêm hàm mới: Gửi email từ chối trả hàng
    public static void sendRejectionEmail(String toEmail, String rejectionReason) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Sử dụng lại tài khoản của bạn
        final String fromEmail = "quangakashi@gmail.com";
        final String password = "mxql uvdw avbd cjtx";

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message msg = new MimeMessage(session);

            // Bạn có thể đổi "BookStore Support" thành tên nhóm của bạn
            msg.setFrom(new InternetAddress(fromEmail, "BookStore Support"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("Thông báo về yêu cầu trả hàng của bạn - BookStore");

            // Tạo nội dung HTML chuyên nghiệp
            String htmlContent = "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto;'>"
                    + "<h2 style='color: #dc3545; border-bottom: 2px solid #dc3545; padding-bottom: 10px;'>Cập nhật yêu cầu trả hàng</h2>"
                    + "<p>Chào bạn,</p>"
                    + "<p>Chúng tôi đã nhận và xem xét yêu cầu trả hàng của bạn. Rất tiếc, yêu cầu này không được chấp nhận vào lúc này.</p>"
                    + "<p><strong>Lý do từ chối:</strong></p>"
                    + "<div style='background-color: #f8d7da; padding: 15px; border-left: 5px solid #dc3545; margin: 15px 0; border-radius: 4px;'>"
                    + rejectionReason
                    + "</div>"
                    + "<p>Nếu bạn có bất kỳ thắc mắc nào, vui lòng phản hồi trực tiếp lại email này để được hỗ trợ.</p>"
                    + "<p>Trân trọng,<br><strong>Đội ngũ BookStore</strong></p>"
                    + "</div>";

            // Đặt content type là HTML và hỗ trợ tiếng Việt (UTF-8)
            msg.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(msg);
            System.out.println("Gửi mail từ chối thành công tới: " + toEmail);

        } catch (Exception e) {
            System.out.println("Lỗi khi gửi mail từ chối tới: " + toEmail);
            e.printStackTrace();
        }
    }

    // Thêm hàm mới: Gửi email chấp nhận trả hàng (Đổi trả)
    public static void sendReplacementApprovalEmail(String toEmail, String adminNote) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        final String fromEmail = "quangakashi@gmail.com";
        final String password = "mxql uvdw avbd cjtx"; // Nhớ đổi mật khẩu này sau nhé!

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail, "BookStore Support"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("Yêu cầu trả hàng của bạn đã được phê duyệt! - BookStore");

            // Tạo nội dung HTML chuyên nghiệp (Màu xanh lá cây cho thông báo thành công)
            String htmlContent = "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto;'>"
                    + "<h2 style='color: #28a745; border-bottom: 2px solid #28a745; padding-bottom: 10px;'>Yêu cầu của bạn đã được chấp nhận</h2>"
                    + "<p>Chào bạn,</p>"
                    + "<p>Tin vui! Chúng tôi đã xem xét yêu cầu trả hàng của bạn và nó <strong>đã được phê duyệt</strong>.</p>"
                    + "<p>Sản phẩm thay thế của bạn đang được chuẩn bị và sẽ được giao đến cho bạn trong vài ngày tới.</p>"
                    + "<p><strong>Ghi chú từ cửa hàng:</strong></p>"
                    + "<div style='background-color: #d4edda; padding: 15px; border-left: 5px solid #28a745; margin: 15px 0; border-radius: 4px;'>"
                    + adminNote
                    + "</div>"
                    + "<p>Cảm ơn bạn đã kiên nhẫn và mua sắm tại BookStore!</p>"
                    + "<p>Trân trọng,<br><strong>Đội ngũ BookStore</strong></p>"
                    + "</div>";

            msg.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(msg);
            System.out.println("Gửi mail chấp nhận đổi trả thành công tới: " + toEmail);

        } catch (Exception e) {
            System.out.println("Lỗi khi gửi mail chấp nhận tới: " + toEmail);
            e.printStackTrace();
        }
    }

    // Thêm hàm mới: Gửi email Yêu Cầu Hành Động (Status 2)
    public static void sendActionRequiredEmail(String toEmail, String adminNote) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        final String fromEmail = "quangakashi@gmail.com";
        final String password = "mxql uvdw avbd cjtx"; // Update this with your new app password

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail, "BookStore Support"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("Cần thêm thông tin cho yêu cầu trả hàng của bạn - BookStore");

            // Tạo nội dung HTML chuyên nghiệp (Màu xanh dương cho thông báo cần hành động)
            String htmlContent = "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto;'>"
                    + "<h2 style='color: #0056b3; border-bottom: 2px solid #0056b3; padding-bottom: 10px;'><i class='fa-solid fa-circle-info'></i> Cập nhật yêu cầu trả hàng</h2>"
                    + "<p>Chào bạn,</p>"
                    + "<p>Chúng tôi đang xử lý yêu cầu trả hàng của bạn. Tuy nhiên, để tiếp tục xử lý, <strong>chúng tôi cần bạn cung cấp thêm một số thông tin</strong>.</p>"
                    + "<p><strong>Yêu cầu từ bộ phận hỗ trợ:</strong></p>"
                    + "<div style='background-color: #e2e3e5; padding: 15px; border-left: 5px solid #0056b3; margin: 15px 0; border-radius: 4px;'>"
                    + adminNote
                    + "</div>"
                    + "<p>Vui lòng phản hồi trực tiếp lại email này với các thông tin hoặc hình ảnh được yêu cầu để chúng tôi có thể hoàn tất thủ tục cho bạn sớm nhất có thể.</p>"
                    + "<p>Trân trọng,<br><strong>Đội ngũ BookStore</strong></p>"
                    + "</div>";

            msg.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(msg);
            System.out.println("Gửi mail 'Action Required' thành công tới: " + toEmail);

        } catch (Exception e) {
            System.out.println("Lỗi khi gửi mail 'Action Required' tới: " + toEmail);
            e.printStackTrace();
        }
    }

    // Thêm hàm mới: Gửi email Hoàn Tiền Thành Công (Status 5 & 7)
    public static void sendRefundSuccessEmail(String toEmail, double refundAmount, boolean customerKeepsItem, String adminNote) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        final String fromEmail = "quangakashi@gmail.com";
        final String password = "mxql uvdw avbd cjtx"; // Update this with your App Password

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail, "BookStore Support"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("Hoàn tiền thành công cho yêu cầu trả hàng của bạn - BookStore");

            // Format số tiền (VD: 150000 -> 150,000đ)
            java.text.NumberFormat formatter = new java.text.DecimalFormat("#,###");
            String formattedAmount = formatter.format(refundAmount) + "đ";

            // Xử lý thông báo về việc giữ lại hàng (Status 7 vs 5)
            String itemInstruction = customerKeepsItem
                    ? "<p style='color: #856404; background-color: #fff3cd; padding: 10px; border-radius: 4px;'><strong>Lưu ý:</strong> Bạn không cần phải gửi trả lại sản phẩm này. Hãy giữ lại hoặc xử lý theo ý muốn nhé.</p>"
                    : "<p>Chúng tôi đã nhận được sản phẩm hoàn trả tại kho và hoàn tất thủ tục.</p>";

            // Tạo nội dung HTML chuyên nghiệp (Màu xanh ngọc cho giao dịch tiền tệ)
            String htmlContent = "<div style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto;'>"
                    + "<h2 style='color: #17a2b8; border-bottom: 2px solid #17a2b8; padding-bottom: 10px;'><i class='fa-solid fa-money-bill-transfer'></i> Hoàn tiền thành công</h2>"
                    + "<p>Chào bạn,</p>"
                    + "<p>Yêu cầu trả hàng của bạn đã được xử lý xong. Khoản hoàn tiền trị giá <strong><span style='color: #dc3545; font-size: 18px;'>" + formattedAmount + "</span></strong> đã được chuyển vào tài khoản của bạn.</p>"
                    + itemInstruction
                    + "<p><strong>Ghi chú từ kế toán:</strong></p>"
                    + "<div style='background-color: #e2e3e5; padding: 15px; border-left: 5px solid #17a2b8; margin: 15px 0; border-radius: 4px;'>"
                    + adminNote
                    + "</div>"
                    + "<p>Tùy thuộc vào ngân hàng của bạn, có thể mất từ 1-3 ngày làm việc để số tiền hiển thị trong tài khoản.</p>"
                    + "<p>Cảm ơn bạn đã đồng hành cùng BookStore!</p>"
                    + "<p>Trân trọng,<br><strong>Đội ngũ BookStore</strong></p>"
                    + "</div>";

            msg.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(msg);
            System.out.println("Gửi mail 'Refund Success' thành công tới: " + toEmail);

        } catch (Exception e) {
            System.out.println("Lỗi khi gửi mail 'Refund Success' tới: " + toEmail);
            e.printStackTrace();
        }
    }

    public static void sendStoreCreditEmail(String toEmail, double amount, String voucherCode, boolean customerKeepsItem, String note) {
        // 1. SETUP SENDER CREDENTIALS (Use your real email and an APP PASSWORD, not your real password)
        final String fromEmail = "quangakashi@gmail.com";
        final String password = "mxql uvdw avbd cjtx";
        // 2. CONFIGURE SMTP SERVER SETTINGS (Gmail)
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // 3. CREATE A MAIL SESSION
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            // 4. PREPARE THE EMAIL CONTENT
            String subject = "Your Store Credit Voucher is Here!";
            String itemStatus = customerKeepsItem ? "You may keep the original item." : "We have successfully received the returned item.";

            String body = "<h3>Your Return has been Processed!</h3>"
                    + "<p>" + itemStatus + "</p>"
                    + "<p>As requested, we have issued your refund as Store Credit. You can use this code on your next purchase:</p>"
                    + "<div style='background-color: #f8f9fa; padding: 15px; border: 2px dashed #C92127; text-align: center; font-size: 20px; font-weight: bold; margin: 20px 0;'>"
                    + voucherCode
                    + "</div>"
                    + "<p><strong>Amount:</strong> " + String.format("%,.0f", amount) + "đ</p>"
                    + "<p><strong>Expiration:</strong> 90 Days from today.</p>"
                    + "<p>Note from Admin: " + (note != null && !note.isEmpty() ? note : "None") + "</p>"
                    + "<p>This voucher has been automatically saved to your account wallet!</p>";

            // 5. ASSEMBLE AND SEND THE MESSAGE
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=UTF-8"); // Force HTML format

            Transport.send(message);
            System.out.println("[EMAIL SYSTEM] Store Credit email sent successfully to: " + toEmail);

        } catch (Exception e) {
            System.out.println("[EMAIL ERROR] Failed to send email to: " + toEmail);
            e.printStackTrace();
        }
    }
}
