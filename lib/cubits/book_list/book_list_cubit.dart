import 'package:books_admin/models/book.dart';
import 'package:books_admin/repositories/book_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_list_state.dart';

class BookListCubit extends Cubit<BookListState> {
  BookRepository _bookRepository;

  BookListCubit({BookRepository bookRepository}) : _bookRepository = bookRepository ?? BookRepository(), super(BookListState.initial());

  Future<void> initialize() async {
    emit(BookListState.loadingFirstBooks());
    try {
      List<Book> books = await _bookRepository.getInitialBooks();
      emit(BookListState.loaded(books, books.length == 10));
    } catch(_) {
      emit(BookListState.error());
    }
  }

  Future<void> loadMoreBooks() async {
    if(state.status != BookListStatus.loaded || state.loadingMore != false || state.canLoadMore != true) return;
    emit(state.copyWith(loadingMore: true));

    List<Book> newBooks = [];
    bool canLoadMore = true;
    final int limit = 7;
    try {
      newBooks = await _bookRepository.loadBooksAfter(state.books.last, limit: limit);
      canLoadMore = newBooks.length == limit;
    } catch(_) {}
    emit(state.copyWith(
      loadingMore: false,
      canLoadMore: canLoadMore,
      books: state.books..addAll(newBooks)
    ));
  }

  Future<void> refresh() async {
    try {
      List<Book> books = await _bookRepository.getInitialBooks();
      emit(BookListState.loaded(books, books.length == 10));
    } catch(_) {
      emit(BookListState.error());
    }
  }
}