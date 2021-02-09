part of 'edit_book_cubit.dart';

enum EditBookStatus { loaded, error }

class EditBookState extends Equatable {
  final EditBookStatus status;
  final Book book;

  const EditBookState._({
    this.status = EditBookStatus.loaded,
    this.book
  });

  const EditBookState.initial(Book book) : this._(book: book);
  const EditBookState.error() : this._(status: EditBookStatus.error);
  const EditBookState.modifyBook(Book book) : this._(book: book);

  @override
  List<Object> get props => [status, book];
}