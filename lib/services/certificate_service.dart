import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';

class CertificateService {
  final Uuid _uuid = const Uuid();

  String number() {
    return 'ALQ-${DateTime.now().year}-'
        '${_uuid.v4().substring(0, 8).toUpperCase()}';
  }

  Future<Uint8List> build({
    required String studentName,
    required String courseName,
    required String level,
    required double score,
    required DateTime issuedAt,
    required String certificateNumber,
  }) async {
    final document = pw.Document();

    document.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Certificate of Completion',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 24),
                  pw.Text(
                    'This certificate is proudly presented to',
                    style: const pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  pw.Text(
                    studentName,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 18),
                  pw.Text(
                    'for successfully completing',
                    style: const pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    courseName,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(level),
                  pw.SizedBox(height: 16),
                  pw.Text(
                    'Score: ${score.toStringAsFixed(1)}%',
                  ),
                  pw.Text(
                    'Issued: '
                    '${issuedAt.toLocal().toString().split(' ').first}',
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Certificate No.: $certificateNumber',
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    'Alqadi English Academy',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    return document.save();
  }
}
