<div align="center">

# 📚 Quiz App

**Ứng dụng học tập flashcard & trắc nghiệm đa nền tảng (Windows & Linux)**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux-0078D6?logo=windows&logoColor=white)](https://flutter.dev/desktop)
[![ObjectBox](https://img.shields.io/badge/Database-ObjectBox-green)](https://objectbox.io)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.1.2-brightgreen)](RELEASE.md)

</div>

---

## 📋 Mục lục

- [Giới thiệu](#-giới-thiệu)
- [Tính năng](#-tính-năng)
- [Tech Stack](#-tech-stack)
- [Kiến trúc dự án](#-kiến-trúc-dự-án)
- [Cơ chế hoạt động đặc thù (OCR & Upgrader)](#-cơ-chế-hoạt-động-đặc-thù-ocr--upgrader)
- [Cài đặt & Chạy](#-cài-đặt--chạy)
- [Cấu trúc Database](#-cấu-trúc-database)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Giới thiệu

**Quiz App** là ứng dụng học tập offline dành cho máy tính (Windows & Linux), giúp người dùng tự xây dựng ngân hàng câu
hỏi cá nhân và luyện tập theo nhiều chế độ khác nhau.

Ứng dụng hoạt động hoàn toàn **offline** — dữ liệu lưu trữ cục bộ trên máy, không cần tài khoản hay Internet. Tích hợp
tính năng **OCR (Tesseract)** kết hợp công cụ chụp màn hình native của hệ thống cho phép quét vùng màn hình để bóc tách
câu hỏi tự động, đồng thời hỗ trợ **import/export từ Quizlet**, tự động kiểm tra phiên bản mới qua **Upgrader / Auto
Updater**.

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
- ✅ **Import/Export Quizlet** — hỗ trợ định dạng trắc nghiệm với custom separator, tích hợp **Lazy Load** xử lý mượt dữ
  liệu lớn
- ✅ **Nhập câu hỏi bằng OCR** — Chụp màn hình native (Windows Native CLI / Linux Capture Service) và nhận diện văn bản
  bằng Tesseract

### 🎓 Học tập

| Chế độ                      | Mô tả                                         |
|-----------------------------|-----------------------------------------------|
| 📖 **Học tập (Study)**      | Xem câu hỏi và đáp án dạng flashcard          |
| ✏️ **Luyện tập (Practice)** | Trả lời và nhận phản hồi ngay lập tức         |
| ⏱️ **Thi cử (Exam)**         | Giới hạn thời gian, chấm điểm sau khi nộp bài |

- Cấu hình phiên học: chọn khoảng câu hỏi, xáo trộn câu hỏi/đáp án, nạp nhanh cấu hình cũ
- Màn hình kết quả chi tiết: xem lại từng câu đã chọn, đáp án đúng/sai
- Trang chi tiết phiên học: thống kê và review toàn bộ câu hỏi sau khi hoàn thành

### ⚙️ Cài đặt & Hệ thống

- Tùy chỉnh **font chữ** (Microsoft Sans Serif, Arial, Times New Roman...) và **kích thước chữ**
- Cấu hình **phím tắt** cho các hành động học tập (bàn phím & chuột)
- Xóa toàn bộ dữ liệu môn học hoặc phiên học
- Kiểm tra & tự động thông báo cập nhật phiên bản mới (hỗ trợ cả Windows và Linux)

---

## 🛠️ Tech Stack

| Thành phần       | Công nghệ                                       | Phiên bản  |
|------------------|-------------------------------------------------|------------|
| Framework        | Flutter Desktop (Windows / Linux)               | 3.x        |
| Language         | Dart                                            | ^3.11.1    |
| State Management | Riverpod + Flutter Hooks                        | ^3.2.0     |
| Routing          | go_router                                       | ^17.1.0    |
| Local Database   | ObjectBox                                       | ^5.1.0     |
| Serialization    | dart_mappable                                   | ^4.6.0     |
| Chart            | fl_chart                                        | ^1.2.0     |
| OCR Engine       | Tesseract OCR                                   | ^0.2.3     |
| Capture Service  | `WindowsCaptureService` / `LinuxCaptureService` | Native CLI |
| Updater          | `auto_updater` (Windows) / `upgrader` (Linux)   | Latest     |

---

## 🔍 Cơ chế hoạt động đặc thù (OCR & Upgrader)

### 📸 1. Cơ chế Chụp màn hình & OCR

Do tính chất đa nền tảng, Quiz App sử dụng cơ chế chụp ảnh màn hình native tùy thuộc vào OS:

* **Trên Windows:** Gọi công cụ chụp màn hình native của Windows (`WindowsCaptureService`) để cắt vùng màn hình được
  chọn.
* **Trên Linux (`LinuxCaptureService`):** Hệ thống tự động quét và gọi một trong các CLI capture tool khả dụng trên máy
  người dùng theo thứ tự ưu tiên:
    1. `xfce4-screenshooter` (XFCE)
    2. `gnome-screenshot` (GNOME)
    3. `spectacle` (KDE)
    4. `maim` / `scrot` (X11)
    5. `grimshot` (Wayland)
* **Xử lý OCR:** Ảnh cắt xong được lưu tạm vào đường dẫn do `PathService` quản lý, sau đó đưa qua **Tesseract OCR
  Engine** để bóc tách chữ và đưa vào bộ phân tích dữ liệu (`QuizTextParser`).

### 🔄 2. Cơ chế Tự động Cập nhật (Upgrader)

* **Linux:** Sử dụng package `upgrader` kết hợp với thông báo phiên bản từ GitHub Releases / App Stream, giúp hiển thị
  Dialog gợi ý người dùng cập nhật phiên bản khi có bản build mới.
* **Windows:** Sử dụng `auto_updater` để tự động tải và chạy bộ cài đặt phiên bản mới.

---

## 🏗️ Kiến trúc dự án

Dự án áp dụng kiến trúc **Feature-based** kết hợp pattern **Repository + Notifier (Riverpod)**:

```

lib/
├── core/                         # Shared — dùng chung toàn app
│   ├── constants/               # AppColors, AppStrings
│   ├── extensions/              # Dart extensions tiện ích
│   ├── layout/                  # MainScreen: Sidebar + BreadcrumbBar
│   ├── services/                # ObjectBox, PathService, LinuxCaptureService, WindowsCaptureService
│   └── widgets/                 # BreadcrumbBar, Pagination, SearchBar, AppButton...
│
├── features/
│   ├── dashboard/               # Thống kê & phiên học gần đây
│   │
│   ├── library/                 # Quản lý ngân hàng câu hỏi
│   │   ├── data/                # Repositories (ObjectBox queries)
│   │   ├── models/              # Subject, Quiz, Question, Answer
│   │   ├── notifiers/           # Riverpod state notifiers
│   │   ├── pages/               # SubjectPage, QuizPage, QuestionPage
│   │   ├── services/            # QuizConverterService (JSON/Quizlet/OCR/Parser)
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

- Windows 10 / 11 (64-bit) hoặc các phân phối Linux (Ubuntu, Linux Mint, Debian, Arch...).
- [Flutter SDK](https://docs.flutter.dev/get-started/install/windows) ≥ 3.x (Dart ^3.11.1).
- [Tesseract OCR Engine](https://github.com/UB-Mannheim/tesseract/wiki) (cài đặt trên OS để ứng dụng gọi Tesseract API).
- **Đối với Linux:** Máy cần cài đặt ít nhất 1 công cụ chụp màn hình CLI (`xfce4-screenshooter`, `gnome-screenshot`,
  `spectacle`, `maim`, `scrot`, hoặc `grimshot`).

### Clone & Setup

```bash
# 1. Clone repo
git clone [https://github.com/Thieu-Van-Hieu/quiz-app.git](https://github.com/Thieu-Van-Hieu/quiz-app.git)
cd quiz-app

# 2. Cài dependencies
flutter pub get

# 3. Chạy code generation (ObjectBox + dart_mappable + Riverpod)
dart run build_runner build --delete-conflicting-outputs

```

### Chạy Development

```bash
# Windows
flutter run -d windows

# Linux
flutter run -d linux

```

### Build Release

```bash
# Windows
flutter build windows --release

# Linux
flutter build linux --release

```

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

* [x] Library module (Subject / Quiz / Question / Answer)
* [x] Learning module (Study / Practice / Exam)
* [x] Màn hình kết quả & chi tiết phiên học
* [x] Dashboard thống kê
* [x] Settings (font, phím tắt, xóa dữ liệu)
* [x] Import/Export JSON & Quizlet
* [x] OCR import với Native Screen Capture (`WindowsCaptureService` & `LinuxCaptureService`)
* [x] Auto-updater (Windows) & Upgrader integration (Linux)
* [x] App icon & Pastel Theme UI
* [x] Hỗ trợ chính thức Linux OS
* [ ] Hỗ trợ macOS
* [ ] Export / Import backup toàn bộ dữ liệu (Full DB Dump)
* [ ] Unit test & Integration test
* [ ] Import từ file CSV / Excel

---

## 🤝 Contributing

Mọi đóng góp đều được chào đón! Vui lòng làm theo các bước sau:

1. **Fork** repository này
2. Tạo branch mới: `git checkout -b feature/ten-tinh-nang`
3. Commit thay đổi: `git commit -m 'feat: thêm tính năng X'`
4. Push lên branch: `git push origin feature/ten-tinh-nang`
5. Mở **Pull Request**

---

## 📬 Liên hệ

* **Tác giả:** Thiều Văn Hiếu (Mr.NoBody)
* **Email hỗ trợ:** quiz.fpt@gmail.com
* **GitHub Repo:** [Thieu-Van-Hieu/quiz-app](https://github.com/Thieu-Van-Hieu/quiz-app)

---

## 📄 License

Dự án này được phân phối dưới giấy phép **MIT**. Xem file [LICENSE](https://www.google.com/search?q=LICENSE) để biết
thêm chi tiết.

---

Made with ❤️ by **Mr.NoBody**

*Nếu thấy hữu ích, hãy để lại một ⭐ cho dự án!*