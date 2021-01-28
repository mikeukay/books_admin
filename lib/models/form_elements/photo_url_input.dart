import 'package:formz/formz.dart';
import 'package:validators/validators.dart';

enum PhotoUrlInputError {empty, too_long, url_not_valid}

class PhotoUrlInput extends FormzInput<String, PhotoUrlInputError> {
  const PhotoUrlInput.pure() : super.pure('');
  const PhotoUrlInput.dirty({String value = ''}) : super.dirty(value);

  @override
  PhotoUrlInputError validator(String value) {
    if(value.length == 0) return PhotoUrlInputError.empty;
    if(value.length > 256) return PhotoUrlInputError.too_long;
    if(!isURL(value)) return PhotoUrlInputError.url_not_valid;
    return null;
  }
}