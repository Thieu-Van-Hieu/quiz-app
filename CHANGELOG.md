# Changelog

Tất cả thay đổi đáng chú ý của dự án được ghi lại tại đây.  
Định dạng theo [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.0.0] — 2026-04-12

### ✨ Thêm mới

- **Setting module** hoàn chỉnh: tùy chỉnh font chữ, kích thước chữ và phím tắt cho các hành động học tập (câu tiếp
  theo, câu trước, hiện đáp án, kiểm tra đáp án) — hỗ trợ cả bàn phím lẫn chuột
- **Dashboard** với thống kê tổng quan: biểu đồ hoạt động 7 ngày, tỉ lệ đúng, tỉ lệ đã xem và danh sách phiên học gần
  đây
- **Trang chi tiết phiên học** (`learning_session_detail_page`): xem lại toàn bộ câu hỏi, đáp án đúng/sai và câu đã chọn
  sau mỗi phiên
- **Export Quizlet**: xuất bộ đề ra định dạng Quizlet với custom separator
- **Auto-updater**: tự động kiểm tra và cập nhật phiên bản mới
- **App icon** cho Windows

### 🔧 Cải tiến

- Áp dụng font và phím tắt từ Setting vào tất cả các chế độ học
- Kết quả phiên học chi tiết hơn: practice hiển thị số câu đã xem, study/exam hiển thị đúng/sai
- Chuyển `Checkbox` sang `RetroCheckbox` trong màn hình học
- Font chung được tách ra dùng cho toàn app

### 🐛 Sửa lỗi

- Sửa màn hình trắng khi hoàn thành session và pop context
- Sửa hiển thị câu hỏi bị tràn khi nội dung quá dài (thêm scroll)
- Sửa logic hiển thị câu đã chọn từ ID sang index
- Sửa feedback_column cho trường hợp khoanh tất cả đáp án
- Sửa chuột phải thay chuột trái cho shortcut next trong exam_page
- Thêm kiểm tra debug mode trước khi gọi auto-updater

---

## [0.1.2] — 2026-04-11

### ✨ Thêm mới

- **Export Quizlet**: xuất bộ đề ra format Quizlet
- **Import Quizlet multiple choice**: nhập bộ đề từ Quizlet với custom separator cho cả import lẫn export
- Thêm bộ quiz có sẵn (file `.bin` và `.json`) trong thư mục `quizzes/`

### 🐛 Sửa lỗi

- Sửa màn hình trắng sau khi hoàn thành phiên học
- Sửa câu hỏi dài bị mất chữ / tràn layout
- Nâng version lên 0.1.2

---

## [0.1.1] — 2026-04-11

### 🐛 Sửa lỗi

- Sửa import Quizlet bị giới hạn ở 4 câu
- Tự động thoát chế độ chỉnh sửa khi hết lỗi câu hỏi
- Nâng version lên 0.1.1

---

## [0.1.0] — 2026-04-11 *(Pre-release)*

### ✨ Thêm mới

- **Library module**: quản lý Subject → Quiz → Question → Answer (CRUD đầy đủ)
- **Learning module**: ba chế độ học Study / Practice / Exam
- **Import/Export JSON** cho bộ đề
- **Import Quizlet** (multiple choice)
- **OCR import**: nhập câu hỏi bằng cách chụp màn hình (Tesseract)
- Sidebar thu gọn/mở rộng (animated)
- Breadcrumb navigation
- Routing với `go_router` + `StatefulShellRoute`
- Tích hợp ObjectBox làm local database
- Chuyển từ Isar sang ObjectBox
- Phân trang chung cho toàn app
- Auto cleanup: xóa object mồ côi khi khởi động

---

## [0.0.1] — 2026-03-31 *(Khởi tạo)*

- Khởi tạo cấu trúc dự án Flutter Desktop
- Tích hợp Isar database (sau đó chuyển sang ObjectBox)
- Triển khai hệ thống routing với GoRouter và khung Sidebar