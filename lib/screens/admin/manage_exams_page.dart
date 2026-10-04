import 'package:flutter/material.dart';
import '../../models/exam_model.dart';
import '../../repositories/exam_repository.dart';

class ManageExamsPage extends StatelessWidget { const ManageExamsPage({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('إدارة الاختبارات')), body: StreamBuilder<List<ExamModel>>(stream: ExamRepository().watch(''), builder:(context,snapshot){
    if(snapshot.hasError) return Center(child:Text('تعذر تحميل الاختبارات: ${snapshot.error}'));
    if(!snapshot.hasData) return const Center(child:CircularProgressIndicator());
    final items=snapshot.data!; if(items.isEmpty) return const Center(child:Text('لا توجد اختبارات.'));
    return ListView.builder(itemCount:items.length,itemBuilder:(context,i)=>ListTile(title:Text(items[i].title),subtitle:Text('الدورة: ${items[i].courseId} | نجاح: ${items[i].passScore.toStringAsFixed(0)}%')));
  }));
}
