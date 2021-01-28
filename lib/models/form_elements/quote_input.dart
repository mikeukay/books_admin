import 'package:formz/formz.dart';

enum QuoteInputError {empty, too_long}

class QuoteInput extends FormzInput<String, QuoteInputError> {
  const QuoteInput.pure() : super.pure('');
  const QuoteInput.dirty({String value = ''}) : super.dirty(value);

  @override
  QuoteInputError validator(String value) {
    if(value.length == 0) return QuoteInputError.empty;
    if(value.length > 4096) return QuoteInputError.too_long;
    return null;
  }
}