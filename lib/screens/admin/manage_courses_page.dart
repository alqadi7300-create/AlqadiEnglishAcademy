import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/course_model.dart';
import '../../repositories/course_repository.dart';

class ManageCoursesPage extends StatelessWidget {
  const ManageCoursesPage({super.key});

  Future<void> _add(BuildContext context) async {
    final name = TextEditingController();
    final level = TextEditingController();
    final description = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('إضافة دورة'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم الدورة')),
        TextField(controller: level, decoration: const InputDecoration(labelText: 'معرّف المستوى')),
        TextField(controller: description, decoration: const InputDecoration(labelText: 'الوصف')),
      ])),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حفظ'))],
    ));
    if (ok == true && name.text.trim().isNotEmpty) {
      final now = DateTime.now();
      await CourseRepository().save(CourseModel(id: const Uuid().v4(), name: name.text.trim(), levelId: level.text.trim(), description: description.text.trim(), startDate: now, endDate: now.add(const Duration(days: 30))));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('إدارة الدورات')),
    floatingActionButton: FloatingActionButton.extended(onPressed: () => _add(context), icon: const Icon(Icons.add), label: const Text('إضافة دورة')),
    body: StreamBuilder<List<CourseModel>>(
      stream: CourseRepository().watch(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('تعذر تحميل الدورات: ${snapshot.error}'));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final items = snapshot.data!;
        if (items.isEmpty) return const Center(child: Text('لا توجد دورات بعد.'));
        return ListView.builder(itemCount: items.length, itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(title: Text(item.name), subtitle: Text(item.description), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => CourseRepository().delete(item.id)));
        });
      },
    ),
  );
}
