import 'package:books_admin/models/book.dart';
import 'package:books_admin/models/form_elements/form_elements.dart';
import 'package:books_admin/repositories/book_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'create_book_state.dart';

class CreateBookCubit extends Cubit<CreateBookState> {
  final BookRepository _bookRepository;
  CreateBookCubit({BookRepository bookRepository}) : _bookRepository = bookRepository ?? BookRepository(), super(const CreateBookState());

  FormzStatus validateFormState(CreateBookState state) {
    return Formz.validate([
      state.title,
      state.author,
      state.photoUrl,
      state.dateRead,
      state.rating,
      state.review
    ]);
  }

  void updateTitle(String newValue) {
    final title = TitleInput.dirty(value: newValue);
    final newState = state.copyWith(title: title);
    final FormzStatus newFormStatus = validateFormState(newState);

    emit(newState.copyWith(status: newFormStatus));
  }

  void updateAuthor(String newValue) {
    final author = AuthorInput.dirty(value: newValue);
    final newState = state.copyWith(author: author);
    final FormzStatus newFormStatus = validateFormState(newState);

    emit(newState.copyWith(status: newFormStatus));
  }

  void updatePhotoUrl(String newValue) {
    final photoUrl = PhotoUrlInput.dirty(value: newValue);
    final newState = state.copyWith(photoUrl: photoUrl);
    final FormzStatus newFormStatus = validateFormState(newState);

    emit(newState.copyWith(status: newFormStatus));
  }

  void updateDateRead(DateTime newValue) {
    final dateRead = DateReadInput.dirty(value: newValue);
    final newState = state.copyWith(dateRead: dateRead);
    final FormzStatus newFormStatus = validateFormState(newState);

    emit(newState.copyWith(status: newFormStatus));
  }

  void updateRating(double newValue) {
    final rating = RatingInput.dirty(value: newValue);
    final newState = state.copyWith(rating: rating);
    final FormzStatus newFormStatus = validateFormState(newState);

    emit(newState.copyWith(status: newFormStatus));
  }

  void updateReview(String newValue) {
    final review = ReviewInput.dirty(value: newValue);
    final newState = state.copyWith(review: review);
    final FormzStatus newFormStatus = validateFormState(newState);

    emit(newState.copyWith(status: newFormStatus));
  }

  void submitForm() async {
    if(state.status.isValidated) {
      try {
        emit(state.copyWith(status: FormzStatus.submissionInProgress));

        final Book bookToCreate = Book(
          title: state.title.value,
          author: state.author.value,
          photoUrl: state.photoUrl.value,
          dateRead: state.dateRead.value,
          rating: state.rating.value,
          review: state.review.value,
          quotes: []
        );

        await _bookRepository.setBook(bookToCreate);

        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch(_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}