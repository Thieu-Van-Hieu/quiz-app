import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Model chứa thông tin thiết bị (Gộp chung vào file service cho gọn nếu quy mô vừa)
class EosDeviceInfo {
  final String machineName;
  final String osVersion;
  final String deviceModel;
  final String deviceId;
  final String manufacturer;

  EosDeviceInfo({
    required this.machineName,
    required this.osVersion,
    required this.deviceModel,
    required this.deviceId,
    required this.manufacturer,
  });

  factory EosDeviceInfo.empty() => EosDeviceInfo(
    machineName: "Unknown",
    osVersion: "Unknown",
    deviceModel: "Unknown",
    deviceId: "Unknown",
    manufacturer: "Unknown",
  );
}

class DeviceInfoService {
  // Singleton pattern
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  factory DeviceInfoService() => _instance;
  DeviceInfoService._internal();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  // Biến lưu trữ thông tin sau khi load
  late EosDeviceInfo info;

  /// Hàm khởi tạo: Gọi 1 lần duy nhất tại main.dart
  Future<void> init() async {
    try {
      if (kIsWeb) {
        final web = await _deviceInfoPlugin.webBrowserInfo;
        info = EosDeviceInfo(
          machineName: "Web Browser",
          osVersion: web.userAgent ?? "Unknown",
          deviceModel: web.browserName.name,
          deviceId: web.vendor ?? "web-id",
          manufacturer: web.appCodeName ?? "Web",
        );
        return;
      }

      if (Platform.isWindows) {
        final win = await _deviceInfoPlugin.windowsInfo;
        info = EosDeviceInfo(
          machineName: win.computerName,
          osVersion: "Windows ${win.majorVersion}.${win.minorVersion}",
          deviceModel: win.productName,
          deviceId: win.deviceId,
          manufacturer: "Microsoft",
        );
      } else if (Platform.isAndroid) {
        final android = await _deviceInfoPlugin.androidInfo;
        info = EosDeviceInfo(
          machineName: android.host,
          osVersion: "Android ${android.version.release}",
          deviceModel: android.model,
          deviceId: android.id,
          manufacturer: android.manufacturer,
        );
      } else if (Platform.isIOS) {
        final ios = await _deviceInfoPlugin.iosInfo;
        info = EosDeviceInfo(
          machineName: ios.name,
          osVersion: "${ios.systemName} ${ios.systemVersion}",
          deviceModel: ios.utsname.machine,
          deviceId: ios.identifierForVendor ?? "unknown-id",
          manufacturer: "Apple",
        );
      } else {
        // Backup cho các nền tảng khác (Linux, MacOS)
        info = EosDeviceInfo(
          machineName: Platform.localHostname,
          osVersion: Platform.operatingSystemVersion,
          deviceModel: Platform.operatingSystem,
          deviceId: "generic-id",
          manufacturer: "Generic",
        );
      }
    } catch (e) {
      debugPrint("Error initializing DeviceInfoService: $e");
      info = EosDeviceInfo.empty();
    }
  }

  /// Helper lấy map thông tin nhanh cho Header
  Map<String, String> getHeaderInfo() {
    return {
      "Machine:": info.machineName,
      "OS:": info.osVersion,
      "ID:": info.deviceId.length > 8
          ? info.deviceId.substring(0, 8)
          : info.deviceId,
    };
  }
}
