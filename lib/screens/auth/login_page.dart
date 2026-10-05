import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../admin/admin_home_page.dart';
import '../student/student_home_page.dart';

class LoginPage extends StatefulWidget {
const LoginPage({super.key});

@override
State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final code = TextEditingController();

bool busy = false;
String? error;

@override
void dispose() {
code.dispose();
super.dispose();
}

Future<void> login() async {
FocusScope.of(context).unfocus();

final enteredCode = code.text.trim();

if (enteredCode.isEmpty) {
  setState(() {
    error = 'أدخل كود الدخول.';
  });
  return;
}

setState(() {
  busy = true;
  error = null;
});

try {
  final auth = AuthService();

  final session = await auth.loginWithCode(enteredCode);

  if (!mounted) {
    return;
  }

  if (session.role == 'admin') {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminHomePage(),
      ),
      (route) => false,
    );
  } else {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const StudentHomePage(),
      ),
      (route) => false,
    );
  }
} on FormatException catch (e) {
  if (!mounted) {
    return;
  }

  setState(() {
    error = e.message;
  });
} catch (e) {
  if (!mounted) {
    return;
  }

  setState(() {
    error =
        'تعذر تسجيل الدخول الآن. تأكد من الاتصال بالإنترنت وحاول مرة أخرى.';
  });
} finally {
  if (mounted) {
    setState(() {
      busy = false;
    });
  }
}

}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('تسجيل الدخول'),
centerTitle: true,
),
body: ListView(
padding: const EdgeInsets.all(20),
children: [
const SizedBox(height: 20),

      const Icon(
        Icons.school_rounded,
        size: 80,
      ),

      const SizedBox(height: 20),

      Text(
        'أكاديمية القاضي للغة الإنجليزية',
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),

      const SizedBox(height: 8),

      Text(
        'منصة تعليم اللغة الإنجليزية عن بُعد',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),

      const SizedBox(height: 30),

      CustomTextField(
        controller: code,
        label: 'كود الدخول',
      ),

      const SizedBox(height: 12),

      if (error != null)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .errorContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            error!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onErrorContainer,
            ),
          ),
        ),

      CustomButton(
        label: busy ? 'جارٍ الدخول...' : 'دخول',
        onPressed: busy ? null : login,
      ),

      const SizedBox(height: 20),

      const Text(
        'لا يحتاج الطالب إلى بريد إلكتروني أو كلمة مرور.\n'
        'يحصل الطالب على كود دخول خاص من المعلم.',
        textAlign: TextAlign.center,
      ),
    ],
  ),
);

}
}
