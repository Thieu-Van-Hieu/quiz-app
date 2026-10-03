import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/setting/enums/physical_key.dart';
import 'package:frontend/features/setting/enums/shortcut_action.dart';
import 'package:frontend/features/setting/models/app_config.dart';
import 'package:frontend/features/store/models/remote_quiz.dart';
import 'package:frontend/features/store/services/github_quiz_source.dart';

RemoteQuiz remote(String name, {String sha = 'a'}) => RemoteQuiz(
  fileName: name,
  path: 'quizzes/current/$name',
  sha: sha,
  size: 0,
  downloadUrl: '',
  htmlUrl: '',
);

void main() {
  group('RemoteQuiz', () {
    test('tên hiển thị và mã môn lấy từ tên file', () {
      final quiz = remote('HCM202 - FE - QuizApp.json');
      expect(quiz.title, 'HCM202 - FE');
      expect(quiz.subjectCode, 'HCM202');
      expect(remote('PMG201c - QuizApp.json').title, 'PMG201c');
      expect(remote('PMG201c - QuizApp.json').subjectCode, 'PMG201c');
    });
  });

  group('QuizFreshness', () {
    final now = DateTime(2026, 10, 3);
    test('phân loại theo số ngày từ lần cập nhật cuối', () {
      expect(
        QuizFreshness.of(now.subtract(const Duration(days: 2)), now),
        QuizFreshness.fresh,
      );
      expect(
        QuizFreshness.of(now.subtract(const Duration(days: 20)), now),
        QuizFreshness.recent,
      );
      expect(
        QuizFreshness.of(now.subtract(const Duration(days: 60)), now),
        QuizFreshness.normal,
      );
      expect(
        QuizFreshness.of(now.subtract(const Duration(days: 200)), now),
        QuizFreshness.stale,
      );
      expect(QuizFreshness.of(null, now), QuizFreshness.unknown);
    });

    test('relativeTime', () {
      expect(
        relativeTime(now.subtract(const Duration(days: 3)), now),
        '3 ngày trước',
      );
      expect(
        relativeTime(now.subtract(const Duration(days: 65)), now),
        '2 tháng trước',
      );
      expect(
        relativeTime(now.subtract(const Duration(hours: 5)), now),
        '5 giờ trước',
      );
    });
  });

  test('assignLastUpdated lấy commit mới nhất có đụng tới file', () {
    final a = remote('A - QuizApp.json');
    final b = remote('B - QuizApp.json');
    final c = remote('C - QuizApp.json');
    final result = assignLastUpdated(
      [a, b, c],
      [
        (date: DateTime(2026, 10, 3), paths: {a.path}),
        (date: DateTime(2026, 9, 1), paths: {a.path, b.path}),
      ],
    );
    expect(result[0].lastUpdated, DateTime(2026, 10, 3));
    expect(result[1].lastUpdated, DateTime(2026, 9, 1));
    expect(result[2].lastUpdated, isNull);
  });

  test('QuizStoreData.statusOf so sánh sha với bản đã import', () {
    final quiz = remote('A - QuizApp.json', sha: 'new');
    final record = ImportedRecord(sha: 'old', importedAt: DateTime(2026));
    final data = QuizStoreData(quizzes: [quiz], imports: const {});
    expect(data.statusOf(quiz), ImportStatus.notImported);
    expect(
      data.withImport(quiz.path, record).statusOf(quiz),
      ImportStatus.outdated,
    );
    final upToDate = ImportedRecord(sha: 'new', importedAt: DateTime(2026));
    expect(
      data.withImport(quiz.path, upToDate).statusOf(quiz),
      ImportStatus.upToDate,
    );
  });

  test('AppConfig.withKeyBindings trả bản sao khác, không sửa bản cũ', () {
    // Riverpod so sánh bằng ==: nếu sửa tại chỗ thì bản mới == bản cũ
    // và trang Cài đặt không rebuild (lỗi phím tắt phải hard refresh)
    final old = AppConfig();
    final updated = old.withKeyBindings({
      ShortcutAction.values.first: [PhysicalKey.enter],
    });
    expect(old.keyBindings, isEmpty);
    expect(updated.keyBindings[ShortcutAction.values.first], [
      PhysicalKey.enter,
    ]);
    expect(updated == old, isFalse);
    expect(old.copyWith(fontSize: 20) == old, isFalse);
  });
}
