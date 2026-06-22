# Changelog

Tất cả thay đổi đáng chú ý của dự án được ghi lại tại đây.  
Định dạng theo [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.1.0] — 2026-06-22

### ✨ Thêm mới

- **Cấu hình nhanh từ lịch sử**: Thêm tính năng và nút bấm động hỗ trợ nạp nhanh cấu hình cũ để làm lại bài học.
- **Tính năng nhảy trang**: Nâng cấp bộ phân trang (`AppPagination`) cho phép nhảy nhanh đến số trang bất kỳ.
- **Mở thư mục sau Export**: Thêm nút mở trực tiếp thư mục chứa file ngay sau khi xuất dữ liệu thành công.
- **Hệ thống Button dùng chung**: Khởi tạo và đồng bộ hóa toàn bộ nút bấm trong dự án qua bộ đôi `AppButton` và
  `AppActionButton`.

### 🔧 Cải tiến

- **Lột lác giao diện**: Chuyển đổi toàn bộ app sang hệ màu Pastel hiện đại, dịu mắt; sửa lại màu nền cho
  `question_page`.
- **Refactor kiến trúc Widget**: Tách nhỏ Dropdown, Menu và các khối UI thành các widget độc lập, dễ tái sử dụng.
- **Nâng cấp Pagination**: Thay thế toàn bộ widget `InkWell` thô sơ trong bộ phân trang sang `AppButton` chuẩn.
- **Chuẩn hóa tên gọi**: Đổi tên các thành phần từ `item` sang `card` (ví dụ: `LearningResultCard`) giúp cấu trúc code
  rõ nghĩa hơn.
- **Tối ưu hóa thanh tìm kiếm**: Sửa lại style của `AppSearchBar` để tăng độ tương phản và hiển thị rõ ràng hơn.

### 🐛 Sửa lỗi

- **Cô lập Database (ObjectBox)**: Tách biệt hoàn toàn thư mục lưu trữ DB của môi trường Debug và Release để tránh xung
  đột dữ liệu.
- **Đồng bộ hóa Export**: Khắc phục triệt để lỗi dữ liệu sau khi lưu DB nhưng khi export vẫn ra bộ quiz cũ.
- **Trộn đáp án**: Sửa lỗi logic trong tính năng trộn ngẫu nhiên vị trí đáp án.

---

## [1.0.2] — 2026-04-21

### ✨ Thêm mới

- **Chuyển câu nhanh**: Thêm tính năng chuyển đổi nhanh thứ tự câu hỏi trong màn hình làm bài.
- **Mở rộng bộ Import**: Hỗ trợ tối ưu import dữ liệu từ nguồn Quizlet và tệp văn bản thô (TXT).
- **Shimmer Effect**: Bổ sung hiệu ứng tải trang (Shimmer) giúp giao diện mượt mà hơn khi đợi dữ liệu.

### 🔧 Cải tiến

- **Tách nhỏ cấu trúc**: Tiến hành bóc tách các trang lớn (`SubjectPage`, `QuizPage`, `QuestionPage`) thành các widget
  con chuyên biệt để dễ bảo trì.
- **Tối ưu State Management**: Tái cấu trúc lại cách quản lý state (trạng thái) của các tác vụ tác động đến dữ liệu (như
  xóa).
- **UX điều hướng tự động**: Tự động tính toán quay lui trang hoặc chuyển hướng thông minh sau khi người dùng thực hiện
  xóa phần tử cuối cùng của trang.

### 🐛 Sửa lỗi

- **Breadcrumb Navigation**: Sửa lỗi tính toán sai đường dẫn hiển thị (Path) trên thanh Breadcrumb.
- **Dữ liệu Quiz**: Sửa lại các câu lệnh import sai cấu trúc trong file dữ liệu `PMG201c - QuizApp.json`.
- **Tài liệu**: Cập nhật bộ quiz mẫu có sẵn cho môn `MLN111` và căn chỉnh lại cấu trúc đề `SYB302c`.

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