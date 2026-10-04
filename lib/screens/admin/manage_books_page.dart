import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/book_model.dart';
import '../../repositories/book_repository.dart';

class ManageBooksPage extends StatelessWidget {
  const ManageBooksPage({super.key});

  Future<void> _add(BuildContext context) async {
    final course = TextEditingController();
    final title = TextEditingController();
    final key = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('إضافة كتاب أو ملف'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: course, decoration: const InputDecoration(labelText: 'معرّف الدورة')),
        TextField(controller: title, decoration: const InputDecoration(labelText: 'عنوان الملف')),
        TextField(controller: key, decoration: const InputDecoration(labelText: 'مسار الملف المحلي')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حفظ')),
      ],
    ));
    if (ok == true && title.text.trim().isNotEmpty) {
      await BookRepository().save(BookModel(id: const Uuid().v4(), courseId: course.text.trim(), title: title.text.trim(), storageKey: key.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('إدارة الكتب والملفات')),
        floatingActionButton: FloatingActionButton.extended(onPressed: () => _add(context), icon: const Icon(Icons.add), label: const Text('إضافة')),
        body: StreamBuilder<List<BookModel>>(
          stream: BookRepository().watch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text('تعذر تحميل الملفات: ${snapshot.error}'));
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            if (items.isEmpty) return const Center(child: Text('لا توجد ملفات بعد.'));
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: Text(item.title), subtitle: Text('الدورة: ${item.courseId}'),
                  trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => BookRepository().delete(item.id)),
                );
              },
            );
          },
        ),
      );
}
