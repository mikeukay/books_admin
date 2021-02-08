import 'package:books_admin/models/book.dart';
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
}