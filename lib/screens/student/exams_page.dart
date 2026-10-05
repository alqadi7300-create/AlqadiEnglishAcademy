import 'package:flutter/material.dart';

import '../../repositories/course_repository.dart';
import '../../repositories/exam_repository.dart';
import '../../widgets/exam_card.dart';
import 'take_exam_page.dart';

class ExamsPage extends StatelessWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاختبارات'),
      ),
      body: StreamBuilder(
        stream: CourseRepository().watch(),
        builder: (context, courseSnapshot) {
          if (courseSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (courseSnapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ في تحميل الدورات: ${courseSnapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!courseSnapshot.hasData) {
            return const Center(
              child: Text('لا توجد دورات متاحة حاليًا.'),
            );
          }

          final courses = courseSnapshot.data!;

          if (courses.isEmpty) {
            return const Center(
              child: Text('لا توجد دورات متاحة حاليًا.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: courses.map<Widget>((course) {
              return StreamBuilder(
                stream: ExamRepository().watch(course.id),
                builder: (context, examSnapshot) {
                  if (examSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox(
                      height: 60,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (examSnapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'تعذر تحميل اختبارات ${course.name}.',
                      ),
                    );
                  }

                  if (!examSnapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final exams = examSnapshot.data!;

                  if (exams.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          8,
                        ),
                        child: Text(
                          course.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge,
                        ),
                      ),
                      ...exams.map<Widget>(
                        (exam) {
                          return ExamCard(
                            exam: exam,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TakeExamPage(
                                    exam: exam,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
