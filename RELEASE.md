# Quiz App v1.0.0

> **🎉 First Stable Release**  
> **Platform:** Windows Desktop (Flutter) · **Date:** 12/04/2026 · **Author:** Mr.NoBody

---

## 🚀 Giới thiệu

Đây là phiên bản **stable đầu tiên** của Quiz App — ứng dụng học tập flashcard & trắc nghiệm chạy hoàn toàn offline trên
Windows Desktop. So với pre-release `v0.1.0`, phiên bản này bổ sung đầy đủ Dashboard, Settings, chi tiết phiên học và tự
động cập nhật.

---

## ✨ Có gì mới trong v1.0.0

### 🆕 Tính năng hoàn toàn mới

- **Dashboard**: biểu đồ hoạt động 7 ngày, thống kê tỉ lệ đúng/đã xem, danh sách phiên học gần đây
- **Settings**: tùy chỉnh font chữ, cỡ chữ và phím tắt bàn phím/chuột cho mọi hành động học tập
- **Chi tiết phiên học**: review lại toàn bộ câu hỏi, câu đã chọn và đáp án đúng/sai
- **Export Quizlet**: xuất bộ đề ra format Quizlet với separator tùy chỉnh
- **Auto-updater**: tự động kiểm tra phiên bản mới khi khởi động
- **App icon** cho Windows

### 🔧 Cải tiến đáng chú ý

- Font chữ từ Settings được áp dụng vào tất cả màn hình học
- Phím tắt tùy chỉnh hoạt động trong cả Study, Practice và Exam
- Kết quả phiên học chi tiết hơn theo từng chế độ

### 🐛 Lỗi đã sửa (kể từ v0.1.x)

- Màn hình trắng khi hoàn thành session
- Câu hỏi dài bị tràn layout — đã thêm scroll
- Logic hiển thị câu đã chọn (từ ID sang index)
- Import Quizlet bị giới hạn 4 câu
- Shortcut chuột sai trong exam_page

---

## 📦 Cài đặt

### Yêu cầu

- Windows 10 / 11 (64-bit)

### Hướng dẫn

1. Tải file `QuizApp_Setup_v1.0.0.exe` trong phần **Assets** bên dưới
2. Chạy file installer và làm theo hướng dẫn
3. Sau khi cài xong, mở **Quiz App** từ Start Menu hoặc shortcut trên Desktop

> Tính năng **OCR scan màn hình** đã hoạt động ngay sau khi cài đặt — Tesseract engine được bundle sẵn trong installer,
> không cần cài thêm gì.

---

## 📋 Changelog đầy đủ

Xem [CHANGELOG.md](CHANGELOG.md) để biết toàn bộ lịch sử thay đổi.

---

## 🔗 Liên kết

- 📁 **Repo:** https://github.com/Thieu-Van-Hieu/quiz-app
- 📦 **Releases:** https://github.com/Thieu-Van-Hieu/quiz-app/releases
- 📚 **Bộ đề có sẵn (JSON):** https://github.com/Thieu-Van-Hieu/quiz-app/tree/main/quizzes/current
- 📬 **Hỗ trợ:** quiz.fpt@gmail.com

---

*Made with ❤️ by **Mr.NoBody** (Thiều Văn Hiếu)*