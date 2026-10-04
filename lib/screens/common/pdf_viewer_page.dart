import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class PdfViewerPage extends StatelessWidget {
  final String title;
  final String filePath;

  const PdfViewerPage({super.key, required this.title, required this.filePath});

  Future<List<int>> _read() async {
    final path = filePath.trim();
    if (path.isNotEmpty && await File(path).exists()) return File(path).readAsBytes();
    final directory = await getApplicationDocumentsDirectory();
    final local = File('${directory.path}/$path');
    if (await local.exists()) return local.readAsBytes();
    throw StateError('ملف PDF غير موجود محليًا.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<int>>(
        future: _read(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(snapshot.error?.toString() ?? 'تعذر فتح ملف PDF.'),
              ),
            );
          }
          return PdfPreview(
            canChangePageFormat: false,
            canChangeOrientation: false,
            build: (_) async => snapshot.data!,
          );
        },
      ),
    );
  }
}
