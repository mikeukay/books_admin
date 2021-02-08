import 'package:cloud_firestore/cloud_firestore.dart';

class BookDataProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> setBook(String id, Map<String, dynamic> data) async {
    final DocumentReference bookDocRef = db.collection("books").doc(id);
    await bookDocRef.set(data);
    return bookDocRef.id;
  }
}