import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import '../../repositories/lesson_repository.dart';

class ManageLessonsPage extends StatelessWidget { const ManageLessonsPage({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('إدارة الدروس')), body: StreamBuilder<List<LessonModel>>(stream: LessonRepository().watch(''), builder: (context, snapshot) {
    if (snapshot.hasError) return Center(child: Text('تعذر تحميل الدروس: ${snapshot.error}'));
    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
    final items=snapshot.data!; if(items.isEmpty) return const Center(child: Text('لا توجد دروس. أضف الدروس من خلال الدورة.'));
    return ListView.builder(itemCount: items.length,itemBuilder:(context,i)=>ListTile(title:Text(items[i].title),subtitle:Text('الدورة: ${items[i].courseId}')));
  }));
}
