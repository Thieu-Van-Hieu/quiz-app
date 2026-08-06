# Quiz App v1.1.2

> **🐧 Linux Ecosystem, OCR Expansion & UI Bug Fixes**  
> **Nền tảng:** Windows Desktop & Linux (Flutter) · **Ngày phát hành:** 06/08/2026 ·  
> **Tác giả:** Mr.NoBody

---

## 🚀 Giới thiệu phiên bản

Chào mừng bạn đến với **Quiz App v1.1.2**! Bản cập nhật này đánh dấu bước tiến quan trọng khi **chính thức mở rộng hỗ
trợ sang hệ điều hành Linux**, tích hợp tính năng **OCR chụp màn hình đa nền tảng**, đồng thời tối ưu hóa hiệu năng khi
Import dữ liệu lớn và sửa các lỗi giao diện phát sinh từ phản hồi của người dùng.

---

## ✨ Điểm mới trong bản v1.1.2

### 🐧 Mở rộng Nền tảng Linux & OCR

- **Bộ chụp màn hình thông minh (`LinuxCaptureService`):** Tự động phát hiện công cụ chụp màn hình khả dụng trên Linux
  (hỗ trợ từ XFCE, GNOME, KDE đến Wayland)[cite: 1].
- **OCR đa nền tảng:** Tính năng quét ảnh trích xuất câu hỏi giờ đây đã hoạt động mượt mà trên Linux[cite: 1].
- **CI/CD Tự động hóa:** Thêm Workflows tự động hóa build ứng dụng, thông báo upgrade và dọn dẹp artifact rác trên máy
  ảo Linux[cite: 1].

### 📥 Tối ưu Giao diện Import Quizlet & OCR Dialog

- **Hiệu năng Lazy Load:** Áp dụng lazy load cho danh sách Import Quizlet, giải quyết triệt để hiện tượng treo UI khi
  chèn hàng trăm câu hỏi cùng lúc[cite: 1].
- **Không gian Editor mở rộng:** Nới rộng `AlertDialog` giúp dễ dàng thao tác với editor câu hỏi[cite: 1].
- **Đồng bộ theme:** Áp dụng bộ màu chuẩn cho `OCRDialog`[cite: 1].

### 🛠️ Sửa lỗi UI/UX

- **Sửa lỗi Snackbar:** Dứt điểm lỗi Snackbar treo không tự ẩn sau khi chờ hết timeout[cite: 1].
- **Đồng bộ Settings Page:** Cân chỉnh lại layout trang Cài đặt đồng bộ với tổng thể ứng dụng[cite: 1].
- **Chống vỡ layout:** Khắc phục lỗi tràn văn bản (overflow) tên Quiz ở trang câu hỏi[cite: 1].

---

## 📦 Hướng dẫn cài đặt

### Yêu cầu hệ thống

- **Windows:** Windows 10 / Windows 11 (64-bit).
- **Linux:** Các bản phân phối Linux phổ biến (Ubuntu, Linux Mint, Debian, Arch...) có sẵn công cụ chụp màn hình CLI
  (như `xfce4-screenshooter`, `gnome-screenshot`, `spectacle`, `maim`, `scrot`, hoặc `grimshot`)[cite: 1].

---

## 🔗 Liên kết dự án

- 📁 **Repository:** https://github.com/Thieu-Van-Hieu/quiz-app
- 📦 **Tất cả bản phát hành:** https://github.com/Thieu-Van-Hieu/quiz-app/releases
- 📬 **Kênh hỗ trợ kỹ thuật:** quiz.fpt@gmail.com

---

*Made with ❤️ by **Mr.NoBody** (Thiều Văn Hiếu)*