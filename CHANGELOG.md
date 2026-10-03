## [1.2.1] — 2026-10-03

### ✨ Thêm mới

- **Trang Kho đề** (`features/store/`): Mục "Kho đề" mới trên sidebar, liệt kê các bộ đề trong `quizzes/current` của
  repo GitHub (bỏ qua file Template).
    - Nhãn độ mới theo commit gần nhất sửa file: mới cập nhật (≤ 7 ngày) / gần đây (≤ 30 ngày) / đã lâu (≤ 90 ngày) /
      lâu chưa cập nhật, kèm thời gian tương đối và dung lượng.
    - Trạng thái so với máy: *Đã import* / *Có bản mới* (so `sha` của file với bản đã import).
    - Tải & import 1 nút: kiểm tra câu trùng, tự chọn môn theo mã môn hoặc tạo môn mới, báo lỗi trùng tên ngay trong
      dialog; bản cập nhật được gợi ý tên kèm ngày.
    - Tìm kiếm, lọc (chưa import / có bản mới), sắp xếp theo ngày cập nhật hoặc tên.
    - Cache chi tiết commit trên máy (`quiz_store.json`) để tiết kiệm giới hạn 60 request/giờ của GitHub API; mất mạng
      thì hiển thị danh sách lần trước.
- **Lối tắt "Kho đề online"** trong menu Import của trang bộ đề.

### 🐛 Sửa lỗi

- **Cài đặt**: Gán / xoá phím tắt, bật tắt phím nhanh, đổi font và cỡ chữ không cập nhật ngay (phải hard refresh). Nguyên
  nhân: trang sửa trực tiếp object `AppConfig` mà provider đang giữ; Riverpod 3 so sánh bằng `==` (dart_mappable so theo
  giá trị) nên bản mới từ DB "bằng" bản cũ và không rebuild. Giờ luôn tạo bản sao bằng `copyWith` /
  `AppConfig.withKeyBindings`.
- **Trang đang ẩn không nhận thay đổi DB** (vd. môn học mới tạo ở trang khác không hiện trong Thư viện): Riverpod 3
  pause provider của trang ẩn, còn stream watch của ObjectBox mất sự kiện khi bị pause (`store.watch<T>()` đóng observer,
  `Query.watch()` bỏ subscription cũ khi resume). Thêm `Stream.pauseSafe()` (`core/extensions/stream_extension.dart`)
  và áp dụng cho mọi watch, kể cả `ObjectBoxService.watchTables()`.

### 🧪 Kỹ thuật

- Thêm unit / widget test (62 test): Kho đề, `pauseSafe`, card bộ đề không bị tràn layout.

---

## [1.2.0] — 2026-10-01

### ✨ Thêm mới

- **Tìm kiếm toàn cục (Master Search)**: Mục "Tìm kiếm" mới trên sidebar, tìm cùng lúc trong mọi môn học, bộ đề và câu
  hỏi; chọn phạm vi (câu hỏi / đáp án / giải thích / chỉ đáp án đúng), lọc theo môn; bấm kết quả mở bộ đề kèm từ khoá.
- **Tuỳ chọn tìm kiếm**: `TextMatcher` dùng chung cho mọi ô tìm kiếm — smart case / không phân biệt / phân biệt hoa
  thường, bỏ dấu tiếng Việt (hỗ trợ cả văn bản NFD), khớp nguyên từ, chứa tất cả các từ, khớp theo từng ký tự, Regex
  (báo lỗi cú pháp).
- **Highlight từ khoá**: Widget `HighlightedText` trên card môn học, bộ đề, câu hỏi (nội dung / đáp án / giải thích) và
  phiên học.
- **Trang Công cụ**: Phân tích bộ đề, tách quiz (theo khoảng câu, từ phiên học, theo nhóm phân tích), gộp quiz và lọc
  trùng — thay cho các script Python trong `utilities/`. Kết quả tách/gộp được lưu thành bộ đề mới (bản sao câu hỏi).
- **Học lại câu sai trong phiên**: Câu làm sai được đưa lại sau `reviewOffset` câu (chế độ cuốn chiếu).
- **Nút Mark as Pass**: Đánh dấu đúng câu hiện tại ở chế độ Học tập.
- **Cảnh báo câu trùng**: Hộp thoại Giữ nguyên / Xoá câu trùng / Huỷ khi import Quizlet / JSON / bin; nút "Xoá N câu
  trùng" và cảnh báo khi quét OCR thêm câu trùng ở trang câu hỏi.

### 🔧 Cải tiến

- **Viết lại parser Import Quizlet**: Nhãn đáp án chỉ nhận `A.` / `A)` đứng đầu dòng hoặc sau khoảng trắng và phải liên
  tiếp A, B, C…; ưu tiên khớp chính xác nội dung đáp án, chỉ khớp gần đúng khi chọn được duy nhất 1 đáp án; hỗ trợ
  nhiều đáp án dạng `A, C`; dùng đúng dấu phân cách Term/Def; đặt `indexOrder` theo thứ tự đáp án.
