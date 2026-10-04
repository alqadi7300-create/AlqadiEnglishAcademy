import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AuthService {
  final FirebaseAuth auth; final FirebaseFirestore db;
  AuthService({FirebaseAuth? auth,FirebaseFirestore? db}):auth=auth??FirebaseAuth.instance,db=db??FirebaseFirestore.instance;
  User? get currentUser=>auth.currentUser;
  Future<UserCredential> register({required String email,required String password,required String name}) async { final c=await auth.createUserWithEmailAndPassword(email:email,password:password); await db.collection('users').doc(c.user!.uid).set({'email':email,'name':name,'role':'student','createdAt':FieldValue.serverTimestamp()}); await db.collection('students').doc(c.user!.uid).set({'name':name,'email':email,'createdAt':FieldValue.serverTimestamp()}); return c; }
  Future<UserCredential> login(String email,String password) => auth.signInWithEmailAndPassword(email:email,password:password);
  Future<void> logout()=>auth.signOut();
  Future<String> role(String uid) async { final s=await db.collection('users').doc(uid).get(); return (s.data()?['role']??'student') as String; }
}
