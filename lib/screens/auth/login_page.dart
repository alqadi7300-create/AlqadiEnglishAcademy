import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'register_page.dart';
import '../student/student_home_page.dart';
import '../admin/admin_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool busy = false;
  String? error;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> login() async {
    FocusScope.of(context).unfocus();
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      setState(() => error = 'أدخل البريد الإلكتروني وكلمة المرور.');
      return;
    }

    setState(() {
      busy = true;
      error = null;
    });

    try {
      final auth = AuthService();
      final credential = await auth.login(email.text.trim(), password.text);
      final role = await auth.role(credential.user!.uid);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => role == 'admin'
              ? const AdminHomePage()
              : const StudentHomePage(),
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(() => error = 'بيانات الدخول غير صحيحة أو تعذر الاتصال.');
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const Icon(Icons.school_rounded, size: 64, color: AppTheme.primary),
                  const SizedBox(height: 12),
                  const Text(
                    'مرحباً بك في منصة القاضي',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'الأكاديمية الإنجليزية',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: email,
                    label: 'البريد الإلكتروني',
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: password,
                    label: 'كلمة المرور',
                    obscure: true,
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  CustomButton(
                    label: busy ? 'جارٍ الدخول...' : 'دخول إلى المنصة',
                    onPressed: busy ? null : login,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: busy
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            ),
                    child: const Text('ليس لديك حساب؟ إنشاء حساب طالب'),
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
