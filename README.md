<div align="center">

# 📚 Quiz App

**Ứng dụng học tập flashcard & trắc nghiệm chạy trên Windows Desktop**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows&logoColor=white)](https://flutter.dev/desktop)
[![ObjectBox](https://img.shields.io/badge/Database-ObjectBox-green)](https://objectbox.io)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)
[![Version](https://img.shields.io/badge/Version-0.1.0--pre-orange)](RELEASE.md)

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

**Quiz App** là ứng dụng học tập offline dành cho Windows Desktop, giúp người dùng tự xây dựng ngân hàng câu hỏi cá nhân và luyện tập theo nhiều chế độ khác nhau.

Ứng dụng hoạt động hoàn toàn **offline** — dữ liệu lưu trữ cục bộ trên máy, không cần tài khoản hay Internet. Tích hợp **OCR** (Tesseract) cho phép chụp màn hình để nhập câu hỏi tự động, tiết kiệm thời gian soạn thảo.

> ⚠️ **Lưu ý:** Đây là phiên bản **pre-release v0.1.0**. Một số tính năng vẫn đang trong quá trình phát triển.

---

## ✨ Tính năng

### 📚 Quản lý Thư viện
- ✅ Tạo / sửa / xóa **Môn học (Subject)**
- ✅ Tạo / sửa / xóa **Bộ đề (Quiz)** theo từng môn
- ✅ Thêm **Câu hỏi & Đáp án** với phần giải thích chi tiết
- ✅ Tìm kiếm và phân trang
- ✅ **Nhập câu hỏi bằng OCR** — chụp màn hình, nhận diện văn bản tự động

### 🎓 Học tập

| Chế độ | Mô tả |
|--------|-------|
| 📖 **Học tập (Study)** | Xem câu hỏi và đáp án dạng flashcard |
| ✏️ **Luyện tập (Practice)** | Trả lời và nhận phản hồi ngay lập tức |
| ⏱️ **Thi cử (Exam)** | Giới hạn thời gian, chấm điểm sau khi nộp bài |

- Cấu hình phiên học: chọn khoảng câu hỏi, xáo trộn câu hỏi/đáp án
- Màn hình kết quả chi tiết sau mỗi phiên

### 🖥️ Giao diện
- Sidebar thu gọn/mở rộng (animated)
- Breadcrumb navigation
- Dialog xác nhận thoát ứng dụng

---


## 🛠️ Tech Stack

| Thành phần | Công nghệ |
|------------|-----------|
| Framework | [Flutter](https://flutter.dev) 3.x (Desktop) |
| Language | Dart 3.x |
| State Management | [Riverpod](https://riverpod.dev) + [Flutter Hooks](https://pub.dev/packages/flutter_hooks) |
| Routing | [go_router](https://pub.dev/packages/go_router) |
| Local Database | [ObjectBox](https://objectbox.io) |
| Serialization | [dart_mappable](https://pub.dev/packages/dart_mappable) |
| OCR | [Tesseract](https://github.com/tesseract-ocr/tesseract) + [screen_capturer](https://pub.dev/packages/screen_capturer) |

---

## 🏗️ Kiến trúc dự án

Dự án áp dụng kiến trúc **Feature-based** kết hợp với pattern **Repository + Notifier**:

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
│   ├── dashboard/               # Màn hình tổng quan (đang phát triển)
│   │
│   ├── library/                 # Quản lý ngân hàng câu hỏi
│   │   ├── data/                # Repositories (ObjectBox queries)
│   │   ├── models/              # Subject, Quiz, Question, Answer
│   │   ├── notifiers/           # Riverpod state notifiers
│   │   ├── pages/               # SubjectPage, QuizDetailPage, SubjectDetailPage
│   │   └── widgets/             # UI components
│   │
│   └── learning/                # Học tập
│       ├── data/                # LearningSession repositories
│       ├── enums/               # LearningMode (study/practice/exam)
│       ├── models/              # LearningSetting, LearningSession, Detail
│       ├── notifiers/           # Session state management
│       └── pages/               # StudyPage, PracticePage, ExamPage, ResultPage
│
├── routes/                      # AppRouter (go_router config)
└── utils/                       # OCR utility (Tesseract wrapper)
```

---

## 🚀 Cài đặt & Chạy

### Yêu cầu

- Windows 10 / 11 (64-bit)
- [Flutter SDK](https://docs.flutter.dev/get-started/install/windows) ≥ 3.x
- [Tesseract OCR](https://github.com/UB-Mannheim/tesseract/wiki) (nếu dùng tính năng scan)

### Clone & Setup

```bash
# 1. Clone repo
git clone https://github.com/<your-username>/quiz-app.git
cd quiz-app

# 2. Cài dependencies
flutter pub get

# 3. Chạy code generation (ObjectBox + dart_mappable)
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

Nếu muốn dùng tính năng OCR, cài Tesseract và cập nhật đường dẫn trong `lib/utils/ocr.dart`:

```dart
const String debugPath = r'C:\path\to\tesseract.exe';
```

Khi đóng gói production, đặt thư mục `tesseract_engine/` cạnh file `.exe` của app.

---

## 🗄️ Cấu trúc Database

Dữ liệu được lưu cục bộ bằng **ObjectBox**. Quan hệ giữa các entity:

```
Subject (1) ──────────────────────────────── (N) Quiz
                                                   │
                                    ┌──────────────┘
                                    │
                              (N) Question ──── (N) Answer
                                    │
                             (N) LearningSessionDetail
                                    │
                             (1) LearningSession ──── Quiz
```

| Entity | Mô tả |
|--------|-------|
| `Subject` | Môn học (có code & name, được index) |
| `Quiz` | Bộ đề thuộc một môn học |
| `Question` | Câu hỏi thuộc một bộ đề, có phần giải thích |
| `Answer` | Đáp án cho câu hỏi |
| `LearningSession` | Một phiên học: mode, cấu hình, thống kê |
| `LearningSessionDetail` | Chi tiết từng câu trả lời trong phiên |

---

## 🗺️ Roadmap

- [x] Library module (Subject / Quiz / Question / Answer)
- [x] Learning module (Study / Practice / Exam)
- [x] OCR import
- [x] Sidebar thu gọn
- [ ] Dashboard với thống kê tổng quan
- [ ] Settings (theme, ngôn ngữ...)
- [ ] Export / Import dữ liệu (backup JSON)
- [ ] Hỗ trợ macOS & Linux
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

| Prefix | Dùng khi |
|--------|----------|
| `feat:` | Thêm tính năng mới |
| `fix:` | Sửa lỗi |
| `refactor:` | Tái cấu trúc code |
| `docs:` | Cập nhật tài liệu |
| `chore:` | Cập nhật dependencies, config |

---

## 📄 License

Dự án này được phân phối dưới giấy phép **MIT**. Xem file [LICENSE](LICENSE) để biết thêm chi tiết.

---

<div align="center">

Made with ❤️ by **Mr.NoBody**

*Nếu thấy hữu ích, hãy để lại một ⭐ cho dự án!*

</div>
