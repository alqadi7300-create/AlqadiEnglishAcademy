import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/level_model.dart';
import '../../repositories/level_repository.dart';

class ManageLevelsPage extends StatelessWidget {
  const ManageLevelsPage({super.key});

  Future<void> _add(BuildContext context) async {
    final name = TextEditingController();
    final description = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('إضافة مستوى'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم المستوى')),
        TextField(controller: description, decoration: const InputDecoration(labelText: 'الوصف')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حفظ')),
      ],
    ));
    if (ok == true && name.text.trim().isNotEmpty) {
      await LevelRepository().save(LevelModel(id: const Uuid().v4(), name: name.text.trim(), description: description.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('إدارة المستويات')),
        floatingActionButton: FloatingActionButton.extended(onPressed: () => _add(context), icon: const Icon(Icons.add), label: const Text('إضافة')),
        body: StreamBuilder<List<LevelModel>>(
          stream: LevelRepository().watch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text('تعذر تحميل المستويات: ${snapshot.error}'));
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final items = snapshot.data!;
            if (items.isEmpty) return const Center(child: Text('لا توجد مستويات بعد. أضف المستوى الأول.'));
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name), subtitle: Text(item.description),
                  trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => LevelRepository().delete(item.id)),
                );
              },
            );
          },
        ),
      );
}
