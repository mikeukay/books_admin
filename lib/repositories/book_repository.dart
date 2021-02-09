import 'package:books_admin/models/book.dart';
import 'package:books_admin/models/quote.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:books_admin/repositories/data_providers/book_data_provider.dart';
import 'package:books_admin/repositories/data_providers/quote_data_provider.dart';

class BookRepository {
  final BookDataProvider bookDataProvider = BookDataProvider();
  final QuoteDataProvider quoteDataProvider = QuoteDataProvider();

  Future<void> setBook(Book b) async {
    String newBookId = await bookDataProvider.setBook(b.id, b.toMap()..remove("id"));
    await quoteDataProvider.setQuotes(newBookId, {
      'quotes': []
    });
  }

  Future<List<Book>> getInitialBooks() async {
    List<Map<String, dynamic>> rawBooks = await bookDataProvider.getRecentBooks();
    List<Book> books = rawBooks.map((rawBook) => Book.fromMap(rawBook)).toList();

    return books;
  }

  Future<List<Book>> loadBooksAfter(Book b, {int limit = 10}) async {
    List<Map<String, dynamic>> rawBooks = await bookDataProvider.getRecentBooks(
        limit: limit,
        after: b.dateRead
    );
    List<Book> books = rawBooks.map((rawBook) => Book.fromMap(rawBook)).toList();

    return books;
  }

  Stream<List> _mergeStreams(Stream<Map<String, dynamic>> a, Stream<Map<String, dynamic>> b) {
    return a.combineLatest<Map<String, dynamic>, List>(b, (a, b) => [a, b]);
  }

  Stream<Book> book(String id) {
    return _mergeStreams(
      bookDataProvider.getBookStream(id),
      quoteDataProvider.getQuoteStream(id),
    ).map((bookAndQuotes) {
      List<Map<String, dynamic>> rawQuotes = [];
      try {
        if(bookAndQuotes[1] != null)
          bookAndQuotes[1]['quotes'].forEach((q) {
            rawQuotes.add(Map.from(q));
          });
      } catch(_) {}

      if(bookAndQuotes[0] == null) return null;
      try {
        List<Quote> quotes = rawQuotes?.map((e) => Quote.fromMap(e))?.toList();
        return Book.fromMap(bookAndQuotes[0]).copyWith(quotes: quotes);
      } catch(_) {
        return null;
      }
    });
  }

  Future<void> deleteBook(String id) {
    return Future.wait([
      bookDataProvider.deleteBook(id),
      quoteDataProvider.deleteQuotes(id),
    ]);
  }

  Future<void> updateBook(Book oldBook, Book newBook) {
    List<Future> toWait = [];
    if(oldBook.quotes != newBook.quotes)
      toWait.add(
          quoteDataProvider.setQuotes(newBook.id, {
            'quotes': newBook.quotes.map((q) => q.toMap()..remove('id')).toList()
          })
      );
    if(oldBook != newBook)
      toWait.add(
          bookDataProvider.setBook(newBook.id, newBook.toMap()..remove('id')..remove('quotes'))
      );
    return Future.wait(toWait);
  }
}