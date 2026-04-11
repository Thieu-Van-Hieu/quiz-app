// Base Exception (Giống RuntimeException)
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

// 409 Conflict - Trùng dữ liệu
class EntityAlreadyExistsException extends AppException {
  EntityAlreadyExistsException([String message = "Dữ liệu này đã tồn tại!"]) 
      : super(message, "ALREADY_EXISTS");
}

// 404 Not Found
class EntityNotFoundException extends AppException {
  EntityNotFoundException([String message = "Không tìm thấy dữ liệu!"]) 
      : super(message, "NOT_FOUND");
}

// 400 Bad Request - Lỗi logic nghiệp vụ
class ValidationException extends AppException {
  ValidationException(String message) : super(message, "VALIDATION_FAILED");
}
