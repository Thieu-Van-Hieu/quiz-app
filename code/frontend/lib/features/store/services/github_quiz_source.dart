import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:frontend/features/store/models/remote_quiz.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class RemoteSourceException extends AppException {
  RemoteSourceException(String message) : super(message, "REMOTE_SOURCE");
}

/// Kết quả tải danh sách bộ đề
class QuizStoreData {
  final List<RemoteQuiz> quizzes;
  final Map<String, ImportedRecord> imports;

  /// Có thông báo nghĩa là dữ liệu chưa đầy đủ (lấy từ cache / thiếu ngày cập nhật)
  final String? warning;

  const QuizStoreData({
    required this.quizzes,
    required this.imports,
    this.warning,
  });

  ImportStatus statusOf(RemoteQuiz quiz) {
    final record = imports[quiz.path];
    if (record == null) return ImportStatus.notImported;
    return record.sha == quiz.sha
        ? ImportStatus.upToDate
        : ImportStatus.outdated;
  }

  QuizStoreData withImport(String path, ImportedRecord record) => QuizStoreData(
    quizzes: quizzes,
    imports: {...imports, path: record},
    warning: warning,
  );
}

/// Lấy danh sách bộ đề trong `quizzes/current` của repo GitHub.
///
/// GitHub API không đăng nhập chỉ cho 60 request/giờ, nên:
/// - danh sách file: 1 request (contents API)
/// - ngày cập nhật: 1 request danh sách commit + 1 request / commit để biết
///   commit đó sửa file nào. Commit không bao giờ đổi nên kết quả được cache
///   vĩnh viễn, lần sau chỉ phải hỏi các commit mới.
/// - tải file: qua raw.githubusercontent.com, không tính vào giới hạn.
class GithubQuizSource {
  static const String owner = 'Thieu-Van-Hieu';
  static const String repo = 'quiz-app';
  static const String branch = 'main';
  static const String folder = 'quizzes/current';

  static final Uri _contentsUri = Uri.https(
    'api.github.com',
    '/repos/$owner/$repo/contents/$folder',
    {'ref': branch},
  );
  static final Uri _commitsUri = Uri.https(
    'api.github.com',
    '/repos/$owner/$repo/commits',
    {'sha': branch, 'path': folder, 'per_page': '100'},
  );
  static Uri _commitUri(String sha) =>
      Uri.https('api.github.com', '/repos/$owner/$repo/commits/$sha');

  final String _cachePath;

  GithubQuizSource({String? cachePath})
    : _cachePath =
          cachePath ?? p.join(AppPathService().rootPath, 'quiz_store.json');

  // --- PUBLIC API ---

  Future<QuizStoreData> load() async {
    final cache = await _readCache();
    final imports = _importsOf(cache);

    final List<RemoteQuiz> files;
    try {
      final body = await _get(_contentsUri);
      files = (jsonDecode(body) as List)
          .cast<Map<String, dynamic>>()
          .where((e) => e['type'] == 'file')
          .where((e) => (e['name'] as String).toLowerCase().endsWith('.json'))
          .where((e) => !(e['name'] as String).startsWith('Template'))
          .map(RemoteQuiz.fromGithub)
          .toList();
    } on RemoteSourceException catch (e) {
      // Không lấy được danh sách mới → dùng tạm danh sách lần trước nếu có
      final cached = (cache['lastList'] as List?)
          ?.cast<Map<String, dynamic>>()
          .map(RemoteQuiz.fromCache)
          .toList();
      if (cached == null || cached.isEmpty) rethrow;
      return QuizStoreData(
        quizzes: cached,
        imports: imports,
        warning: '${e.message} Đang hiển thị danh sách đã lưu lần trước.',
      );
    }

    final commitFiles = Map<String, dynamic>.from(
      cache['commitFiles'] as Map? ?? {},
    );
    String? warning;
    var quizzes = files;
    try {
      quizzes = await _withLastUpdated(files, commitFiles);
    } on RemoteSourceException catch (e) {
      warning = '${e.message} Một số bộ đề chưa có ngày cập nhật.';
    }
    if (warning == null && quizzes.any((q) => q.lastUpdated == null)) {
      warning = 'Một số bộ đề chưa có ngày cập nhật.';
    }

    cache['commitFiles'] = commitFiles;
    cache['lastList'] = quizzes.map((q) => q.toCache()).toList();
    await _writeCache(cache);

    return QuizStoreData(quizzes: quizzes, imports: imports, warning: warning);
  }

