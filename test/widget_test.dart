import 'package:flutter_test/flutter_test.dart';
import 'package:alqadi_english_academy/main.dart';

void main() {
  testWidgets('application renders academy splash', (tester) async {
    await tester.pumpWidget(const AlqadiEnglishAcademyApp());
    await tester.pump();

    expect(find.text('منصة القاضي'), findsOneWidget);
    expect(find.text('الأكاديمية الإنجليزية'), findsOneWidget);
  });
}
