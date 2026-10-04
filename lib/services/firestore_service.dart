import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreService {
  final FirebaseFirestore db; FirestoreService({FirebaseFirestore? db}):db=db??FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String,dynamic>>> stream(String collection)=>db.collection(collection).orderBy('createdAt',descending:true).snapshots();
  Future<void> setDoc(String collection,String id,Map<String,dynamic> data)=>db.collection(collection).doc(id).set({...data,'updatedAt':FieldValue.serverTimestamp()},SetOptions(merge:true));
  Future<void> deleteDoc(String collection,String id)=>db.collection(collection).doc(id).delete();
}
