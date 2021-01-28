import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final String text;

  Quote({this.text});

  @override
  List<Object> get props => [text];

  static Quote fromMap(Map<String, dynamic> d) => Quote(
    text: d['text'],
  );

  Map<String, dynamic> toMap() => {
    'text': text,
  };
}
