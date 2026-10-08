import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../student/student_home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool busy = false;
  String? error;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> register() async {
    FocusScope.of(context).unfocus();

    final studentName = name.text.trim();
    final studentEmail = email.text.trim();
    final studentPassword = password.text;

    if (studentName.length < 2) {
      setState(() => error = 'اكتب اسم الطالب بشكل صحيح.');
      return;
    }
    if (!studentEmail.contains('@') || !studentEmail.contains('.')) {
      setState(() => error = 'أدخل بريدًا إلكترونيًا صحيحًا.');
      return;
    }
    if (studentPassword.length < 6) {
      setState(() => error = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل.');
      return;
    }

    setState(() {
      busy = true;
      error = null;
    });

    try {
      await AuthService().register(
        name: studentName,
        email: studentEmail,
        password: studentPassword,
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const StudentHomePage()),
        (_) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => error = 'تعذر إنشاء الحساب. تأكد من البيانات وحاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب طالب')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.person_add_alt_1_rounded, size: 58),
                  const SizedBox(height: 12),
                  const Text(
                    'أنشئ حسابك في الأكاديمية',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(controller: name, label: 'اسم الطالب'),
                  const SizedBox(height: 14),
                  CustomTextField(controller: email, label: 'البريد الإلكتروني'),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: password,
                    label: 'كلمة المرور',
                    obscure: true,
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error!,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  CustomButton(
                    label: busy ? 'جارٍ إنشاء الحساب...' : 'إنشاء الحساب',
                    onPressed: busy ? null : register,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
