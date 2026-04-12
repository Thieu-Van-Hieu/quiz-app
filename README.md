<div align="center">

# 📚 Quiz App

**Ứng dụng học tập flashcard & trắc nghiệm chạy trên Windows Desktop**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows&logoColor=white)](https://flutter.dev/desktop)
[![ObjectBox](https://img.shields.io/badge/Database-ObjectBox-green)](https://objectbox.io)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen)](RELEASE.md)

</div>

---

## 📋 Mục lục

- [Giới thiệu](#-giới-thiệu)
- [Tính năng](#-tính-năng)
- [Tech Stack](#-tech-stack)
- [Kiến trúc dự án](#-kiến-trúc-dự-án)
- [Cài đặt & Chạy](#-cài-đặt--chạy)
- [Cấu trúc Database](#-cấu-trúc-database)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Giới thiệu

**Quiz App** là ứng dụng học tập offline dành cho Windows Desktop, giúp người dùng tự xây dựng ngân hàng câu hỏi cá nhân
và luyện tập theo nhiều chế độ khác nhau.

Ứng dụng hoạt động hoàn toàn **offline** — dữ liệu lưu trữ cục bộ trên máy, không cần tài khoản hay Internet. Tích hợp *
*OCR** (Tesseract) cho phép chụp màn hình để nhập câu hỏi tự động, đồng thời hỗ trợ **import/export từ Quizlet** và **tự
động cập nhật** phiên bản mới.

---

## ✨ Tính năng

### 📊 Dashboard

- Hiển thị các phiên học gần đây
- Biểu đồ số câu học trong 7 ngày qua
- Thống kê tổng quan: tỉ lệ đúng, tỉ lệ đã xem

### 📚 Quản lý Thư viện

- ✅ Tạo / sửa / xóa **Môn học (Subject)**
- ✅ Tạo / sửa / xóa **Bộ đề (Quiz)** theo từng môn
- ✅ Thêm **Câu hỏi & Đáp án** với phần giải thích chi tiết
- ✅ Tìm kiếm và phân trang
- ✅ **Import/Export JSON** — chia sẻ bộ đề dễ dàng
- ✅ **Import/Export Quizlet** — hỗ trợ format multiple choice với custom separator
- ✅ **Nhập câu hỏi bằng OCR** — chụp màn hình, nhận diện văn bản tự động

### 🎓 Học tập

| Chế độ                      | Mô tả                                         |
|-----------------------------|-----------------------------------------------|
| 📖 **Học tập (Study)**      | Xem câu hỏi và đáp án dạng flashcard          |
| ✏️ **Luyện tập (Practice)** | Trả lời và nhận phản hồi ngay lập tức         |
| ⏱️ **Thi cử (Exam)**        | Giới hạn thời gian, chấm điểm sau khi nộp bài |

- Cấu hình phiên học: chọn khoảng câu hỏi, xáo trộn câu hỏi/đáp án
- Màn hình kết quả chi tiết: xem lại từng câu đã chọn, đáp án đúng/sai
- Trang chi tiết phiên học: thống kê và review toàn bộ câu hỏi sau khi hoàn thành

### ⚙️ Cài đặt

- Tùy chỉnh **font chữ** (Microsoft Sans Serif, Arial, Times New Roman) và **kích thước chữ**
- Cấu hình **phím tắt** cho các hành động học tập — hỗ trợ cả bàn phím lẫn chuột:
    - Câu tiếp theo / Câu trước đó
    - Hiện/ẩn đáp án
    - Kiểm tra câu trả lời
- Xóa toàn bộ dữ liệu môn học hoặc phiên học
- Liên kết nhanh tới GitHub repo và trang releases

### 🖥️ Giao diện & Tiện ích

- Sidebar thu gọn/mở rộng (animated)
- Breadcrumb navigation
- **Tự động cập nhật** phiên bản mới (auto-updater)
- Dialog xác nhận thoát ứng dụng

---

## 🛠️ Tech Stack

| Thành phần       | Công nghệ                   | Phiên bản |
|------------------|-----------------------------|-----------|
| Framework        | Flutter Desktop             | 3.x       |
| Language         | Dart                        | ^3.11.1   |
| State Management | Riverpod + Flutter Hooks    | ^3.2.0    |
| Routing          | go_router                   | ^17.1.0   |
| Local Database   | ObjectBox                   | ^5.1.0    |
| Serialization    | dart_mappable               | ^4.6.0    |
| Chart            | fl_chart                    | ^1.2.0    |
| OCR              | Tesseract + screen_capturer | ^0.2.3    |
| Auto Update      | auto_updater                | ^1.0.0    |

---

## 🏗️ Kiến trúc dự án

Dự án áp dụng kiến trúc **Feature-based** kết hợp pattern **Repository + Notifier (Riverpod)**:

```
lib/
├── core/                        # Shared — dùng chung toàn app
│   ├── constants/               # AppColors, AppStrings
│   ├── extensions/              # Dart extensions tiện ích
│   ├── layout/                  # MainScreen: Sidebar + BreadcrumbBar
│   ├── services/                # ObjectBox, PathService, DeviceInfo, Cleanup
│   └── widgets/                 # BreadcrumbBar, Pagination, SearchBar...
│
├── features/
│   ├── dashboard/               # Thống kê & phiên học gần đây
│   │
│   ├── library/                 # Quản lý ngân hàng câu hỏi
│   │   ├── data/                # Repositories (ObjectBox queries)
│   │   ├── models/              # Subject, Quiz, Question, Answer
│   │   ├── notifiers/           # Riverpod state notifiers
│   │   ├── pages/               # SubjectPage, QuizPage, QuestionPage
│   │   ├── services/            # QuizConverterService (JSON/Quizlet/OCR)
│   │   └── widgets/             # UI components
│   │
│   ├── learning/                # Học tập
│   │   ├── data/                # LearningSession repositories
│   │   ├── enums/               # LearningMode (study/practice/exam)
│   │   ├── models/              # LearningSetting, LearningSession, Detail
│   │   ├── notifiers/           # Session state management
│   │   ├── pages/               # Study/Practice/Exam/Result/Detail pages
│   │   └── widgets/             # RetroCheckbox, AnswerColumn, Clock...
│   │
│   └── setting/                 # Cài đặt ứng dụng
│       ├── data/                # AppConfigRepository
│       ├── enums/               # PhysicalKey, ShortcutAction
│       ├── models/              # AppConfig
│       ├── notifiers/           # AppConfigNotifier
│       └── pages/               # SettingPage
│
├── routes/                      # AppRouter (go_router config)
└── utils/                       # OCR utility (Tesseract wrapper)
```

---

## 🚀 Cài đặt & Chạy

### Yêu cầu

- Windows 10 / 11 (64-bit)
- [Flutter SDK](https://docs.flutter.dev/get-started/install/windows) ≥ 3.x (Dart ^3.11.1)
- [Tesseract OCR](https://github.com/UB-Mannheim/tesseract/wiki) (nếu dùng tính năng scan màn hình)

### Clone & Setup

```bash
# 1. Clone repo
git clone https://github.com/Thieu-Van-Hieu/quiz-app.git
cd quiz-app

# 2. Cài dependencies
flutter pub get

# 3. Chạy code generation (ObjectBox + dart_mappable + Riverpod)
dart run build_runner build --delete-conflicting-outputs
```

### Chạy Development

```bash
flutter run -d windows
```

### Build Release

```bash
flutter build windows --release
```

File build xuất ra tại: `build/windows/x64/runner/Release/`

### Cấu hình OCR *(tùy chọn)*

Cài Tesseract và cập nhật đường dẫn trong `lib/utils/ocr.dart`:

```dart

const String debugPath = r'C:\path\to\tesseract.exe';
```

Khi đóng gói production, đặt thư mục `tesseract_engine/` cạnh file `.exe` của app.

---

## 🗄️ Cấu trúc Database

Dữ liệu được lưu cục bộ bằng **ObjectBox**:

```
Subject (1) ──→ (N) Quiz (1) ──→ (N) Question (1) ──→ (N) Answer
                      │
                      └──→ (N) LearningSession (1) ──→ (N) LearningSessionDetail
```

| Entity                  | Mô tả                                             |
|-------------------------|---------------------------------------------------|
| `Subject`               | Môn học (code & name, có index để tìm kiếm nhanh) |
| `Quiz`                  | Bộ đề thuộc một môn học                           |
| `Question`              | Câu hỏi kèm phần giải thích                       |
| `Answer`                | Đáp án cho câu hỏi                                |
| `LearningSession`       | Phiên học: mode, cấu hình, thống kê kết quả       |
| `LearningSessionDetail` | Chi tiết từng câu trả lời trong phiên             |
| `AppConfig`             | Cấu hình ứng dụng: font, phím tắt                 |

---

## 🗺️ Roadmap

- [x] Library module (Subject / Quiz / Question / Answer)
- [x] Learning module (Study / Practice / Exam)
- [x] Màn hình kết quả & chi tiết phiên học
- [x] Dashboard thống kê
- [x] Settings (font, phím tắt, xóa dữ liệu)
- [x] Import/Export JSON & Quizlet
- [x] OCR import
- [x] Auto-updater
- [x] App icon
- [ ] Hỗ trợ macOS & Linux
- [ ] Export / Import backup toàn bộ dữ liệu
- [ ] Unit test & Integration test
- [ ] Import từ file CSV / Excel

---

## 🤝 Contributing

Mọi đóng góp đều được chào đón! Vui lòng làm theo các bước sau:

1. **Fork** repository này
2. Tạo branch mới: `git checkout -b feature/ten-tinh-nang`
3. Commit thay đổi: `git commit -m 'feat: thêm tính năng X'`
4. Push lên branch: `git push origin feature/ten-tinh-nang`
5. Mở **Pull Request**

### Quy tắc commit

Dự án sử dụng [Conventional Commits](https://www.conventionalcommits.org/):

| Prefix      | Dùng khi                      |
|-------------|-------------------------------|
| `feat:`     | Thêm tính năng mới            |
| `fix:`      | Sửa lỗi                       |
| `refactor:` | Tái cấu trúc code             |
| `docs:`     | Cập nhật tài liệu             |
| `chore:`    | Cập nhật dependencies, config |

---

## 📬 Liên hệ

- **Tác giả:** Thiều Văn Hiếu (Mr.NoBody)
- **Email hỗ trợ:** quiz.fpt@gmail.com
- **GitHub:** [Thieu-Van-Hieu/quiz-app](https://github.com/Thieu-Van-Hieu/quiz-app)

---

## 📄 License

Dự án này được phân phối dưới giấy phép **MIT**. Xem file [LICENSE](LICENSE) để biết thêm chi tiết.

---

<div align="center">

Made with ❤️ by **Mr.NoBody**

*Nếu thấy hữu ích, hãy để lại một ⭐ cho dự án!*

</div>