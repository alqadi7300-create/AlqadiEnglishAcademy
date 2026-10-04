import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageResultsPage extends StatelessWidget { const ManageResultsPage({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('إدارة النتائج')),body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('results').orderBy('submittedAt',descending:true).snapshots(),builder:(context,snapshot){
    if(snapshot.hasError)return Center(child:Text('تعذر تحميل النتائج: ${snapshot.error}')); if(!snapshot.hasData)return const Center(child:CircularProgressIndicator()); final docs=snapshot.data!.docs; if(docs.isEmpty)return const Center(child:Text('لا توجد نتائج بعد.'));
    return ListView.builder(itemCount:docs.length,itemBuilder:(context,i){final d=docs[i].data();final score=(d['score'] as num?)?.toDouble()??0;return ListTile(title:Text('طالب: ${(d['studentId']??'').toString()}'),subtitle:Text('اختبار: ${(d['examId']??'').toString()}'),trailing:Text('${score.toStringAsFixed(0)}%'));});
  }));
}
