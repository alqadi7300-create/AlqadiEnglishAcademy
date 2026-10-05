import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../services/auth_service.dart';
import '../admin/admin_home_page.dart';
import '../student/student_home_page.dart';

class LoginPage extends StatefulWidget {
const LoginPage({super.key});

@override
State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final _formKey = GlobalKey<FormState>();
final _codeController = TextEditingController();

bool _loading = false;
String? _error;

@override
void dispose() {
_codeController.dispose();
super.dispose();
}

Future<void> _login() async {
FocusScope.of(context).unfocus();

if (!_formKey.currentState!.validate()) {
  return;
}

setState(() {
  _loading = true;
  _error = null;
});

try {
  final session = await AuthService().loginWithCode(
    _codeController.text,
  );

  if (!mounted) {
    return;
  }

  if (session.role == 'admin') {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const AdminHomePage(),
      ),
      (route) => false,
    );
  } else {
    Navigator.of(context).pushAndRemoveUntil(
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
    _error = e.message;
  });
} catch (e) {
  if (!mounted) {
    return;
  }

  setState(() {
    _error =
        'تعذر تسجيل الدخول الآن. تأكد من اتصال الإنترنت وحاول مرة أخرى.';
  });
} finally {
  if (mounted) {
    setState(() {
      _loading = false;
    });
  }
}

}

@override
Widget build(BuildContext context) {
return Directionality(
textDirection: TextDirection.rtl,
child: Scaffold(
appBar: AppBar(
title: const Text('تسجيل الدخول'),
centerTitle: true,
),
body: SafeArea(
child: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),
child: ConstrainedBox(
constraints: const BoxConstraints(
maxWidth: 500,
),
child: Form(
key: _formKey,
child: Column(
crossAxisAlignment:
CrossAxisAlignment.stretch,
children: [
const Icon(
Icons.school_rounded,
size: 80,
),
const SizedBox(height: 20),
Text(
AppConstants.arabicAppName,
textAlign: TextAlign.center,
style: Theme.of(context)
.textTheme
.headlineSmall
?.copyWith(
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 10),
Text(
'منصة تعليم اللغة الإنجليزية عن بُعد',
textAlign: TextAlign.center,
style: Theme.of(context)
.textTheme
.bodyLarge,
),
const SizedBox(height: 32),
TextFormField(
controller: _codeController,
textDirection: TextDirection.ltr,
textAlign: TextAlign.center,
textInputAction: TextInputAction.done,
enabled: !loading,
decoration: const InputDecoration(
labelText: 'كود الدخول',
hintText: 'أدخل كود الدخول',
prefixIcon:
Icon(Icons.key_rounded),
border: OutlineInputBorder(),
),
onFieldSubmitted: () {
if (!_loading) {
_login();
}
},
validator: (value) {
final code =
value?.trim() ?? '';

                      if (code.isEmpty) {
                        return 'أدخل كود الدخول.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12),
                        color: Theme.of(context)
                            .colorScheme
                            .errorContainer,
                      ),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onErrorContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed:
                          _loading ? null : _login,
                      icon: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.login_rounded,
                            ),
                      label: Text(
                        _loading
                            ? 'جارٍ تسجيل الدخول...'
                            : 'دخول',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'لا يحتاج الطالب إلى بريد إلكتروني أو كلمة مرور.\n'
                    'يحصل الطالب على كود دخول خاص من المعلم.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);

}
}
