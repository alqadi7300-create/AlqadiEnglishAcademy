import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class LocalStorageService {
  Future<void> saveJson(String key, Object value) async { final p=await SharedPreferences.getInstance(); await p.setString(key,jsonEncode(value)); }
  Future<Map<String,dynamic>?> readJson(String key) async { final p=await SharedPreferences.getInstance(); final v=p.getString(key); if(v==null)return null; final d=jsonDecode(v); return d is Map<String,dynamic>?d:null; }
  Future<void> saveString(String key,String value) async { final p=await SharedPreferences.getInstance(); await p.setString(key,value); }
  Future<String?> readString(String key) async => (await SharedPreferences.getInstance()).getString(key);
  Future<void> remove(String key) async => (await SharedPreferences.getInstance()).remove(key);
}
