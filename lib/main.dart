import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Keep the UI buildable/testable if Firebase configuration is unavailable.
  }

  runApp(const AlqadiEnglishAcademyApp());
}

class AlqadiEnglishAcademyApp extends StatelessWidget {
  const AlqadiEnglishAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'أكاديمية القاضي للغة الإنجليزية',
      theme: AppTheme.light(),
      home: const LoginPage(),
    );
  }
}