  Future<String> download(RemoteQuiz quiz) =>
      _get(Uri.parse(quiz.downloadUrl), github: false);

  Future<ImportedRecord> markImported(RemoteQuiz quiz) async {
    final record = ImportedRecord(sha: quiz.sha, importedAt: DateTime.now());
    final cache = await _readCache();
    final imports = Map<String, dynamic>.from(cache['imports'] as Map? ?? {});
    imports[quiz.path] = record.toJson();
    cache['imports'] = imports;
    await _writeCache(cache);
    return record;
  }

  // --- NGÀY CẬP NHẬT ---

  Future<List<RemoteQuiz>> _withLastUpdated(
    List<RemoteQuiz> files,
    Map<String, dynamic> commitFiles,
  ) async {
    final commitList = (jsonDecode(await _get(_commitsUri)) as List)
        .cast<Map<String, dynamic>>();

    final remaining = files.map((f) => f.path).toSet();
    final commits = <({DateTime date, Set<String> paths})>[];

    try {
      for (final c in commitList) {
        if (remaining.isEmpty) break;
        final sha = c['sha'] as String;
        final date = DateTime.parse(
          (c['commit']['committer'] ?? c['commit']['author'])['date'] as String,
        );

        var paths = (commitFiles[sha] as List?)?.cast<String>();
        if (paths == null) {
          final detail =
              jsonDecode(await _get(_commitUri(sha))) as Map<String, dynamic>;
          paths = (detail['files'] as List? ?? [])
              .map((f) => f['filename'] as String)
              .toList();
          commitFiles[sha] = paths;
        }

        commits.add((date: date, paths: paths.toSet()));
        remaining.removeAll(paths);
      }
    } on RemoteSourceException {
      // Hết lượt giữa chừng: vẫn trả về các ngày đã biết
      if (commits.isEmpty) rethrow;
    }

    return assignLastUpdated(files, commits);
  }

  // --- HTTP ---

  Future<String> _get(Uri uri, {bool github = true}) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.userAgentHeader, 'QuizApp');
      if (github) {
        request.headers.set(
          HttpHeaders.acceptHeader,
          'application/vnd.github+json',
        );
      }
      final response = await request.close().timeout(
        const Duration(seconds: 60),
      );
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) return body;

      final remaining = response.headers.value('x-ratelimit-remaining');
      if ((response.statusCode == 403 || response.statusCode == 429) &&
          remaining == '0') {
        final reset = int.tryParse(
          response.headers.value('x-ratelimit-reset') ?? '',
        );
        final at = reset == null
            ? ''
            : ' (thử lại sau ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(reset * 1000))})';
        throw RemoteSourceException('GitHub tạm giới hạn lượt truy cập$at.');
      }
      throw RemoteSourceException('GitHub trả về lỗi ${response.statusCode}.');
    } on SocketException {
      throw RemoteSourceException('Không có kết nối mạng.');
    } on HandshakeException {
      throw RemoteSourceException('Không kết nối an toàn được tới GitHub.');
    } on TimeoutException {
      throw RemoteSourceException('Kết nối tới GitHub quá lâu.');
    } finally {
      client.close();
    }
  }

  // --- CACHE TRÊN MÁY ---

  Map<String, ImportedRecord> _importsOf(Map<String, dynamic> cache) {
    final raw = cache['imports'] as Map? ?? {};
    final result = <String, ImportedRecord>{};
    raw.forEach((key, value) {
      try {
        result[key as String] = ImportedRecord.fromJson(
          Map<String, dynamic>.from(value as Map),
        );
      } catch (_) {}
    });
    return result;
  }

  Future<Map<String, dynamic>> _readCache() async {
    try {
      final file = File(_cachePath);
      if (!await file.exists()) return {};
      return Map<String, dynamic>.from(
        jsonDecode(await file.readAsString()) as Map,
      );
    } catch (e) {
      debugPrint('⚠️ Không đọc được cache kho đề: $e');
      return {};
    }
  }

  Future<void> _writeCache(Map<String, dynamic> cache) async {
    try {
      await File(_cachePath).writeAsString(jsonEncode(cache));
    } catch (e) {
      debugPrint('⚠️ Không ghi được cache kho đề: $e');
    }
  }
}
