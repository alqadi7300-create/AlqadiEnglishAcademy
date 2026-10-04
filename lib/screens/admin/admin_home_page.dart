import 'package:flutter/material.dart';

import 'manage_books_page.dart';
import 'manage_certificates_page.dart';
import 'manage_courses_page.dart';
import 'manage_exams_page.dart';
import 'manage_lessons_page.dart';
import 'manage_levels_page.dart';
import 'manage_questions_page.dart';
import 'manage_results_page.dart';
import 'manage_students_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <(String, IconData, Widget)>[
      ('الدورات', Icons.menu_book, const ManageCoursesPage()),
      ('المستويات', Icons.stairs, const ManageLevelsPage()),
      ('الدروس', Icons.school, const ManageLessonsPage()),
      ('الكتب والملفات', Icons.picture_as_pdf, const ManageBooksPage()),
      ('الاختبارات', Icons.quiz, const ManageExamsPage()),
      ('الأسئلة', Icons.help_outline, const ManageQuestionsPage()),
      ('الطلاب', Icons.people, const ManageStudentsPage()),
      ('النتائج', Icons.assessment, const ManageResultsPage()),
      ('الشهادات', Icons.workspace_premium, const ManageCertificatesPage()),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة الإدارة')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: pages.length,
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final item = pages[index];
          return Card(
            child: ListTile(
              leading: Icon(item.$2),
              title: Text(item.$1),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.$3),
              ),
            ),
          );
        },
      ),
    );
  }
}
