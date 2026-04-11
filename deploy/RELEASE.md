# Quiz App — Pre-Release v0.1.0

> **Status:** Pre-release · **Platform:** Windows Desktop (Flutter)  
> **Release Date:** 2026-04-11 · **Author:** Mr.NoBody

---

## 🚀 Giới thiệu

**Quiz App** là ứng dụng học tập dạng flashcard/trắc nghiệm chạy trên **Windows Desktop**, được xây dựng bằng Flutter. Ứng dụng cho phép người dùng tự tạo và quản lý ngân hàng câu hỏi, sau đó luyện tập thông qua ba chế độ học tập khác nhau với khả năng theo dõi tiến độ chi tiết.

---

## ✨ Tính năng trong phiên bản này

### 📚 Quản lý thư viện (Library)
- Tạo, chỉnh sửa, xóa **Môn học (Subject)** với mã môn và tên
- Tạo, chỉnh sửa, xóa **Bộ câu hỏi (Quiz)** thuộc từng môn học
- Thêm, chỉnh sửa, xóa **Câu hỏi (Question)** và các **Đáp án (Answer)**
- Hỗ trợ tìm kiếm và phân trang trong danh sách
- Import câu hỏi nhanh thông qua **OCR** (chụp màn hình → nhận diện văn bản)

### 🎓 Học tập (Learning)
Ba chế độ học tập:

| Chế độ | Mô tả |
|--------|-------|
| **Học tập (Study)** | Xem câu hỏi và đáp án, lật thẻ kiểu flashcard |
| **Luyện tập (Practice)** | Trả lời câu hỏi, nhận phản hồi ngay lập tức |
| **Thi cử (Exam)** | Giới hạn thời gian, nộp bài và chấm điểm |

- Cài đặt phiên học: chọn khoảng câu hỏi, bật/tắt xáo trộn câu hỏi & đáp án
- Tùy chỉnh giới hạn thời gian cho chế độ thi
- Màn hình **Kết quả** chi tiết sau mỗi phiên học

### 🖥️ Giao diện
- Layout sidebar có thể thu gọn/mở rộng
- Breadcrumb navigation
- Routing bằng `go_router` với `StatefulShellRoute`
- Hỗ trợ dialog xác nhận thoát ứng dụng

---

## 🏗️ Kiến trúc & Tech Stack

| Thành phần | Công nghệ |
|------------|-----------|
| Framework | Flutter (Desktop — Windows) |
| State Management | Riverpod (`hooks_riverpod`) + Flutter Hooks |
| Routing | `go_router` |
| Local Database | ObjectBox |
| Serialization | `dart_mappable` |
| OCR Engine | Tesseract (bundled) + `screen_capturer` |

**Cấu trúc thư mục:**
```
lib/
├── core/               # Shared utilities, widgets, services
│   ├── constants/      # AppColors, AppStrings
│   ├── extensions/     # Dart extensions
│   ├── layout/         # MainScreen, Sidebar
│   ├── services/       # ObjectBox, Path, DeviceInfo, Cleanup
│   └── widgets/        # BreadcrumbBar, Pagination, SearchBar...
├── features/
│   ├── dashboard/      # Màn hình chính
│   ├── library/        # Quản lý Subject → Quiz → Question → Answer
│   └── learning/       # Study / Practice / Exam + kết quả
├── routes/             # AppRouter, AppRouteConfig
└── utils/              # OCR utility
```

**Data model:**
```
Subject (1) ──→ (N) Quiz (1) ──→ (N) Question (1) ──→ (N) Answer
                  │
                  └──→ (N) LearningSession (1) ──→ (N) LearningSessionDetail
```

---

## ⚠️ Known Issues & Limitations

- Ứng dụng hiện **chỉ hỗ trợ Windows Desktop**; chưa có build cho macOS/Linux/Mobile
- Tính năng **Dashboard** đang ở giai đoạn khởi tạo, chưa có nội dung thống kê
- Tính năng **Settings** chưa được triển khai
- Đường dẫn Tesseract OCR debug hiện đang hardcode theo máy phát triển
- Chưa có chức năng export/import dữ liệu (backup)
- Chưa có unit test / integration test

---

## 📦 Cài đặt & Chạy

### Yêu cầu
- Windows 10/11 (64-bit)
- Flutter SDK ≥ 3.x
- Tesseract OCR engine (nếu dùng tính năng scan)

### Development
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d windows
```

### Build release
```bash
flutter build windows --release
```

---

## 📝 Changelog

### v0.1.0 (2026-04-11) — Initial Pre-release
- Khởi tạo dự án Flutter Desktop
- Triển khai Library module: Subject, Quiz, Question, Answer
- Triển khai Learning module: Study, Practice, Exam
- Tích hợp ObjectBox làm local database
- Tích hợp OCR với Tesseract
- Layout sidebar có thể thu gọn
- Routing với go_router

---

*Made with ❤️ by Mr.NoBody*
