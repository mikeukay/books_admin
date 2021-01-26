import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String email;

  const AppUser({this.email}) : assert(email != null);

  bool get isAdmin => email.endsWith("@your-domain.com"); // TODO: modify this

  @override
  List<Object> get props => [email];
}