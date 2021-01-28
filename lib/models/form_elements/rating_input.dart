import 'package:formz/formz.dart';

enum RatingInputError {too_small, too_big}

class RatingInput extends FormzInput<double, RatingInputError> {
  const RatingInput.pure() : super.pure(5.0);
  const RatingInput.dirty({double value = 5.0}) : super.dirty(value);

  @override
  RatingInputError validator(double value) {
    if(value < 0.0) return RatingInputError.too_small;
    if(value > 10.0) return RatingInputError.too_big;
    return null;
  }
}