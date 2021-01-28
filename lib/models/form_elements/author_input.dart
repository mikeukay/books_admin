import 'package:formz/formz.dart';

enum AuthorInputError {empty, too_long}

class AuthorInput extends FormzInput<String, AuthorInputError> {
  const AuthorInput.pure() : super.pure('');
  const AuthorInput.dirty({String value = ''}) : super.dirty(value);

  @override
  AuthorInputError validator(String value) {
    if(value.length == 0) return AuthorInputError.empty;
    if(value.length > 128) return AuthorInputError.too_long;
    return null;
  }
}