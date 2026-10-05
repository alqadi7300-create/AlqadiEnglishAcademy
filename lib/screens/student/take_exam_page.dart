import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/exam_model.dart';
import '../../models/question_model.dart';
import '../../models/result_model.dart';
import '../../repositories/exam_repository.dart';
import '../../repositories/result_repository.dart';
import '../../services/auth_service.dart';
import '../../widgets/question_widget.dart';
import 'exam_result_page.dart';

class TakeExamPage extends StatefulWidget {
  final ExamModel exam;

  const TakeExamPage({
    super.key,
    required this.exam,
  });

  @override
  State<TakeExamPage> createState() => _TakeExamPageState();
}

class _TakeExamPageState extends State<TakeExamPage> {
  final Map<String, String> answers = {};

  Future<void> submit(List<QuestionModel> questions) async {
    double total = 0.0;
    double earned = 0.0;

    for (final question in questions) {
      final double points = question.points.toDouble();

      total += points;

      final String studentAnswer =
          (answers[question.id] ?? '').trim().toLowerCase();

      final String correctAnswer =
          question.correctAnswer.trim().toLowerCase();

      if (studentAnswer == correctAnswer) {
        earned += points;
      }
    }

    final double score = total == 0.0
        ? 0.0
        : ((earned / total) * 100.0).toDouble();

    final currentUser = AuthService().currentUser;

    if (currentUser == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب تسجيل الدخول أولًا.'),
        ),
      );

      return;
    }

    final result = ResultModel(
      id: const Uuid().v4(),
      studentId: currentUser.uid,
      examId: widget.exam.id,
      courseId: widget.exam.courseId,
      score: score,
      passed: score >= widget.exam.passScore.toDouble(),
      submittedAt: DateTime.now(),
    );

    await ResultRepository().save(result);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ExamResultPage(
          result: result,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.title),
      ),
      body: StreamBuilder(
        stream: ExamRepository().questions(widget.exam.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'حدث خطأ أثناء تحميل أسئلة الاختبار:\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('لا توجد أسئلة في هذا الاختبار.'),
            );
          }

          final questions = snapshot.data!;

          if (questions.isEmpty) {
            return const Center(
              child: Text('لا توجد أسئلة في هذا الاختبار.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              ...questions.map(
                (question) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: QuestionWidget(
                      question: question,
                      value: answers[question.id],
                      onChanged: (value) {
                        setState(() {
                          answers[question.id] = value ?? '';
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => submit(questions),
                child: const Text(
                  'إنهاء وتسليم الاختبار',
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
