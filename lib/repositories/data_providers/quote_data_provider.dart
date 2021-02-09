import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteDataProvider {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> setQuotes(String bookId, Map<String, dynamic> data) {
    final DocumentReference quoteDocRef = db.collection("quotes").doc(bookId);
    return quoteDocRef.set(data);
  }

  Stream<Map<String, dynamic>> getQuoteStream(String bookId) {
    return db.collection("quotes").doc(bookId).snapshots().map((quotesSnap) {
      if(!quotesSnap.exists || quotesSnap.data()['quotes'] == null) return null;
      return quotesSnap.data();
    });
  }

  Future<void> deleteQuotes(String bookId) {
    return db.collection("quotes").doc(bookId).delete();
  }
}