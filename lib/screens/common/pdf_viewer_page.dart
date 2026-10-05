import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class PdfViewerPage extends StatelessWidget {
  final String title;
  final String filePath;

  const PdfViewerPage({
    super.key,
    required this.title,
    required this.filePath,
  });

  Future<Uint8List> _read() async {
    final path = filePath.trim();

    if (path.isNotEmpty) {
      final file = File(path);

      if (await file.exists()) {
        return await file.readAsBytes();
      }
    }

    final directory = await getApplicationDocumentsDirectory();

    final localPath = path.isEmpty
        ? ''
        : '${directory.path}/$path';

    if (localPath.isNotEmpty) {
      final localFile = File(localPath);

      if (await localFile.exists()) {
        return await localFile.readAsBytes();
      }
    }

    throw StateError('ملف PDF غير موجود محليًا.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<Uint8List>(
        future: _read(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  snapshot.error?.toString() ??
                      'تعذر فتح ملف PDF.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final bytes = snapshot.data!;

          return PdfPreview(
            canChangePageFormat: false,
            canChangeOrientation: false,
            allowPrinting: true,
            allowSharing: true,
            build: (format) async {
              return bytes;
            },
          );
        },
      ),
    );
  }
}
