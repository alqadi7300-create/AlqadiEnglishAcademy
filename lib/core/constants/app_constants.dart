import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/constants/app_constants.dart';
import 'local_storage_service.dart';

class AuthSession {
  final String code;
  final String role;
  final String name;

  const AuthSession({
    required this.code,
    required this.role,
    required this.name,
  });
}

class AuthService {
  final FirebaseAuth auth;
  final FirebaseFirestore db;
  final LocalStorageService local;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? db,
    LocalStorageService? local,
  })  : auth = auth ?? FirebaseAuth.instance,
        db = db ?? FirebaseFirestore.instance,
        local = local ?? LocalStorageService();

  User? get currentUser => auth.currentUser;

  static const String sessionKey = 'auth_session_v1';

  Future<User> _ensureAnonymousAuth() async {
    final existing = auth.currentUser;

    if (existing != null) {
      return existing;
    }

    final credential = await auth.signInAnonymously();

    final user = credential.user;

    if (user == null) {
      throw StateError('تعذر إنشاء جلسة الدخول.');
    }

    return user;
  }

  Future<AuthSession> loginWithCode(String rawCode) async {
    final code = rawCode.trim();

    if (code.isEmpty) {
      throw const FormatException('أدخل كود الدخول.');
    }

    final user = await _ensureAnonymousAuth();

    // كود المعلم الرسمي.
    if (code == AppConstants.teacherAccessCode) {
      await db.collection('users').doc(user.uid).set(
        {
          'name': AppConstants.teacherName,
          'role': 'admin',
          'loginCode': code,
          'authType': 'access_code',
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      await local.saveJson(
        sessionKey,
        {
          'code': code,
          'role': 'admin',
          'name': AppConstants.teacherName,
        },
      );

      return const AuthSession(
        code: AppConstants.teacherAccessCode,
        role: 'admin',
        name: AppConstants.teacherName,
      );
    }

    // أكواد الطلاب يتم إنشاؤها من قبل المعلم.
    final codeDoc =
        await db.collection('access_codes').doc(code).get();

    if (!codeDoc.exists || codeDoc.data() == null) {
      throw const FormatException(
        'كود الدخول غير صحيح أو غير مفعّل.',
      );
    }

    final data = codeDoc.data()!;

    final bool active = data['active'] != false;

    final String role =
        (data['role'] ?? 'student').toString();

    if (!active || role != 'student') {
      throw const FormatException(
        'كود الطالب غير مفعّل.',
      );
    }

    final String name =
        (data['name'] ?? 'الطالب').toString();

    final String level =
        (data['level'] ?? '').toString();

    await db.collection('users').doc(user.uid).set(
      {
        'name': name,
        'role': 'student',
        'loginCode': code,
        'authType': 'access_code',
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await db.collection('students').doc(user.uid).set(
      {
        'name': name,
        'loginCode': code,
        'level': level,
        'active': true,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await local.saveJson(
      sessionKey,
      {
        'code': code,
        'role': 'student',
        'name': name,
      },
    );

    return AuthSession(
      code: code,
      role: 'student',
      name: name,
    );
  }

  Future<AuthSession?> localSession() async {
    final data = await local.readJson(sessionKey);

    if (data == null) {
      return null;
    }

    final String code =
        (data['code'] ?? '').toString();

    final String role =
        (data['role'] ?? '').toString();

    final String name =
        (data['name'] ?? '').toString();

    if (code.isEmpty || role.isEmpty) {
      return null;
    }

    return AuthSession(
      code: code,
      role: role,
      name: name,
    );
  }

  Future<String> role(String uid) async {
    final snapshot =
        await db.collection('users').doc(uid).get();

    return (snapshot.data()?['role'] ?? 'student')
        .toString();
  }

  Future<String> displayName() async {
    final session = await localSession();

    return session?.name ?? 'المستخدم';
  }

  Future<void> logout() async {
    await local.remove(sessionKey);
    await auth.signOut();
  }
}
