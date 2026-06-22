# Quiz App v1.1.0

> **🎨 UI/UX Refactor & Feature Expansion** > **Nền tảng:** Windows Desktop (Flutter) · **Ngày phát hành:** 22/06/2026 ·
**Tác giả:** Mr.NoBody

---

## 🚀 Giới thiệu phiên bản

Chào mừng bạn đến với **Quiz App v1.1.0**! Bản cập nhật này đem tới một diện mạo hoàn toàn mới nịnh mắt hơn nhờ bảng màu
Pastel hiện đại, khắc phục các vấn đề liên quan tới cơ sở dữ liệu offline và cung cấp trải nghiệm phân trang tốt hơn rất
nhiều cho người dùng máy tính.

---

## ✨ Điểm mới trong bản v1.1.0

### 🆕 Tính năng & Giao diện mới

- **Pastel UI Theme:** Toàn bộ hệ thống màu sắc được làm mới theo phong cách Pastel dịu mát, áp dụng đồng bộ trên nền và
  trang hiển thị câu hỏi (`question_page`).
- **Nạp cấu hình nhanh:** Khôi phục nhanh trạng thái trộn đề, trộn đáp án và bộ câu hỏi từ một phiên học cũ trực tiếp
  ngay tại danh sách lịch sử.
- **Nhảy trang (Pagination):** Hỗ trợ gõ trực tiếp số trang để chuyển tiếp ngay lập tức thay vì phải bấm từng trang thủ
  công.
- **Tự động mở thư mục:** Hệ thống tự động mở thư mục Windows Explorer ngay khi tệp bộ đề được Export thành công.

### 🔧 Tối ưu hóa & Tái cấu trúc (Refactor)

- **Thống nhất hệ thống nút bấm:** Chuyển đổi toàn bộ nút riêng lẻ sang widget dùng chung `AppButton` và
  `AppActionButton`.
- **Tách biệt Widget Core:** Menu điều hướng, thanh Dropdown và cấu trúc thẻ card (`LearningResultCard`) được tách riêng
  để tối ưu bộ nhớ và hiệu năng kết xuất.
- **Sửa lỗi đồng bộ ObjectBox:** Khắc phục lỗi hiển thị quiz cũ khi xuất tệp dữ liệu và lỗi logic trộn vị trí đáp án
  trắc nghiệm.
- **An toàn dữ liệu phát triển:** Tách biệt vị trí ghi dữ liệu SQLite/ObjectBox giữa bản chạy thử (Debug) và bản cài đặt
  chính thức (Release).

---

## 📦 Hướng dẫn cài đặt

### Yêu cầu hệ thống

- Hệ điều hành: Windows 10 / Windows 11 (64-bit).

### Các bước thực hiện

1. Tải về tệp cài đặt `QuizApp_Setup_v1.1.0.exe` tại mục **Assets** ngay phía dưới.
2. Mở tệp `.exe` vừa tải và tiến hành cài đặt theo các bước trên màn hình.
3. Chạy ứng dụng từ màn hình Desktop. Hệ thống cơ sở dữ liệu cũ từ phiên bản `1.0.x` của bạn sẽ tự động được giữ lại
   nguyên vẹn và nâng cấp an toàn.

---

## 🔗 Liên kết dự án

- 📁 **Repository:** https://github.com/Thieu-Van-Hieu/quiz-app
- 📦 **Tất cả bản phát hành:** https://github.com/Thieu-Van-Hieu/quiz-app/releases
- 📬 **Kênh hỗ trợ kỹ thuật:** quiz.fpt@gmail.com

---

*Made with ❤️ by **Mr.NoBody** (Thiều Văn Hiếu)*