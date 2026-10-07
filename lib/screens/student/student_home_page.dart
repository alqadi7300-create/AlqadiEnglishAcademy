import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import 'courses_page.dart';
import 'exams_page.dart';
import 'results_page.dart';
import 'progress_page.dart';
import 'certificates_page.dart';
import '../common/profile_page.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = AuthService().currentUser?.email ?? 'الطالب';
    final items = <(IconData, String, Widget)>[
      (Icons.menu_book_rounded, 'دوراتي', const CoursesPage()),
      (Icons.quiz_rounded, 'الاختبارات', const ExamsPage()),
      (Icons.bar_chart_rounded, 'نتائجي', const ResultsPage()),
      (Icons.trending_up_rounded, 'تقدمي', const ProgressPage()),
      (Icons.workspace_premium_rounded, 'شهاداتي', const CertificatesPage()),
      (Icons.person_rounded, 'ملفي الشخصي', const ProfilePage()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          IconButton(
            tooltip: 'الملف الشخصي',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
        children: [
          Text(
            'أهلاً بك 👋',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.navy, AppTheme.primary],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'واصل تعلّمك اليوم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'الدروس والاختبارات والنتائج والشهادات في مكان واحد.',
                  style: TextStyle(color: Color(0xFFDCEBFF), height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item.$3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppTheme.primary.withAlpha(24),
                        child: Icon(item.$1, color: AppTheme.primary, size: 29),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.$2,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
