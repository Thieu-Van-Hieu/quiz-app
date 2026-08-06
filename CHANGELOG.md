## [1.1.2] — 2026-08-06

### ✨ Thêm mới

- **Hỗ trợ nền tảng Linux**: Triển khai `LinuxCaptureService` hỗ trợ chụp màn hình linh hoạt qua nhiều công cụ CLI
  (`xfce4-screenshooter`, `gnome-screenshot`, `spectacle`, `maim`, `scrot`, `grimshot`)[cite: 1].
- **Tích hợp OCR cho Linux**: Mở rộng tính năng trích xuất câu hỏi từ hình ảnh (OCR) cho hệ điều hành Linux[cite: 1].
- **Cấu hình Workflows CI/CD**: Thêm GitHub Actions workflow hỗ trợ tự động build ứng dụng trên máy ảo Linux, thông báo
  nâng cấp và dọn dẹp file thừa sau build[cite: 1].

### 🔧 Cải tiến

- **Mở rộng Path Service**: Cập nhật `path_service` tương thích và hỗ trợ tối đa hệ điều hành Linux[cite: 1].
- **Lazy Load cho Import Quizlet**: Áp dụng cơ chế lazy loading giúp danh sách import không bị giật lag hay treo UI khi
  xử lý số lượng câu hỏi lớn[cite: 1].
- **Tối ưu Editor Import**: Mở rộng giao diện `AlertDialog` giúp không gian nhập/sửa câu hỏi rộng rãi, dễ quan sát
  hơn[cite: 1].
- **Đồng bộ theme OCR Dialog**: Áp dụng hệ màu thiết kế mới cho hộp thoại OCR[cite: 1].

### 🐛 Sửa lỗi

- **Lỗi Snackbar**: Khắc phục triệt để lỗi Snackbar thông báo bị kẹt/không tự đóng khi hết thời gian chờ[cite: 1].
- **Đồng bộ trang Settings**: Cân chỉnh lại giao diện trang Cài đặt cho đồng bộ ngôn ngữ thiết kế chung[cite: 1].
- **Tràn văn bản Quiz Title**: Sửa lỗi vỡ/overflow khung hiển thị tên Quiz tại trang danh sách câu hỏi[cite: 1].

---

## [1.1.1] — 2026-06-26

### 🔧 Cải tiến

- **Chuyển ngữ cảnh nút hành động**: Tự động chuyển đổi nút `Next >>` thành `Finish` khi người dùng di chuyển đến câu
  hỏi cuối cùng của phiên học[cite: 1].
- **Gia cố Quiz Text Parser**: Bổ sung các tầng lọc dữ liệu nâng cao và kiểm tra an toàn mảng (index safety) nhằm nâng
  cao độ chính xác khi bóc tách dữ liệu thô[cite: 1].

### 🐛 Sửa lỗi

- **Ánh xạ phím tắt khi xáo trộn đáp án**: Sửa lỗi phím tắt nhanh (A, B, C, D) bị chọn sai vị trí sau khi bật chế độ
  trộn đáp án[cite: 1].
- **Lưu vị trí học (currentIndex)**: Sửa lỗi lưu sai `currentIndex` khi thoát đột ngột ở cả chế độ Học (Study) và Thi
  (Exam)[cite: 1].
- **Ô nhập thời gian (Duration Input)**: Cân chỉnh lại giao diện hiển thị đối với ô nhập liệu thời gian[cite: 1].

---