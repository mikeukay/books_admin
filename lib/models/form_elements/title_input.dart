import 'package:formz/formz.dart';

enum TitleInputError {empty, too_long}

class TitleInput extends FormzInput<String, TitleInputError> {
  const TitleInput.pure() : super.pure('');
  const TitleInput.dirty({String value = ''}) : super.dirty(value);

  @override
  TitleInputError validator(String value) {
    if(value.length == 0) return TitleInputError.empty;
    if(value.length > 128) return TitleInputError.too_long;
    return null;
  }
}