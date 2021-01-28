import 'package:formz/formz.dart';

enum DateReadInputError {not_set}

class DateReadInput extends FormzInput<DateTime, DateReadInputError> {
  const DateReadInput.pure() : super.pure(null);
  const DateReadInput.dirty({DateTime value}) : super.dirty(value);

  @override
  DateReadInputError validator(DateTime value) {
    if(value == null) return DateReadInputError.not_set;
    return null;
  }
}