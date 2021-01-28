part of 'create_book_cubit.dart';

class CreateBookState extends Equatable {
  final FormzStatus status;
  final TitleInput title;
  final PhotoUrlInput photoUrl;
  final AuthorInput author;
  final DateReadInput dateRead;
  final RatingInput rating;
  final ReviewInput review;

  const CreateBookState({
    this.status = FormzStatus.pure,
    this.title = const TitleInput.pure(),
    this.author = const AuthorInput.pure(),
    this.photoUrl = const PhotoUrlInput.pure(),
    this.dateRead = const DateReadInput.pure(),
    this.rating = const RatingInput.pure(),
    this.review = const ReviewInput.pure(),
  });

  CreateBookState copyWith({
    FormzStatus status,
    TitleInput title,
    AuthorInput author,
    PhotoUrlInput photoUrl,
    DateReadInput dateRead,
    RatingInput rating,
    ReviewInput review,
  }) {
    return CreateBookState(
      status: status ?? this.status,
      title: title ?? this.title,
      author: author ?? this.author,
      photoUrl: photoUrl ?? this.photoUrl,
      dateRead: dateRead ?? this.dateRead,
      rating: rating ?? this.rating,
      review: review ?? this.review
    );
  }

  @override
  List<Object> get props => [status, title, author, photoUrl, dateRead, rating, review];
}
