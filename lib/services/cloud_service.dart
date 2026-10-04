import 'package:cloud_firestore/cloud_firestore.dart';
class CloudService {
  final FirebaseFirestore db; CloudService({FirebaseFirestore? db}):db=db??FirebaseFirestore.instance;
  CollectionReference<Map<String,dynamic>> collection(String name)=>db.collection(name);
  Future<void> set(String collectionName,String id,Map<String,dynamic> data)=>collection(collectionName).doc(id).set(data,SetOptions(merge:true));
  Future<void> delete(String collectionName,String id)=>collection(collectionName).doc(id).delete();
  Future<List<QueryDocumentSnapshot<Map<String,dynamic>>>> list(String name)=>collection(name).get().then((s)=>s.docs);
}
