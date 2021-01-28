import 'package:formz/formz.dart';

enum ReviewInputError {empty, too_long}

class ReviewInput extends FormzInput<String, ReviewInputError> {
  const ReviewInput.pure() : super.pure('');
  const ReviewInput.dirty({String value = ''}) : super.dirty(value);

  @override
  ReviewInputError validator(String value) {
    if(value.length == 0) return ReviewInputError.empty;
    if(value.length > 4096) return ReviewInputError.too_long;
    return null;
  }
}