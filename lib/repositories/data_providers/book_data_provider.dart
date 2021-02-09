import 'package:cloud_firestore/cloud_firestore.dart';

class BookDataProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> setBook(String id, Map<String, dynamic> data) async {
    final DocumentReference bookDocRef = db.collection("books").doc(id);
    await bookDocRef.set(data);
    return bookDocRef.id;
  }

  Future<List<Map<String, dynamic>>> getRecentBooks({int limit = 10, DateTime after}) async {
    Query booksQ = db.collection("books").orderBy('date_read', descending: true);
    if(after != null) booksQ = booksQ.where('date_read', isLessThan: after);
    if(limit > 0) booksQ = booksQ.limit(limit);

    final QuerySnapshot booksSnap = await booksQ.get();
    List<Map<String, dynamic>> books = [];
    booksSnap.docs.forEach((bookDoc) {
      books.add(bookDoc.data()..addAll({
        "id": bookDoc.id,
      }));
    });
    return books;
  }

  Stream<Map<String, dynamic>> getBookStream(String id) {
    return db.collection("books").doc(id).snapshots().map((bookSnap) {
      if(!bookSnap.exists) return null;
      return bookSnap.data()..addAll({
        "id": id,
      });
    });
  }

  Future<void> deleteBook(String id) {
    return db.collection("books").doc(id).delete();
  }
}