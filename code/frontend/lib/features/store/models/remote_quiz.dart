/// 1 file bộ đề có sẵn trên GitHub (thư mục `quizzes/current`)
class RemoteQuiz {
  final String fileName;
  final String path;
  final String sha;
  final int size;
  final String downloadUrl;
  final String htmlUrl;

  /// Thời điểm commit gần nhất đụng tới file (null nếu GitHub không trả kịp)
  final DateTime? lastUpdated;

  const RemoteQuiz({
    required this.fileName,
    required this.path,
    required this.sha,
    required this.size,
    required this.downloadUrl,
    required this.htmlUrl,
    this.lastUpdated,
  });

  /// "HCM202 - FE - QuizApp.json" → "HCM202 - FE"
  String get title {
    var name = fileName.replaceAll(
      RegExp(r'\.json$', caseSensitive: false),
      '',
    );
    name = name.replaceAll(
      RegExp(r'\s*-\s*QuizApp$', caseSensitive: false),
      '',
    );
    return name.trim();
  }

  /// Mã môn = phần trước dấu " - " đầu tiên: "PMG201c - QuizApp.json" → "PMG201c"
  String get subjectCode => fileName.split(' - ').first.trim();

  RemoteQuiz copyWith({DateTime? lastUpdated}) => RemoteQuiz(
    fileName: fileName,
    path: path,
    sha: sha,
    size: size,
    downloadUrl: downloadUrl,
    htmlUrl: htmlUrl,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );

  factory RemoteQuiz.fromGithub(Map<String, dynamic> json) => RemoteQuiz(
    fileName: json['name'] as String,
    path: json['path'] as String,
    sha: json['sha'] as String,
    size: (json['size'] as num?)?.toInt() ?? 0,
    downloadUrl: json['download_url'] as String,
    htmlUrl: json['html_url'] as String? ?? '',
  );

  factory RemoteQuiz.fromCache(Map<String, dynamic> json) =>
      RemoteQuiz.fromGithub(json).copyWith(
        lastUpdated: DateTime.tryParse(json['lastUpdated'] as String? ?? ''),
      );

  Map<String, dynamic> toCache() => {
    'name': fileName,
    'path': path,
    'sha': sha,
    'size': size,
    'download_url': downloadUrl,
    'html_url': htmlUrl,
    'lastUpdated': lastUpdated?.toIso8601String(),
  };
}

/// Bản ghi "đã import" lưu trên máy, để biết GitHub có bản mới hơn hay chưa
class ImportedRecord {
  final String sha;
  final DateTime importedAt;

  const ImportedRecord({required this.sha, required this.importedAt});

  factory ImportedRecord.fromJson(Map<String, dynamic> json) => ImportedRecord(
    sha: json['sha'] as String,
    importedAt: DateTime.parse(json['importedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'sha': sha,
    'importedAt': importedAt.toIso8601String(),
  };
}

/// Mức độ "mới" của bộ đề dựa trên ngày cập nhật gần nhất
enum QuizFreshness {
  fresh('Mới cập nhật'),
  recent('Cập nhật gần đây'),
  normal('Đã lâu'),
  stale('Lâu chưa cập nhật'),
  unknown('Chưa rõ');

  final String label;

  const QuizFreshness(this.label);

  static QuizFreshness of(DateTime? updated, DateTime now) {
    if (updated == null) return unknown;
    final days = now.difference(updated).inDays;
    if (days <= 7) return fresh;
    if (days <= 30) return recent;
    if (days <= 90) return normal;
    return stale;
  }
}

/// Trạng thái so với bản đã import trên máy
enum ImportStatus { notImported, upToDate, outdated }

/// "vừa xong", "5 phút trước", "3 ngày trước", "2 tháng trước", "1 năm trước"
String relativeTime(DateTime time, DateTime now) {
  final diff = now.difference(time);
  if (diff.inMinutes < 1) return 'vừa xong';
  if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
  if (diff.inDays < 1) return '${diff.inHours} giờ trước';
  if (diff.inDays < 30) return '${diff.inDays} ngày trước';
  if (diff.inDays < 365) return '${diff.inDays ~/ 30} tháng trước';
  return '${diff.inDays ~/ 365} năm trước';
}

/// Gán ngày cập nhật cho từng file từ danh sách commit (mới → cũ).
/// Commit đầu tiên (mới nhất) có đụng tới file chính là lần cập nhật gần nhất.
List<RemoteQuiz> assignLastUpdated(
  List<RemoteQuiz> files,
  List<({DateTime date, Set<String> paths})> commits,
) {
  final dates = <String, DateTime>{};
  for (final commit in commits) {
    for (final path in commit.paths) {
      dates.putIfAbsent(path, () => commit.date);
    }
  }
  return [
    for (final f in files)
      dates[f.path] == null ? f : f.copyWith(lastUpdated: dates[f.path]),
  ];
}
