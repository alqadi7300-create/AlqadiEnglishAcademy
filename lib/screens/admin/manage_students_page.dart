import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../repositories/student_repository.dart';

class ManageStudentsPage extends StatelessWidget { const ManageStudentsPage({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('إدارة الطلاب')),body:StreamBuilder<List<StudentModel>>(stream:StudentRepository().watch(),builder:(context,snapshot){
    if(snapshot.hasError)return Center(child:Text('تعذر تحميل الطلاب: ${snapshot.error}')); if(!snapshot.hasData)return const Center(child:CircularProgressIndicator()); final items=snapshot.data!; if(items.isEmpty)return const Center(child:Text('لا يوجد طلاب مسجلون.'));
    return ListView.builder(itemCount:items.length,itemBuilder:(context,i)=>ListTile(leading:const CircleAvatar(child:Icon(Icons.person)),title:Text(items[i].name),subtitle:Text(items[i].email)));
  }));
}
