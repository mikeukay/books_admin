part of 'auth_cubit.dart';

enum AuthStatus { not_authenticated, authenticating, authenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final AppUser currentUser;

  const AuthState._({
    this.status = AuthStatus.not_authenticated,
    this.currentUser
  });

  const AuthState.initial() : this._();
  const AuthState.loading() : this._(status: AuthStatus.authenticating);
  const AuthState.loggedOut() : this._();
  const AuthState.loggedIn(AppUser user) : this._(
    status: AuthStatus.authenticated,
    currentUser: user
  );

  @override
  List<Object> get props => [status, currentUser];
}