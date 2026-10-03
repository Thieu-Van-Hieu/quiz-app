# Quiz App v1.2.1

> **☁️ Kho đề online & 🐛 Sửa lỗi cập nhật giao diện**  
> **Nền tảng:** Windows Desktop & Linux (Flutter) · **Ngày phát hành:** 03/10/2026 ·  
> **Tác giả:** Mr.NoBody

---

## 🚀 Giới thiệu phiên bản

**Quiz App v1.2.1** là bản vá cho v1.2.0. Điểm chính là trang **Kho đề**: bạn không cần tự tải file JSON trên GitHub
rồi import thủ công nữa, chỉ cần mở Kho đề và bấm 1 nút để tải và import bộ đề có sẵn. Bản này cũng sửa lỗi gán phím tắt
trong Cài đặt phải khởi động lại mới thấy, và lỗi dữ liệu không tự cập nhật khi chuyển qua lại giữa các trang.

---

## ✨ Điểm mới trong bản v1.2.1

### ☁️ Kho đề online

- **Mục "Kho đề" mới trên sidebar:** xem toàn bộ bộ đề có sẵn trên GitHub của dự án mà không cần mở trình duyệt.
- **Biết ngay bộ đề mới hay cũ:** mỗi bộ đề có nhãn *Mới cập nhật* / *Cập nhật gần đây* / *Đã lâu* / *Lâu chưa cập
  nhật*, kèm ngày cập nhật (vd. "Cập nhật 2 ngày trước") và dung lượng.
- **Biết bộ đề nào đã có trên máy:** nhãn *Đã import*, hoặc *Có bản mới* khi tác giả vừa sửa bộ đề bạn đã import.
- **Tải & import 1 nút:** tự chọn đúng môn học theo mã môn (chưa có thì tạo môn mới), kiểm tra câu trùng như import
  thường, báo ngay nếu tên bộ đề đã tồn tại để bạn đổi tên.
- **Tìm kiếm, lọc và sắp xếp:** lọc bộ đề *Chưa import* / *Có bản mới*, sắp xếp theo ngày cập nhật hoặc tên.
- **Vẫn dùng được khi mất mạng:** hiển thị lại danh sách của lần tải trước.
- Menu **Import** trong trang bộ đề có thêm lối tắt **"Kho đề online"**; import file JSON / Binary / Quizlet vẫn giữ
  nguyên.

### 🐛 Sửa lỗi

- **Cài đặt:** gán / xoá phím tắt, bật tắt phím nhanh A-Z, đổi font và cỡ chữ giờ hiển thị ngay, không cần khởi động
  lại ứng dụng.
- **Dữ liệu tự cập nhật giữa các trang:** môn học, bộ đề được tạo ở trang khác (vd. import từ Kho đề, tạo từ trang Công
  cụ) giờ hiện ngay khi quay lại Thư viện.

---

## 📦 Hướng dẫn cài đặt

### Yêu cầu hệ thống

- **Windows:** Windows 10 / Windows 11 (64-bit).
- **Linux:** Các bản phân phối Linux phổ biến (Ubuntu, Linux Mint, Debian, Arch...) có sẵn công cụ chụp màn hình CLI
  (như `xfce4-screenshooter`, `gnome-screenshot`, `spectacle`, `maim`, `scrot`, hoặc `grimshot`).
- Trang **Kho đề** cần kết nối Internet để tải danh sách bộ đề từ GitHub.

---

## 🔗 Liên kết dự án

- 📁 **Repository:** https://github.com/Thieu-Van-Hieu/quiz-app
- 📦 **Tất cả bản phát hành:** https://github.com/Thieu-Van-Hieu/quiz-app/releases
- 📬 **Kênh hỗ trợ kỹ thuật:** quiz.fpt@gmail.com

---

*Made with ❤️ by **Mr.NoBody** (Thiều Văn Hiếu)*