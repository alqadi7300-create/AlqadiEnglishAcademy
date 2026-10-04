import 'package:flutter/material.dart';
import '../../models/certificate_model.dart';
import '../../services/firestore_service.dart';

class ManageCertificatesPage extends StatelessWidget { const ManageCertificatesPage({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('إدارة الشهادات')),body:StreamBuilder<List<CertificateModel>>(stream:FirestoreService().stream('certificates').map((s)=>s.docs.map((d)=>CertificateModel.fromMap(d.id,d.data())).toList()),builder:(context,snapshot){
    if(snapshot.hasError)return Center(child:Text('تعذر تحميل الشهادات: ${snapshot.error}')); if(!snapshot.hasData)return const Center(child:CircularProgressIndicator()); final items=snapshot.data!; if(items.isEmpty)return const Center(child:Text('لا توجد شهادات.'));
    return ListView.builder(itemCount:items.length,itemBuilder:(context,i)=>ListTile(leading:const Icon(Icons.workspace_premium),title:Text(items[i].studentName),subtitle:Text(items[i].courseName),trailing:Text(items[i].certificateNumber)));
  }));
}
