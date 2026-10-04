import 'dart:convert';
import 'local_storage_service.dart';
class SyncService {
  final LocalStorageService local; SyncService({LocalStorageService? local}):local=local??LocalStorageService();
  static const queueKey='sync_queue_v1';
  Future<void> enqueue(String collection,String id,Map<String,dynamic> data) async { final current=await local.readJson(queueKey); final q=List<Map<String,dynamic>>.from((current?['items'] as List?)?.map((e)=>Map<String,dynamic>.from(e))??[]); q.add({'collection':collection,'id':id,'data':data,'queuedAt':DateTime.now().toIso8601String()}); await local.saveJson(queueKey,{'items':q}); }
  Future<List<Map<String,dynamic>>> pending() async { final d=await local.readJson(queueKey); return List<Map<String,dynamic>>.from((d?['items'] as List?)?.map((e)=>Map<String,dynamic>.from(e))??[]); }
  Future<void> clear() async => local.remove(queueKey);
}
