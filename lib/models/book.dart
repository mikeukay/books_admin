import 'package:books_admin/models/quote.dart';
import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String photoUrl;
  final DateTime dateRead;
  final double rating;
  final String review;
  final List<Quote> quotes;

  const Book({
    this.id,
    this.title,
    this.author,
    this.photoUrl,
    this.dateRead,
    this.rating,
    this.review,
    this.quotes
  });

  @override
  List<Object> get props => [id, title, author, photoUrl, dateRead, rating, review, quotes];

  Book copyWith({
    String id,
    String title,
    String author,
    String photoUrl,
    DateTime dateRead,
    double rating,
    String review,
    List<Quote> quotes,
  }) => Book(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author ?? this.author,
    photoUrl: photoUrl ?? this.photoUrl,
    dateRead: dateRead ?? this.dateRead,
    rating: rating ?? this.rating,
    review: review ?? this.review,
    quotes: quotes ?? this.quotes,
  );

  static Book fromMap(Map<String, dynamic> d) => Book(
    id: d['id'],
    title: d['title'],
    author: d['author'],
    photoUrl: d['photo_url'],
    dateRead: d['date_read'].toDate(),
    rating: d['rating'],
    review: d['review'],
    quotes: <Quote>[],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'author': author,
    'photo_url': photoUrl,
    'date_read': dateRead,
    'rating': rating,
    'review': review,
  };
}