import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/store/models/remote_quiz.dart';
import 'package:frontend/features/store/widgets/remote_quiz_card.dart';

void main() {
  final quiz = RemoteQuiz(
    fileName: 'MLN122 - FE - Bất quy tắc - QuizApp.json',
    path: 'quizzes/current/x.json',
    sha: 'a',
    size: 446377,
    downloadUrl: '',
    htmlUrl: '',
    lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
  );

  for (final status in ImportStatus.values) {
    for (final busy in [false, true]) {
      testWidgets('nút không bị tràn: $status, busy=$busy', (tester) async {
        await tester.binding.setSurfaceSize(const Size(900, 300));
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RemoteQuizCard(
                quiz: quiz,
                status: status,
                isBusy: busy,
                onImport: () {},
                onOpenGithub: () {},
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 200));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
