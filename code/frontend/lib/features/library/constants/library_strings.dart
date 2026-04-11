class LibraryStrings {
  // --- 1. Library Main Page ---
  static const String title = "Thư viện học phần";
  static const String subtitle =
      "Quản lý danh sách các môn học và bộ đề của bạn";
  static const String btnAdd = "Thêm môn học";
  static const String searchHint = "Tìm kiếm mã hoặc tên môn học...";
  static const String emptyList = "Chưa có môn học nào ở đây";
  static const String deleteConfirmContent =
      "Dữ liệu môn học và các bộ đề liên quan sẽ bị xóa vĩnh viễn.";
  static const String labelCode = "Mã: ";

  // --- 2. Subject Detail Page ---
  static const String detailTitle = "Chi tiết học phần";
  static const String detailSubtitle = "Danh sách các bộ đề ôn tập của môn học";
  static const String btnAddQuiz = "Tạo bộ đề mới";
  static const String emptyQuizList = "Chưa có bộ đề nào trong môn học này";
  static const String labelQuestions = "câu hỏi trắc nghiệm";

  // --- 3. Quiz Detail Page (Câu hỏi) ---
  static const String searchQuestionHint = "Tìm kiếm nội dung câu hỏi...";
  static const String emptyQuestions =
      "Chưa có câu hỏi nào hoặc không tìm thấy.";
  static const String labelQuestionCount = "câu hỏi";
  static const String labelQuestionNumber =
      "Câu hỏi"; // Cho cái Header "Câu hỏi $index"
  static const String btnSyncDb = "Lưu thay đổi";
  static const String btnAddQuestion = "Thêm câu hỏi";
  static const String btnAddOption = "Thêm đáp án"; // Nút thêm Option
  static const String hintEnterQuestion =
      "Nhập nội dung câu hỏi..."; // Cái phen đang tìm đây
  static const String noContent = "(Chưa có nội dung)"; // Khi View Mode trống
  static const String snackbarSyncSuccess = "Đã đồng bộ thay đổi vào database!";
  static const String newQuestionPlaceholder = "";
  static const String defaultOptionText = "";

  // --- 4. Dialogs & Form Labels ---
  static const String dialogAddSubjectTitle = "Tạo học phần mới";
  static const String dialogUpdateSubjectTitle = "Cập nhật học phần";
  static const String dialogAddQuizTitle = "Tạo bộ đề mới";
  static const String dialogUpdateQuizTitle = "Cập nhật bộ đề";

  static const String dialogLabelSubjectName = "Tên môn học";
  static const String dialogLabelSubjectCode = "Mã môn học (VD: SWE301)";
  static const String dialogLabelQuizName = "Tên bộ đề (VD: Ôn tập chương 1)";

  static const String hintSubjectName = "Nhập tên môn học...";
  static const String hintSubjectCode = "Nhập mã môn học...";
  static const String hintQuizName = "Nhập tên bộ đề...";
}
