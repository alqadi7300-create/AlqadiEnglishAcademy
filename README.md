# Alqadi English Academy

منصة تعليم اللغة الإنجليزية عن بُعد، مستقلة عن المشاريع السابقة.

## المسار
Course → Level → Lessons → Practice → Exam → Result → Progress → Certificate

## المستويات الأولية
Beginner, Elementary, Pre-Intermediate, Intermediate, Upper-Intermediate, Advanced

## الدورات الأولية
- Reading
- Writing

## البناء
يتم البناء عبر GitHub Actions. الـWorkflow ينفذ:
1. Flutter 3.29.3
2. Java 17
3. `flutter pub get`
4. `flutter analyze`
5. `flutter test`
6. `flutter build apk --release`

## Firebase
لا يوجد `google-services.json` وهمي داخل المشروع. بعد إنشاء Firebase project الجديد، ضع محتوى ملف Android الحقيقي في GitHub Actions Secret باسم:

`FIREBASE_ANDROID_CONFIG_B64`

وقيمته هي محتوى `google-services.json` بعد تحويله إلى Base64.

## الأمان
قواعد Firestore موجودة في `firestore.rules` ولا تستخدم قاعدة عامة من نوع `allow read, write: if request.auth != null`.


## المرحلة التالية: Firebase الحقيقي

هذا المشروع لا يحتوي على `google-services.json` وهمي. بعد إنشاء Firebase Project جديد باسم مناسب:
1. أضف Android App بالمعرّف `com.alqadi.englishacademy`.
2. نزّل `google-services.json`.
3. حوّله إلى Base64 ثم خزّنه في GitHub Actions Secret باسم `FIREBASE_ANDROID_CONFIG_B64`.
4. انشر `firestore.rules` في Firestore.
5. أنشئ حساب Admin ثم اجعل حقل `role` في `users/{uid}` يساوي `admin` من لوحة Firebase فقط.

## معيار النجاح
لا تعتبر النسخة جاهزة للنشر إلا إذا نجحت GitHub Actions في:
- flutter pub get
- flutter analyze
- flutter test
- flutter build apk --release

## ملاحظة أمنية
لا تضع `google-services.json` داخل GitHub إذا كان المستودع عامًا. استخدم Secret.
