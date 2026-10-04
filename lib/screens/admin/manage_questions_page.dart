import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageQuestionsPage extends StatelessWidget { const ManageQuestionsPage({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar:AppBar(title:const Text('إدارة الأسئلة')), body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('questions').orderBy('order').snapshots(),builder:(context,snapshot){
    if(snapshot.hasError)return Center(child:Text('تعذر تحميل الأسئلة: ${snapshot.error}'));
    if(!snapshot.hasData)return const Center(child:CircularProgressIndicator());
    final docs=snapshot.data!.docs; if(docs.isEmpty)return const Center(child:Text('لا توجد أسئلة.'));
    return ListView.builder(itemCount:docs.length,itemBuilder:(context,i){final d=docs[i].data();return ListTile(title:Text((d['text']??'').toString()),subtitle:Text('النوع: ${(d['type']??'mcq').toString()} | الدرجة: ${(d['points']??1).toString()}'));});
  }));
}