- **Bỏ `ref.invalidate`**: Thêm `ObjectBoxService.watchTables()` gộp sự kiện thay đổi của nhiều bảng (debounce) và
  `QueryBuilder.buildAndClose()`; các danh sách tự cập nhật khi bảng liên quan thay đổi.
- **Thống kê phiên học**: `totalPass` / `totalNotPass` chuyển thành getter tính từ chi tiết phiên học, thống nhất định
  nghĩa `isPassed == true / false`.
- Bỏ viền khi làm sai ở chế độ thường (`reviewOffset = 0`) trên cả Practice và Study.
- Cập nhật cỡ chữ cột gợi ý số lượng đáp án.

### 🐛 Sửa lỗi

- **Làm lại câu sai / làm lại toàn bộ**: Không còn lấy các câu đã bị xoá hoặc bị gỡ khỏi bộ đề.
- **Phiên Luyện tập**: Sửa lỗi không tạo được bài "Làm lại câu sai" (do lọc theo `isChecked`).
- **Import Quizlet**: Sửa lỗi tách nhầm đáp án ở `-` / `.` (vd. `Marx-Lenin`), đánh đúng nhiều đáp án do khớp một phần,
  lệch nhãn khi bỏ đáp án rỗng; sửa lỗi tự loại câu trùng không có tác dụng và thông báo câu lỗi định dạng không hiện.
- **Trang Luyện tập**: Sửa lỗi mất focus bàn phím.
- **Đáp án mới tạo**: Sửa lỗi không cập nhật `indexOrder`.

### 🧪 Kỹ thuật

- Thêm unit test (48 test) cho parser Quizlet, lọc trùng, `TextMatcher`, Master Search và các service Công cụ.
- Thêm dependency `rxdart`.
- Schema ObjectBox: bỏ cột `totalPass`, `totalNotPass` của `LearningSession` (không cần migrate).

---

## [1.1.2] — 2026-08-06

### ✨ Thêm mới

- **Hỗ trợ nền tảng Linux**: Triển khai `LinuxCaptureService` hỗ trợ chụp màn hình linh hoạt qua nhiều công cụ CLI
  (`xfce4-screenshooter`, `gnome-screenshot`, `spectacle`, `maim`, `scrot`, `grimshot`)[cite: 1].
- **Tích hợp OCR cho Linux**: Mở rộng tính năng trích xuất câu hỏi từ hình ảnh (OCR) cho hệ điều hành Linux[cite: 1].
- **Cấu hình Workflows CI/CD**: Thêm GitHub Actions workflow hỗ trợ tự động build ứng dụng trên máy ảo Linux, thông báo
  nâng cấp và dọn dẹp file thừa sau build[cite: 1].

### 🔧 Cải tiến

- **Mở rộng Path Service**: Cập nhật `path_service` tương thích và hỗ trợ tối đa hệ điều hành Linux[cite: 1].
- **Lazy Load cho Import Quizlet**: Áp dụng cơ chế lazy loading giúp danh sách import không bị giật lag hay treo UI khi
  xử lý số lượng câu hỏi lớn[cite: 1].
- **Tối ưu Editor Import**: Mở rộng giao diện `AlertDialog` giúp không gian nhập/sửa câu hỏi rộng rãi, dễ quan sát
  hơn[cite: 1].
- **Đồng bộ theme OCR Dialog**: Áp dụng hệ màu thiết kế mới cho hộp thoại OCR[cite: 1].

### 🐛 Sửa lỗi

- **Lỗi Snackbar**: Khắc phục triệt để lỗi Snackbar thông báo bị kẹt/không tự đóng khi hết thời gian chờ[cite: 1].
- **Đồng bộ trang Settings**: Cân chỉnh lại giao diện trang Cài đặt cho đồng bộ ngôn ngữ thiết kế chung[cite: 1].
- **Tràn văn bản Quiz Title**: Sửa lỗi vỡ/overflow khung hiển thị tên Quiz tại trang danh sách câu hỏi[cite: 1].

---

## [1.1.1] — 2026-06-26

### 🔧 Cải tiến

- **Chuyển ngữ cảnh nút hành động**: Tự động chuyển đổi nút `Next >>` thành `Finish` khi người dùng di chuyển đến câu
  hỏi cuối cùng của phiên học[cite: 1].
- **Gia cố Quiz Text Parser**: Bổ sung các tầng lọc dữ liệu nâng cao và kiểm tra an toàn mảng (index safety) nhằm nâng
  cao độ chính xác khi bóc tách dữ liệu thô[cite: 1].

### 🐛 Sửa lỗi

- **Ánh xạ phím tắt khi xáo trộn đáp án**: Sửa lỗi phím tắt nhanh (A, B, C, D) bị chọn sai vị trí sau khi bật chế độ
  trộn đáp án[cite: 1].
- **Lưu vị trí học (currentIndex)**: Sửa lỗi lưu sai `currentIndex` khi thoát đột ngột ở cả chế độ Học (Study) và Thi
  (Exam)[cite: 1].
- **Ô nhập thời gian (Duration Input)**: Cân chỉnh lại giao diện hiển thị đối với ô nhập liệu thời gian[cite: 1].

---