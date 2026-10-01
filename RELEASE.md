# Quiz App v1.2.0

> **🔎 Tìm kiếm toàn cục, 🧰 Công cụ quản lý bộ đề & 📥 Import Quizlet chính xác hơn**  
> **Nền tảng:** Windows Desktop & Linux (Flutter) · **Ngày phát hành:** 01/10/2026 ·  
> **Tác giả:** Mr.NoBody

---

## 🚀 Giới thiệu phiên bản

Chào mừng bạn đến với **Quiz App v1.2.0**! Bản cập nhật này tập trung vào **tìm kiếm** và **quản lý bộ đề**: bạn có
thể tìm câu hỏi trên toàn bộ thư viện với nhiều tuỳ chọn mạnh mẽ (bỏ dấu tiếng Việt, Regex...), đồng thời phân tích,
tách, gộp và lọc trùng bộ đề ngay trong ứng dụng thay vì phải dùng script riêng. Bên cạnh đó là nhiều sửa lỗi quan
trọng cho Import Quizlet và chế độ làm lại câu sai.

---

## ✨ Điểm mới trong bản v1.2.0

### 🔎 Tìm kiếm toàn cục & Tuỳ chọn tìm kiếm

- **Master Search:** Mục "Tìm kiếm" mới trên sidebar, tìm cùng lúc trong mọi môn học, bộ đề và câu hỏi. Lọc theo môn,
  chọn tìm trong câu hỏi / đáp án / giải thích / chỉ đáp án đúng; bấm vào kết quả để mở thẳng bộ đề kèm từ khoá.
- **Tuỳ chọn tìm kiếm ở mọi ô tìm kiếm:** phân biệt hoa thường thông minh, **bỏ dấu tiếng Việt** (gõ `duong loi` tìm
  được "Đường lối"), khớp nguyên từ, chứa tất cả các từ, khớp theo từng ký tự (`cnxh` → "chủ nghĩa xã hội"), Regex.
- **Highlight từ khoá** trên card môn học, bộ đề, câu hỏi và phiên học.

### 🧰 Trang Công cụ

- **Phân tích bộ đề:** vị trí đáp án đúng A/B/C/D, tỉ lệ "đáp án dài/ngắn nhất là đáp án đúng", cụm từ chỉ xuất hiện
  trong đáp án đúng, câu dễ nhầm (đáp án đúng của câu này là đáp án sai của câu khác), câu có chung đáp án đúng.
- **Tách quiz:** theo khoảng câu, từ một phiên học (vd. chỉ các câu làm sai) hoặc theo nhóm phân tích.
- **Gộp quiz:** gộp nhiều bộ đề, tuỳ chọn tiêu chí và cách xử lý câu trùng.
- **Lọc trùng:** xoá câu trùng hoàn toàn bằng 1 nút, liệt kê câu trùng nội dung nhưng khác đáp án để kiểm tra.

### 🎓 Học tập

- **Học lại câu sai ngay trong phiên** với chế độ cuốn chiếu.
- **Nút Mark as Pass** ở chế độ Học tập.
- "Làm lại câu sai" không còn lấy các câu đã bị xoá; phiên Luyện tập đã tạo được bài làm lại câu sai.
- Thống kê đúng/sai nhất quán giữa các màn hình.

### 📥 Import & Quản lý câu hỏi

- **Import Quizlet chính xác hơn:** không còn tách nhầm đáp án ở dấu `-` / `.`, không còn đánh đúng nhiều đáp án do khớp
  một phần, hỗ trợ đáp án dạng `A, C`.
- **Cảnh báo câu trùng** khi import và nút xoá câu trùng trong trang câu hỏi.
- Dữ liệu trên mọi màn hình tự cập nhật ngay khi có thay đổi.

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