import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteDataProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> setQuotes(String bookId, Map<String, dynamic> data) {
    final DocumentReference quoteDocRef = db.collection("quotes").doc(bookId);
    return quoteDocRef.set(data);
  }
}