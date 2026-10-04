import '../models/level_model.dart';
import '../services/firestore_service.dart';

class LevelRepository {
  final FirestoreService service;
  LevelRepository({FirestoreService? service}) : service = service ?? FirestoreService();

  Stream<List<LevelModel>> watch() => service.stream('levels').map(
        (s) => s.docs.map((d) => LevelModel.fromMap(d.id, d.data())).toList(),
      );

  Future<void> save(LevelModel value) => service.setDoc('levels', value.id, value.toMap());
  Future<void> delete(String id) => service.deleteDoc('levels', id);
}
