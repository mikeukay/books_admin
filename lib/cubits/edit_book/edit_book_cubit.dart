import 'dart:async';

import 'package:books_admin/models/book.dart';
import 'package:books_admin/models/form_elements/form_elements.dart';
import 'package:books_admin/models/quote.dart';
import 'package:books_admin/repositories/book_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_book_state.dart';

class EditBookCubit extends Cubit<EditBookState> {
  final BookRepository _bookRepository;
  StreamSubscription _bookStreamSubscription;

  EditBookCubit(
      Book initialBookObj,
      {BookRepository bookRepo}
  ) : _bookRepository = bookRepo ?? BookRepository(),
      super(EditBookState.initial(initialBookObj)) {
    try {
      _bookStreamSubscription =
          _bookRepository.book(initialBookObj.id).listen((modifiedBook) {
            if (modifiedBook == null)
              emit(EditBookState.error());
            else
              emit(EditBookState.modifyBook(modifiedBook));
          });
    } catch(_) {
      emit(EditBookState.error());
    }
  }

  @override
  Future<void> close() => _bookStreamSubscription.cancel().then((_) => super.close());

  void deleteBook() {
    if(state.book == null) return;
    _bookRepository.deleteBook(state.book.id);
  }

  void updateBookTitle(String newTitle) {
    if(state.book == null) return;
    if(TitleInput.dirty(value: newTitle).invalid) return;
    _bookRepository.updateBook(state.book, state.book.copyWith(title: newTitle));
  }

  void updateBookAuthor(String newAuthor) {
    if(state.book == null) return;
    if(AuthorInput.dirty(value: newAuthor).invalid) return;
    _bookRepository.updateBook(state.book, state.book.copyWith(author: newAuthor));
  }

  void updateBookDateRead(DateTime newDateRead) {
    if(state.book == null) return;
    if(DateReadInput.dirty(value: newDateRead).invalid) return;
    _bookRepository.updateBook(state.book, state.book.copyWith(dateRead: newDateRead));
  }

  void updateBookRating(double newRating) {
    if(state.book == null) return;
    if(RatingInput.dirty(value: newRating).invalid) return;
    _bookRepository.updateBook(state.book, state.book.copyWith(rating: newRating));
  }

  void updateBookPhotoUrl(String newPhotoUrl) {
    if(state.book == null) return;
    if(PhotoUrlInput.dirty(value: newPhotoUrl).invalid) return;
    _bookRepository.updateBook(state.book, state.book.copyWith(photoUrl: newPhotoUrl));
  }

  void updateBookReview(String newReview) {
    if(state.book == null) return;
    if(ReviewInput.dirty(value: newReview).invalid) return;
    _bookRepository.updateBook(state.book, state.book.copyWith(review: newReview));
  }

  void addQuote(String quoteText) {
    if(state.book == null) return;
    if(QuoteInput.dirty(value: quoteText).invalid) return;

    Quote model = Quote(text: quoteText);
    List<Quote> newQuotes = state.book.quotes?.toList() ?? [];
    newQuotes.add(model);

    _bookRepository.updateBook(state.book, state.book.copyWith(quotes: newQuotes));
  }

  void moveQuoteUp(int index) {
    // up means closer to the first quote, which has index 0
    // so a quote needs to be moved to a lower index to be 'moved up'
    if(state.book == null) return;
    if(state.book.quotes == null) return;
    if(index < 1 || index >= state.book.quotes.length) return;

    List<Quote> newQuotes = state.book.quotes.toList();
    Quote toMoveUp = newQuotes[index];
    newQuotes[index] = newQuotes[index - 1];
    newQuotes[index - 1] = toMoveUp;

    _bookRepository.updateBook(state.book, state.book.copyWith(quotes: newQuotes));
  }

  void moveQuoteDown(int index) {
    /* super hack */
    moveQuoteUp(index + 1);
  }

  void deleteQuote(int index) {
    if(state.book == null) return;
    if(state.book.quotes == null) return;
    if(index < 0 || index >= state.book.quotes.length) return;

    List<Quote> newQuotes = state.book.quotes.toList();
    newQuotes.removeAt(index);

    _bookRepository.updateBook(state.book, state.book.copyWith(quotes: newQuotes));
  }
}