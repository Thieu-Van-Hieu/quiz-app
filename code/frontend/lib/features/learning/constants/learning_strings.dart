import 'package:frontend/core/services/device_info_service.dart';

class LearningStrings {
  static Map<String, String> generateExamHeader({
    required String quizName,
    required int durationMinutes,
  }) {
    final info = DeviceInfoService().info;
    // 1. Gen Server IP dựa trên Quiz Name (giả lập)
    // Ví dụ: Lấy độ dài tên hoặc mã ký tự để chọn một dải IP khác nhau
    final nameHash = quizName.length % 254;
    final mockServer = "172.16.$nameHash.1";

    // 2. Gen Exam Code từ Quiz Name (Viết hoa, xóa khoảng trắng + mã ngẫu nhiên)
    final cleanName = quizName.replaceAll(' ', '_').toUpperCase();
    final examCode =
        "${cleanName}_${quizName.hashCode.toString().substring(0, 4)}";

    return {
      "Machine:": info.machineName,
      "OS Version:": info.osVersion,
      "Device Model:": info.deviceModel,
      "Server:": mockServer,
      "Duration:": "$durationMinutes minutes",
      "Exam code:": examCode,
    };
  }

  static Map<String, String> generateStudyHeader({required String quizName}) {
    final info = DeviceInfoService().info;
    // 1. Gen Server IP dựa trên Quiz Name (giả lập)
    // Ví dụ: Lấy độ dài tên hoặc mã ký tự để chọn một dải IP khác nhau
    final nameHash = quizName.length % 254;
    final mockServer = "172.16.$nameHash.1";

    return {
      "Machine:": info.machineName,
      "OS Version:": info.osVersion,
      "Device Model:": info.deviceModel,
      "Server:": mockServer,
      "Quiz Name:": quizName,
    };
  }
}
