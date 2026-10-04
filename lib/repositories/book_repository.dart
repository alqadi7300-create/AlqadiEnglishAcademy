import '../models/book_model.dart';
import '../services/firestore_service.dart';

class BookRepository {
  final FirestoreService service;
  BookRepository({FirestoreService? service}) : service = service ?? FirestoreService();

  Stream<List<BookModel>> watch() => service.stream('books').map(
        (s) => s.docs.map((d) => BookModel.fromMap(d.id, d.data())).toList(),
      );

  Future<void> save(BookModel value) => service.setDoc('books', value.id, value.toMap());
  Future<void> delete(String id) => service.deleteDoc('books', id);
}
