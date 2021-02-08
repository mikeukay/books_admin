part of 'book_list_cubit.dart';

enum BookListStatus {not_initialized, loading, loaded, load_error}

class BookListState extends Equatable {
  final BookListStatus status;
  final bool loadingMore;
  final bool canLoadMore;
  final List<Book> books;

  const BookListState._({
    this.status = BookListStatus.not_initialized,
    this.loadingMore = false,
    this.canLoadMore = false,
    this.books,
  });

  const BookListState.initial() : this._();
  const BookListState.loadingFirstBooks() : this._(status: BookListStatus.loading);
  const BookListState.error() : this._(status: BookListStatus.load_error);
  const BookListState.loaded(List<Book> books, bool canLoadMore) : this._(
    status: BookListStatus.loaded,
    books: books,
    canLoadMore: canLoadMore,
  );

  @override
  List<Object> get props => [status, loadingMore, canLoadMore, books];

  BookListState copyWith({
    BookListStatus status,
    bool loadingMore,
    bool canLoadMore,
    List<Book> books,
  }) {
    return BookListState._(
      status: status ?? this.status,
      loadingMore: loadingMore ?? this.loadingMore,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      books: books ?? this.books,
    );
  }
}